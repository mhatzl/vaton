with Vaton.Integer_Conversions;
with Vaton.Float_Conversions;

package body Vaton with SPARK_Mode is

   function Is_Possible_Piece
     (Partial_Number : Number_Pieces; Character : Wide_Character;
      Decimal_Point  : Wide_Character := '.') return Boolean
   is
   begin
      if Partial_Number.Next_Must_Be_Digit and then not Is_Digit (Character) then
         return False;
      elsif Character = '0' and then not Digit_Array.Is_Empty (Partial_Number.Whole)
        and then
          Digit_Array.Element
            (Partial_Number.Whole, Digit_Array.First_Index (Partial_Number.Whole)) = 0 then
         return False;
      elsif Character = '-'
        and then
        ((not Partial_Number.Whole_Is_Negative and then Digit_Array.Is_Empty (Partial_Number.Whole))
         or else
         (not Digit_Array.Is_Empty (Partial_Number.Whole) and then Partial_Number.Has_Exponent
          and then not Partial_Number.Exponent_Is_Negative
          and then Digit_Array.Is_Empty (Partial_Number.Exponent)))
      then
         return True;
      elsif (Character = 'e' or else Character = 'E')
        and then not Digit_Array.Is_Empty (Partial_Number.Whole)
        and then Digit_Array.Is_Empty (Partial_Number.Fraction)
        and then not Partial_Number.Exponent_Is_Negative
      then
         return True;
      elsif Character = Decimal_Point and then not Digit_Array.Is_Empty (Partial_Number.Whole)
        and then not Partial_Number.Has_Exponent
      then
         return True;
      elsif Character = '+' and then Partial_Number.Has_Exponent
        and then Digit_Array.Is_Empty (Partial_Number.Exponent)
      then
         return True;
      elsif Is_Digit (Character) then
         -- Exponent is restricted to Integer
         if (Digit_Array.Length (Partial_Number.Exponent) + 1) * BASE_10_LENGTH_TO_BIT_SIZE >= Standard.Integer'Size then
            return False;
         end if;

         if Digit_Array.Capacity(Partial_Number.Whole) < Digit_Array.Extended_Index'Last and then
           Partial_Number.Has_Fraction = False and then Partial_Number.Has_Exponent = False then
            return False;
         elsif Digit_Array.Capacity(Partial_Number.Fraction) < Digit_Array.Extended_Index'Last and then
           Partial_Number.Has_Exponent = False then
            return False;
         elsif Digit_Array.Capacity(Partial_Number.Exponent) < Digit_Array.Extended_Index'Last then
               return False;
         end if;

         return True;
      elsif Character = '_'
        and then not
        (Digit_Array.Is_Empty (Partial_Number.Whole)
         or else
         (Partial_Number.Has_Exponent and then Digit_Array.Is_Empty (Partial_Number.Exponent)))
      then
         return True;
      else
         return False;
      end if;
   end Is_Possible_Piece;

   function Is_Valid_Partial_Number (Partial_Number : Number_Pieces) return Boolean is
   begin
      if Digit_Array.Is_Empty (Partial_Number.Whole)
        and then
        (not Digit_Array.Is_Empty (Partial_Number.Fraction)
         or else not Digit_Array.Is_Empty (Partial_Number.Exponent)
         or else Partial_Number.Exponent_Is_Negative or else Partial_Number.Has_Exponent
         or else Partial_Number.Has_Fraction)
      then
         return False;
      elsif Digit_Array.Last_Index(Partial_Number.Whole) > Digit_Array.No_Index
        and then Digit_Array.Length (Partial_Number.Whole) > 1
        and then Digit_Array.Element (Partial_Number.Whole, Digit_Array.First_Index (Partial_Number.Whole)) = 0
      then
         return False;
      elsif not Digit_Array.Is_Empty (Partial_Number.Fraction)
        and then not Partial_Number.Has_Fraction
      then
         return False;
      elsif not Digit_Array.Is_Empty (Partial_Number.Exponent)
        and then not Partial_Number.Has_Exponent
      then
         return False;
      elsif Partial_Number.Exponent_Is_Negative and then not Partial_Number.Has_Exponent then
         return False;
      elsif not Digit_Array.Is_Empty (Partial_Number.Exponent)
        and then To_Integer (Partial_Number.Exponent, Partial_Number.Exponent_Is_Negative).Kind /= Integer
      then
         return False;
      elsif Digit_Array.Length (Partial_Number.Whole) > BIG_NUMBER_DIGIT_LIMIT
        or else Digit_Array.Length (Partial_Number.Fraction) > BIG_NUMBER_DIGIT_LIMIT
        or else Digit_Array.Length (Partial_Number.Exponent) > BIG_NUMBER_DIGIT_LIMIT then
         return False;
      else
         return True;
      end if;
   end Is_Valid_Partial_Number;

   function Is_Valid_Number (Partial_Number : Number_Pieces) return Boolean is
   begin
      if not Is_Valid_Partial_Number (Partial_Number => Partial_Number) then
         return False;
      elsif Digit_Array.Is_Empty (Partial_Number.Whole) then
         return False;
      elsif Partial_Number.Has_Fraction and then Digit_Array.Is_Empty (Partial_Number.Fraction) then
         return False;
      elsif Partial_Number.Has_Exponent and then Digit_Array.Is_Empty (Partial_Number.Exponent) then
         return False;
      elsif Partial_Number.Exponent_Is_Negative and then not Partial_Number.Has_Exponent then
         return False;
      elsif Partial_Number.Next_Must_Be_Digit then
         return False;
      else
         return True;
      end if;
   end Is_Valid_Number;

   function To_Number (Partial_Number : Number_Pieces) return Number is
   begin
      if Digit_Array.Is_Empty (Partial_Number.Whole)
        or else Digit_Array.Length (Partial_Number.Whole) > BIG_NUMBER_DIGIT_LIMIT - Digit_Array.Length (Partial_Number.Fraction)
      then
         return Number'(Kind => NaN);
      elsif Partial_Number.Has_Exponent or else Partial_Number.Has_Fraction then
         declare
            Exponent : constant Number := To_Integer (Partial_Number.Exponent, Partial_Number.Exponent_Is_Negative);
            Exponent_Value : constant Standard.Integer := (if Exponent.Kind = Integer then Exponent.Integer else 0);
         begin
            if Digit_Array.Length (Partial_Number.Whole) + Digit_Array.Length (Partial_Number.Fraction) < Standard.Float'Digits
              and then ((Exponent_Value < 0 and then Exponent_Value >= MIN_FLOAT_EXPONENT)
                        or else (Exponent_Value >= 0
                                 and then Exponent_Value <= MAX_FLOAT_EXPONENT + Standard.Float'Digits - Digit_Array.Length (Partial_Number.Fraction) - Digit_Array.Length (Partial_Number.Whole)))
            then
               declare
                  Result : Number(Float);
                  function Combine is new Vaton.Float_Conversions.Combine(Float_Base => Standard.Float,
                                                                          MAX_DIGITS => MAX_FLOAT_EXPONENT + Standard.Float'Digits,
                                                                          MIN_DIGITS => MIN_FLOAT_EXPONENT - Standard.Float'Digits,
                                                                          "+" => Standard."+",
                                                                          "*" => Standard."*",
                                                                          "/" => Standard."/",
                                                                          "**" => Standard."**",
                                                                          "<" => Standard."<",
                                                                          To_Float_Base => Vaton.Float_Conversions.Number_To_Float);
               begin
                  Result.Float := Combine(Partial_Number, Exponent_Value);
                  return Result;
               end;
            elsif Digit_Array.Length (Partial_Number.Whole) + Digit_Array.Length (Partial_Number.Fraction) < Standard.Long_Float'Digits
              and then ((Exponent_Value < 0 and then Exponent_Value >= MIN_LONG_FLOAT_EXPONENT)
                        or else (Exponent_Value >= 0
                                 and then Exponent_Value <= MAX_LONG_FLOAT_EXPONENT + Standard.Long_Float'Digits - Digit_Array.Length (Partial_Number.Fraction) - Digit_Array.Length (Partial_Number.Whole)))
            then
               declare
                  Result : Number(Long_Float);
                  function Combine is new Vaton.Float_Conversions.Combine(Float_Base => Standard.Long_Float,
                                                                          MAX_DIGITS => MAX_LONG_FLOAT_EXPONENT + Standard.Long_Float'Digits,
                                                                          MIN_DIGITS => MIN_LONG_FLOAT_EXPONENT - Standard.Long_Float'Digits,
                                                                          "+" => Standard."+",
                                                                          "*" => Standard."*",
                                                                          "/" => Standard."/",
                                                                          "**" => Standard."**",
                                                                          "<" => Standard."<",
                                                                          To_Float_Base => Vaton.Float_Conversions.Number_To_Long_Float);
               begin
                  Result.Long_Float := Combine(Partial_Number, Exponent_Value);
                  return Result;
               end;
            elsif Digit_Array.Length (Partial_Number.Whole) + Digit_Array.Length (Partial_Number.Fraction) < Standard.Long_Long_Float'Digits
              and then ((Exponent_Value < 0 and then Exponent_Value >= MIN_LONG_LONG_FLOAT_EXPONENT)
                        or else (Exponent_Value >= 0
                                 and then Exponent_Value <= MAX_LONG_LONG_FLOAT_EXPONENT + Standard.Long_Long_Float'Digits - Digit_Array.Length (Partial_Number.Fraction) - Digit_Array.Length (Partial_Number.Whole)))
            then
               declare
                  Result : Number(Long_Long_Float);
                  function Combine is new Vaton.Float_Conversions.Combine(Float_Base => Standard.Long_Long_Float,
                                                                          MAX_DIGITS => MAX_LONG_LONG_FLOAT_EXPONENT + Standard.Long_Long_Float'Digits,
                                                                          MIN_DIGITS => MIN_LONG_LONG_FLOAT_EXPONENT - Standard.Long_Long_Float'Digits,
                                                                          "+" => Standard."+",
                                                                          "*" => Standard."*",
                                                                          "/" => Standard."/",
                                                                          "**" => Standard."**",
                                                                          "<" => Standard."<",
                                                                          To_Float_Base => Vaton.Float_Conversions.Number_To_Long_Long_Float);
               begin
                  Result.Long_Long_Float := Combine(Partial_Number, Exponent_Value);
                  return Result;
               end;
            elsif Digit_Array.Length (Partial_Number.Whole) > BIG_NUMBER_DIGIT_LIMIT - Digit_Array.Length (Partial_Number.Fraction)
              or else (Exponent_Value < 0 and then Exponent_Value + Digit_Array.Length (Partial_Number.Whole) + Digit_Array.Length (Partial_Number.Fraction) < (-BIG_NUMBER_DIGIT_LIMIT))
              or else (Exponent_Value >= 0 and then Exponent_Value > BIG_NUMBER_DIGIT_LIMIT - Digit_Array.Length (Partial_Number.Fraction) - Digit_Array.Length (Partial_Number.Whole))
            then
               return Number'(Kind => NaN);
            else
               return Vaton.Float_Conversions.Convert_Big_Real(Partial_Number, Exponent_Value);
            end if;
         end;
      else
         return To_Integer (Partial_Number.Whole, Partial_Number.Whole_Is_Negative);
      end if;
   end To_Number;

   function To_Integer
     (Partial_Integer : Digit_Array.Unbound_Array; Is_Negative : Boolean) return Number
   is
   begin
      if Digit_Array.Is_Empty (Partial_Integer)
        or else Digit_Array.Length (Partial_Integer) > BIG_NUMBER_DIGIT_LIMIT
      then
         return Number'(Kind => NaN);
      elsif Digit_Array.Length (Partial_Integer) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Integer'Size then
         declare
            Result : Number (Integer);
            function Convert is new Vaton.Integer_Conversions.Convert(Integer_Base => Standard.Integer,
                                                                      "-" => Standard."-",
                                                                      "+" => Standard."+",
                                                                      "*" => Standard."*",
                                                                      To_Integer_Base => Vaton.Integer_Conversions.Integer_To_Integer);
         begin
            Result.Integer := Convert(Partial_Integer, Is_Negative);
            return Result;
         end;
      elsif Digit_Array.Length (Partial_Integer) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Long_Integer'Size then
         declare
            Result : Number (Long_Integer);
            function Convert is new Vaton.Integer_Conversions.Convert(Integer_Base => Standard.Long_Integer,
                                                                      "-" => Standard."-",
                                                                      "+" => Standard."+",
                                                                      "*" => Standard."*",
                                                                      To_Integer_Base => Vaton.Integer_Conversions.Integer_To_Long_Integer);
         begin
            Result.Long_Integer := Convert(Partial_Integer, Is_Negative);
            return Result;
         end;
      elsif Digit_Array.Length (Partial_Integer) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Long_Long_Integer'Size then
         declare
            Result : Number (Long_Long_Integer);
            function Convert is new Vaton.Integer_Conversions.Convert(Integer_Base => Standard.Long_Long_Integer,
                                                                      "-" => Standard."-",
                                                                      "+" => Standard."+",
                                                                      "*" => Standard."*",
                                                                      To_Integer_Base => Vaton.Integer_Conversions.Integer_To_Long_Long_Integer);
         begin
            Result.Long_Long_Integer := Convert(Partial_Integer, Is_Negative);
            return Result;
         end;
      else
         return Vaton.Integer_Conversions.Convert_Big_Integer(Partial_Integer, Is_Negative);
      end if;
   end To_Integer;

   procedure Append
     (Partial_Number : in out Number_Pieces; Character : Wide_Character; Success : out Boolean;
      Decimal_Point  :        Wide_Character := '.')
   is
   begin
      Success := True;
      if Character = '_' then
         Partial_Number.Next_Must_Be_Digit := True;
      elsif Character = '-' then
         Partial_Number.Next_Must_Be_Digit := True;
         if Digit_Array.Is_Empty (Partial_Number.Whole) then
            Partial_Number.Whole_Is_Negative := True;
         elsif Partial_Number.Has_Exponent then
            Partial_Number.Exponent_Is_Negative := True;
         end if;
      elsif Character = '+' then
         Partial_Number.Next_Must_Be_Digit := True;
      elsif Character = 'e' or else Character = 'E' then
         Partial_Number.Has_Exponent := True;
      elsif Character = Decimal_Point then
         Partial_Number.Next_Must_Be_Digit := True;
         Partial_Number.Has_Fraction       := True;
      elsif Is_Digit(Character) then
         Success := False;
         declare
            Number : constant Digit := Character_To_Digit (Character);
         begin
            if Partial_Number.Has_Exponent then
               if Partial_Number.Exponent.Arr = null then
                  Partial_Number.Exponent := Digit_Array.To_Unbound_Array (Initial_Capacity => 5);
               end if;
               if Partial_Number.Exponent.Arr /= null and then Digit_Array.Capacity(Partial_Number.Exponent) < Digit_Array.Extended_Index'Last then
                  Digit_Array.Append (Partial_Number.Exponent, Number, Success);
               end if;
            elsif Partial_Number.Has_Fraction then
               if Partial_Number.Fraction.Arr = null then
                  Partial_Number.Fraction := Digit_Array.To_Unbound_Array (Initial_Capacity => 5);
               end if;
               if Partial_Number.Fraction.Arr /= null and then Digit_Array.Capacity(Partial_Number.Fraction) < Digit_Array.Extended_Index'Last then
                  Digit_Array.Append (Partial_Number.Fraction, Number, Success);
               end if;
            else
               if Partial_Number.Whole.Arr = null then
                  Partial_Number.Whole := Digit_Array.To_Unbound_Array (Initial_Capacity => 10);
               end if;
               if Partial_Number.Whole.Arr /= null and then Digit_Array.Capacity(Partial_Number.Whole) < Digit_Array.Extended_Index'Last then
                  Digit_Array.Append (Partial_Number.Whole, Number, Success);
               end if;
            end if;

            if Success then
               Partial_Number.Next_Must_Be_Digit := False;
            end if;
         end;
      end if;
   end Append;

   procedure Reset (Partial_Number : in out Number_Pieces) is
   begin
      Digit_Array.Clear (Partial_Number.Whole);
      Digit_Array.Clear (Partial_Number.Fraction);
      Digit_Array.Clear (Partial_Number.Exponent);
      Partial_Number.Whole_Is_Negative := False;
      Partial_Number.Exponent_Is_Negative := False;
      Partial_Number.Has_Fraction := False;
      Partial_Number.Has_Exponent := False;
      Partial_Number.Next_Must_Be_Digit := False;
   end Reset;

   function Is_Digit (Character : Wide_Character) return Boolean is
   begin
      case Character is
         when '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' =>
            return True;
         when others =>
            return False;
      end case;
   end Is_Digit;

   function Character_To_Digit (Character : Wide_Character) return Digit is
   begin
      case Character is
         when '0' =>
            return 0;
         when '1' =>
            return 1;
         when '2' =>
            return 2;
         when '3' =>
            return 3;
         when '4' =>
            return 4;
         when '5' =>
            return 5;
         when '6' =>
            return 6;
         when '7' =>
            return 7;
         when '8' =>
            return 8;
         when '9' =>
            return 9;
         when others =>
            raise Program_Error;
      end case;
   end Character_To_Digit;

end Vaton;
