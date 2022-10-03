with Vaton.Integer_Conversions;

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
         if not Digit_Array.Is_Empty (Partial_Number.Exponent) then
            declare
               Split_Exponent : Digit_Array.Unbound_Array;
               Success        : Boolean;
            begin
               Digit_Array.Copy (Split_Exponent, Partial_Number.Exponent, Success);
               if Success and then Split_Exponent.Arr /= null and then Digit_Array.Capacity(Split_Exponent) < Digit_Array.Extended_Index'Last then
                  Digit_Array.Append (Split_Exponent, Character_To_Digit (Character), Success);
                  if Success
                    and then
                      To_Integer (Split_Exponent, Partial_Number.Exponent_Is_Negative).Kind /=
                      Integer
                  then
                     return False;
                  end if;
               end if;
               Digit_Array.Clear(Split_Exponent);
               if not Digit_Array.Is_Empty(Split_Exponent) then
                  raise Program_Error;
               end if;
            end;
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
      elsif Digit_Array.Length (Partial_Number.Whole) > 1
        and then
          Digit_Array.Element
            (Partial_Number.Whole, Digit_Array.First_Index (Partial_Number.Whole)) = 0
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
        and then To_Integer (Partial_Number.Exponent, Partial_Number.Exponent_Is_Negative).Kind /=
          Integer
      then
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
        or else Digit_Array.Length (Partial_Number.Whole) >
          BIG_NUMBER_DIGIT_LIMIT - Digit_Array.Length (Partial_Number.Fraction)
      then
         return Number'(Kind => NaN);
      elsif Partial_Number.Has_Exponent or else Partial_Number.Has_Fraction then
         declare
            Exponent : constant Number :=
              To_Integer (Partial_Number.Exponent, Partial_Number.Exponent_Is_Negative);
         begin
            if Digit_Array.Length (Partial_Number.Whole) +
              Digit_Array.Length (Partial_Number.Fraction) <
              Standard.Float'Digits
              and then
              (Exponent.Kind = NaN
               or else
               (Exponent.Kind = Integer
                and then
                ((Partial_Number.Exponent_Is_Negative
                  and then Exponent.Integer > MIN_FLOAT_EXPONENT)
                 or else Exponent.Integer <=
                   MAX_FLOAT_EXPONENT - Digit_Array.Length (Partial_Number.Whole))))
            then
               declare
                  Combined : Number (Float);
                  Whole    : Number (Float);
                  Old_Index : Natural := Natural'Last;
               begin
                  if Partial_Number.Has_Fraction then
                     for Index in reverse
                       Digit_Array.First_Index (Partial_Number.Fraction) ..
                         Digit_Array.Last_Index (Partial_Number.Fraction)
                     loop
                        if (Combined.Float >= 0.0 and then Standard.Float'Last - Combined.Float > Standard.Float (Digit_Array.Element (Partial_Number.Fraction, Index)))
                          or else Combined.Float < 0.0 then
                           Combined.Float := Combined.Float + Standard.Float (Digit_Array.Element (Partial_Number.Fraction, Index));
                        end if;
                        Combined.Float := Combined.Float / Standard.Float (BASE_10);

                        pragma Loop_Invariant (Old_Index > Index);
                        Old_Index := Index;
                     end loop;
                  end if;

                  Old_Index := 0;
                  for Index in
                    Digit_Array.First_Index (Partial_Number.Whole) ..
                      Digit_Array.Last_Index (Partial_Number.Whole) - 1
                  loop
                     Whole.Float :=
                       Whole.Float +
                       Standard.Float (Digit_Array.Element (Partial_Number.Whole, Index));
                     Whole.Float := Whole.Float * Standard.Float (BASE_10);

                     pragma Loop_Invariant (Old_Index < Index);
                     Old_Index := Index;
                  end loop;
                  Whole.Float :=
                    Whole.Float +
                    Standard.Float
                      (Digit_Array.Element
                         (Partial_Number.Whole, Digit_Array.Last_Index (Partial_Number.Whole)));

                  Combined.Float := Combined.Float + Whole.Float;

                  if Partial_Number.Has_Exponent then
                     Combined.Float :=
                       Combined.Float * (Standard.Float (BASE_10)**Exponent.Integer);
                  end if;

                  if Partial_Number.Whole_Is_Negative then
                     Combined.Float := Combined.Float * (-1.0);
                  end if;

                  return Combined;
               end;
            elsif Digit_Array.Length (Partial_Number.Whole) +
              Digit_Array.Length (Partial_Number.Fraction) <
              Standard.Long_Float'Digits
              and then
              (Exponent.Kind = NaN
               or else
               (Exponent.Kind = Integer
                and then
                ((Partial_Number.Exponent_Is_Negative
                  and then Exponent.Integer > MIN_LONG_FLOAT_EXPONENT)
                 or else Exponent.Integer <=
                   MAX_LONG_FLOAT_EXPONENT - Digit_Array.Length (Partial_Number.Whole))))
            then
               declare
                  Combined : Number (Long_Float);
                  Whole    : Number (Long_Float);
               begin
                  if Partial_Number.Has_Fraction then
                     for Index in reverse
                       Digit_Array.First_Index (Partial_Number.Fraction) ..
                         Digit_Array.Last_Index (Partial_Number.Fraction)
                     loop
                        Combined.Long_Float :=
                          Combined.Long_Float +
                          Standard.Long_Float
                            (Digit_Array.Element (Partial_Number.Fraction, Index));
                        Combined.Long_Float := Combined.Long_Float / Standard.Long_Float (BASE_10);
                     end loop;
                  end if;

                  for Index in
                    Digit_Array.First_Index (Partial_Number.Whole) ..
                      Digit_Array.Last_Index (Partial_Number.Whole) - 1
                  loop
                     Whole.Long_Float :=
                       Whole.Long_Float +
                       Standard.Long_Float (Digit_Array.Element (Partial_Number.Whole, Index));
                     Whole.Long_Float := Whole.Long_Float * Standard.Long_Float (BASE_10);
                  end loop;
                  Whole.Long_Float :=
                    Whole.Long_Float +
                    Standard.Long_Float
                      (Digit_Array.Element
                         (Partial_Number.Whole, Digit_Array.Last_Index (Partial_Number.Whole)));

                  Combined.Long_Float := Combined.Long_Float + Whole.Long_Float;

                  if Partial_Number.Has_Exponent then
                     Combined.Long_Float :=
                       Combined.Long_Float * (Standard.Long_Float (BASE_10)**Exponent.Integer);
                  end if;

                  if Partial_Number.Whole_Is_Negative then
                     Combined.Long_Float := Combined.Long_Float * (-1.0);
                  end if;

                  return Combined;
               end;
            elsif Digit_Array.Length (Partial_Number.Whole) +
              Digit_Array.Length (Partial_Number.Fraction) <
              Standard.Long_Long_Float'Digits
              and then
              (Exponent.Kind = NaN
               or else
               (Exponent.Kind = Integer
                and then
                ((Partial_Number.Exponent_Is_Negative
                  and then Exponent.Integer > MIN_LONG_LONG_FLOAT_EXPONENT)
                 or else Exponent.Integer <=
                   MAX_LONG_LONG_FLOAT_EXPONENT - Digit_Array.Length (Partial_Number.Whole))))
            then
               declare
                  Combined : Number (Long_Long_Float);
                  Whole    : Number (Long_Long_Float);
               begin
                  if Partial_Number.Has_Fraction then
                     for Index in reverse
                       Digit_Array.First_Index (Partial_Number.Fraction) ..
                         Digit_Array.Last_Index (Partial_Number.Fraction)
                     loop
                        Combined.Long_Long_Float :=
                          Combined.Long_Long_Float +
                          Standard.Long_Long_Float
                            (Digit_Array.Element (Partial_Number.Fraction, Index));
                        Combined.Long_Long_Float :=
                          Combined.Long_Long_Float / Standard.Long_Long_Float (BASE_10);
                     end loop;
                  end if;

                  for Index in
                    Digit_Array.First_Index (Partial_Number.Whole) ..
                      Digit_Array.Last_Index (Partial_Number.Whole) - 1
                  loop
                     Whole.Long_Long_Float :=
                       Whole.Long_Long_Float +
                       Standard.Long_Long_Float (Digit_Array.Element (Partial_Number.Whole, Index));
                     Whole.Long_Long_Float :=
                       Whole.Long_Long_Float * Standard.Long_Long_Float (BASE_10);
                  end loop;
                  Whole.Long_Long_Float :=
                    Whole.Long_Long_Float +
                    Standard.Long_Long_Float
                      (Digit_Array.Element
                         (Partial_Number.Whole, Digit_Array.Last_Index (Partial_Number.Whole)));

                  Combined.Long_Long_Float := Combined.Long_Long_Float + Whole.Long_Long_Float;

                  if Partial_Number.Has_Exponent then
                     Combined.Long_Long_Float :=
                       Combined.Long_Long_Float *
                       (Standard.Long_Long_Float (BASE_10)**Exponent.Integer);
                  end if;

                  if Partial_Number.Whole_Is_Negative then
                     Combined.Long_Long_Float := Combined.Long_Long_Float * (-1.0);
                  end if;

                  return Combined;
               end;
            elsif Exponent.Kind = Integer
              and then Digit_Array.Length (Partial_Number.Whole) >
                BIG_NUMBER_DIGIT_LIMIT - Exponent.Integer -
                  Digit_Array.Length (Partial_Number.Fraction)
            then
               return Number'(Kind => NaN);
            else
               declare
                  Combined : Number (Big_Real);
                  Whole    : Number (Big_Real);
               begin
                  if Partial_Number.Has_Fraction then
                     for Index in reverse
                       Digit_Array.First_Index (Partial_Number.Fraction) ..
                         Digit_Array.Last_Index (Partial_Number.Fraction)
                     loop
                        Combined.Big_Real :=
                          Big_Numbers.Big_Reals."+"
                            (Combined.Big_Real,
                             Big_Numbers.Big_Reals.To_Real
                               (Standard.Integer
                                  (Digit_Array.Element (Partial_Number.Fraction, Index))));
                        Combined.Big_Real :=
                          Big_Numbers.Big_Reals."/"
                            (Combined.Big_Real, Big_Numbers.Big_Reals.To_Real (BASE_10));
                     end loop;
                  end if;

                  for Index in
                    Digit_Array.First_Index (Partial_Number.Whole) ..
                      Digit_Array.Last_Index (Partial_Number.Whole) - 1
                  loop
                     Whole.Big_Real :=
                       Big_Numbers.Big_Reals."+"
                         (Whole.Big_Real,
                          Big_Numbers.Big_Reals.To_Real
                            (Standard.Integer (Digit_Array.Element (Partial_Number.Whole, Index))));
                     Whole.Big_Real :=
                       Big_Numbers.Big_Reals."*"
                         (Whole.Big_Real, Big_Numbers.Big_Reals.To_Real (BASE_10));
                  end loop;
                  Whole.Big_Real :=
                    Big_Numbers.Big_Reals."+"
                      (Whole.Big_Real,
                       Big_Numbers.Big_Reals.To_Real
                         (Standard.Integer
                            (Digit_Array.Element
                               (Partial_Number.Whole,
                                 Digit_Array.Last_Index (Partial_Number.Whole)))));

                  Combined.Big_Real :=
                    Big_Numbers.Big_Reals."+" (Combined.Big_Real, Whole.Big_Real);

                  if Partial_Number.Has_Exponent and then Exponent.Kind = Integer then
                     Combined.Big_Real :=
                       Big_Numbers.Big_Reals."*"
                         (Combined.Big_Real,
                          Big_Numbers.Big_Reals."**"
                            (Big_Numbers.Big_Reals.To_Real (10), Exponent.Integer));
                  end if;

                  if Partial_Number.Whole_Is_Negative then
                     Combined.Big_Real :=
                       Big_Numbers.Big_Reals."*"
                         (Combined.Big_Real, Big_Numbers.Big_Reals.To_Real (-1));
                  end if;

                  return Combined;
               end;
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
      elsif Digit_Array.Length (Partial_Integer) * BASE_10_LENGTH_TO_BIT_SIZE <
        Standard.Integer'Size
      then
         declare
            Result : Number (Integer);
            Combined : Standard.Integer := 0;
            procedure Convert is new Vaton.Integer_Conversions.Convert(Integer_Base => Standard.Integer,
                                                                              Combined => Combined,
                                                                              "-" => Standard."-",
                                                                              "+" => Standard."+",
                                                                              "*" => Standard."*",
                                                                              "/" => Standard."/",
                                                                              "<" => Standard."<",
                                                                              ">" => Standard.">",
                                                                              ">=" => Standard.">=",
                                                                             To_Integer_Base => Vaton.Integer_Conversions.Integer_To_Integer);
         begin
            Convert(Partial_Integer, Is_Negative);
            Result.Integer := Combined;
            return Result;
         end;
      elsif Digit_Array.Length (Partial_Integer) * BASE_10_LENGTH_TO_BIT_SIZE <
        Standard.Long_Integer'Size
      then
         declare
            Result : Number (Long_Integer);
            Combined : Standard.Long_Integer := 0;
            procedure Convert is new Vaton.Integer_Conversions.Convert(Integer_Base => Standard.Long_Integer,
                                                                              Combined => Combined,
                                                                              "-" => Standard."-",
                                                                              "+" => Standard."+",
                                                                              "*" => Standard."*",
                                                                              "/" => Standard."/",
                                                                              "<" => Standard."<",
                                                                              ">" => Standard.">",
                                                                              ">=" => Standard.">=",
                                                                             To_Integer_Base => Vaton.Integer_Conversions.Integer_To_Long_Integer);
         begin
            Convert(Partial_Integer, Is_Negative);
            Result.Long_Integer := Combined;
            return Result;
         end;
      elsif Digit_Array.Length (Partial_Integer) * BASE_10_LENGTH_TO_BIT_SIZE <
        Standard.Long_Long_Integer'Size
      then
         declare
            Result : Number (Long_Long_Integer);
            Combined : Standard.Long_Long_Integer := 0;
            procedure Convert is new Vaton.Integer_Conversions.Convert(Integer_Base => Standard.Long_Long_Integer,
                                                                              Combined => Combined,
                                                                              "-" => Standard."-",
                                                                              "+" => Standard."+",
                                                                              "*" => Standard."*",
                                                                              "/" => Standard."/",
                                                                              "<" => Standard."<",
                                                                              ">" => Standard.">",
                                                                              ">=" => Standard.">=",
                                                                             To_Integer_Base => Vaton.Integer_Conversions.Integer_To_Long_Long_Integer);
         begin
            Convert(Partial_Integer, Is_Negative);
            Result.Long_Long_Integer := Combined;
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
         elsif Digit_Array.Is_Empty (Partial_Number.Exponent) then
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
         Partial_Number.Next_Must_Be_Digit := False;
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
