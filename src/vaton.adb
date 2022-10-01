package body Vaton is

   function Is_Possible_Piece (Partial_Number : Number_Pieces; Character : Wide_Character; Decimal_Point : Wide_Character := '.') return Boolean is
   begin
      if Partial_Number.Next_Must_Be_Digit and then not Is_Digit(Character) then
         return False;
      elsif Character = '-' and then
        ((not Partial_Number.Whole_Is_Negative and then Digit_Array.Is_Empty(Partial_Number.Whole))
         or else (not Digit_Array.Is_Empty(Partial_Number.Whole) and then Partial_Number.Has_Exponent and then not Partial_Number.Exponent_Is_Negative and then Digit_Array.Is_Empty(Partial_Number.Exponent_Whole))) then
         return True;
      elsif (Character = 'e' or else Character = 'E') and then not Digit_Array.Is_Empty(Partial_Number.Whole) and then Digit_Array.Is_Empty(Partial_Number.Fraction)
        and then not Partial_Number.Exponent_Is_Negative then
         return True;
      elsif Character = Decimal_Point and then not Digit_Array.Is_Empty(Partial_Number.Whole) and then
        ((not Partial_Number.Has_Exponent and then Digit_Array.Is_Empty(Partial_Number.Fraction))
         or else (not Digit_Array.Is_Empty(Partial_Number.Exponent_Whole) and then Digit_Array.Is_Empty(Partial_Number.Exponent_Fraction))) then
         return True;
      elsif Character = '+' and then Partial_Number.Has_Exponent and then Digit_Array.Is_Empty(Partial_Number.Exponent_Whole) then
         return True;
      elsif Is_Digit(Character) then
         return True;
      elsif Character = '_' and then not (Digit_Array.Is_Empty(Partial_Number.Whole) or else (Partial_Number.Has_Exponent and then Digit_Array.Is_Empty(Partial_Number.Exponent_Whole))) then
         return True;
      else
         return False;
      end if;
   end Is_Possible_Piece;

   function Is_Valid_Partial_Number(Partial_Number : Number_Pieces) return Boolean is
   begin
      if Digit_Array.Is_Empty(Partial_Number.Whole) and then
        (not Digit_Array.Is_Empty(Partial_Number.Fraction) or else not Digit_Array.Is_Empty(Partial_Number.Exponent_Whole)
         or else not Digit_Array.Is_Empty(Partial_Number.Exponent_Fraction) or else Partial_Number.Exponent_Is_Negative
         or else Partial_Number.Has_Exponent or else Partial_Number.Has_Exponent_Fraction
         or else Partial_Number.Has_Fraction) then
         return False;
      elsif not Digit_Array.Is_Empty(Partial_Number.Fraction) and then not Partial_Number.Has_Fraction then
         return False;
      elsif not Digit_Array.Is_Empty(Partial_Number.Exponent_Whole) and then not Partial_Number.Has_Exponent then
         return False;
      elsif not Digit_Array.Is_Empty(Partial_Number.Exponent_Fraction) and then not Partial_Number.Has_Exponent_Fraction then
         return False;
      elsif Partial_Number.Exponent_Is_Negative and then not Partial_Number.Has_Exponent then
         return False;
      else
         return True;
      end if;
   end Is_Valid_Partial_Number;

   function Is_Valid_Number(Partial_Number : Number_Pieces) return Boolean is
   begin
      if not Is_Valid_Partial_Number(Partial_Number => Partial_Number) then
         return False;
      elsif Digit_Array.Is_Empty(Partial_Number.Whole) then
         return False;
      elsif Partial_Number.Has_Fraction and then Digit_Array.Is_Empty(Partial_Number.Fraction) then
         return False;
      elsif Partial_Number.Has_Exponent and then Digit_Array.Is_Empty(Partial_Number.Exponent_Whole) then
         return False;
      elsif Partial_Number.Has_Exponent_Fraction and then Digit_Array.Is_Empty(Partial_Number.Exponent_Fraction) then
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
      if Digit_Array.Is_Empty(Partial_Number.Whole) then
         return Number'(Kind => NaN);
      -- mhatzl: Check for floating point first!
      elsif Standard.Float(Digit_Array.Length(Partial_Number.Whole)) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Float(Standard.Integer'Size) then
         declare
            Combined : Number(Integer);
         begin
            for Index in Digit_Array.First_Index(Partial_Number.Whole) .. Digit_Array.Last_Index(Partial_Number.Whole) - 1 loop
               Combined.Integer := Combined.Integer + Standard.Integer(Digit_Array.Element(Partial_Number.Whole, Index));
               Combined.Integer := Combined.Integer * BASE_10;
            end loop;
            Combined.Integer := Combined.Integer + Standard.Integer(Digit_Array.Element(Partial_Number.Whole, Digit_Array.Last_Index(Partial_Number.Whole)));
            return Combined;
         end;
      elsif Standard.Float(Digit_Array.Length(Partial_Number.Whole)) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Float(Standard.Long_Integer'Size) then
         declare
            Combined : Number(Long_Integer);
         begin
            for Index in Digit_Array.First_Index(Partial_Number.Whole) .. Digit_Array.Last_Index(Partial_Number.Whole) - 1 loop
               Combined.Long_Integer := Combined.Long_Integer + Standard.Long_Integer(Digit_Array.Element(Partial_Number.Whole, Index));
               Combined.Long_Integer := Combined.Long_Integer * Standard.Long_Integer(BASE_10);
            end loop;
            Combined.Long_Integer := Combined.Long_Integer + Standard.Long_Integer(Digit_Array.Element(Partial_Number.Whole, Digit_Array.Last_Index(Partial_Number.Whole)));
            return Combined;
         end;
      elsif Standard.Float(Digit_Array.Length(Partial_Number.Whole)) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Float(Standard.Long_Long_Integer'Size) then
         declare
            Combined : Number(Long_Long_Integer);
         begin
            for Index in Digit_Array.First_Index(Partial_Number.Whole) .. Digit_Array.Last_Index(Partial_Number.Whole) - 1 loop
               Combined.Long_Long_Integer := Combined.Long_Long_Integer + Standard.Long_Long_Integer(Digit_Array.Element(Partial_Number.Whole, Index));
               Combined.Long_Long_Integer := Combined.Long_Long_Integer * Standard.Long_Long_Integer(BASE_10);
            end loop;
            Combined.Long_Long_Integer := Combined.Long_Long_Integer + Standard.Long_Long_Integer(Digit_Array.Element(Partial_Number.Whole, Digit_Array.Last_Index(Partial_Number.Whole)));
            return Combined;
         end;
      else
         declare
            Combined : Number(Big_Integer);
         begin
            for Index in Digit_Array.First_Index(Partial_Number.Whole) .. Digit_Array.Last_Index(Partial_Number.Whole) - 1 loop
               Combined.Big_Integer := Ada.Numerics.Big_Numbers.Big_Integers."+"(Combined.Big_Integer, Ada.Numerics.Big_Numbers.Big_Integers.To_Big_Integer(Standard.Integer(Digit_Array.Element(Partial_Number.Whole, Index))));
               Combined.Big_Integer := Ada.Numerics.Big_Numbers.Big_Integers."*"(Combined.Big_Integer, Ada.Numerics.Big_Numbers.Big_Integers.To_Big_Integer(BASE_10));
            end loop;
            Combined.Big_Integer := Ada.Numerics.Big_Numbers.Big_Integers."+"(Combined.Big_Integer, Ada.Numerics.Big_Numbers.Big_Integers.To_Big_Integer(Standard.Integer(Digit_Array.Element(Partial_Number.Whole, Digit_Array.Last_Index(Partial_Number.Whole)))));
            return Combined;
         end;
      end if;
   end To_Number;


   procedure Append (Partial_Number : in out Number_Pieces; Character : Wide_Character; Success : out Boolean; Decimal_Point : Wide_Character := '.') is
   begin
      if Character = '_' then
        Partial_Number.Next_Must_Be_Digit := True;
      elsif Character = '-' then
         Partial_Number.Next_Must_Be_Digit := True;
         if Digit_Array.Is_Empty(Partial_Number.Whole) then
            Partial_Number.Whole_Is_Negative := True;
         elsif Digit_Array.Is_Empty(Partial_Number.Exponent_Whole) then
            Partial_Number.Exponent_Is_Negative := True;
         end if;
      elsif Character = '+' then
         Partial_Number.Next_Must_Be_Digit := True;
      elsif Character = 'e' or else Character = 'E' then
         Partial_Number.Has_Exponent := True;
      elsif Character = Decimal_Point then
         Partial_Number.Next_Must_Be_Digit := True;
         if Partial_Number.Has_Exponent then
            Partial_Number.Has_Exponent_Fraction := True;
         else
            Partial_Number.Has_Fraction := True;
         end if;
      else
         Partial_Number.Next_Must_Be_Digit := False;
         declare
            Number : constant Digit := Character_To_Digit(Character);
         begin
            if Partial_Number.Has_Exponent_Fraction then
               Digit_Array.Append(Partial_Number.Exponent_Fraction, Number, Success);
            elsif Partial_Number.Has_Exponent then
               Digit_Array.Append(Partial_Number.Exponent_Whole, Number, Success);
            elsif Partial_Number.Has_Fraction then
               Digit_Array.Append(Partial_Number.Fraction, Number, Success);
            else
               Digit_Array.Append(Partial_Number.Whole, Number, Success);
            end if;
         end;
      end if;
   end Append;



   function Is_Digit (Character : Wide_Character) return Boolean is
   begin
      case Character is
         when '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' => return True;
         when others => return False;
      end case;
   end Is_Digit;

   function Character_To_Digit (Character : Wide_Character) return Digit is
   begin
      case Character is
         when '0' => return 0;
         when '1' => return 1;
         when '2' => return 2;
         when '3' => return 3;
         when '4' => return 4;
         when '5' => return 5;
         when '6' => return 6;
         when '7' => return 7;
         when '8' => return 8;
         when '9' => return 9;
         when others => raise Program_Error;
      end case;
   end Character_To_Digit;


end Vaton;
