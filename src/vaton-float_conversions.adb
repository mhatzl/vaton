with Ada.Numerics.Big_Numbers.Big_Reals;

package body Vaton.Float_Conversions with SPARK_Mode is


   function Combine(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Float_Base is
      Combined : Float_Base := To_Float_Base(0);
      Fraction : Float_Base := To_Float_Base(0);
      Based_Exponent : Float_Base := To_Float_Base(BASE_10);
      Old_Index : Natural := 0;
      
      --package To_Big is new Ada.Numerics.Big_Numbers.Big_Reals.Float_Conversions(Num => Float_Base);
   begin
      for Index in
        Digit_Array.First_Index (Partial_Number.Whole) ..
        Digit_Array.Last_Index (Partial_Number.Whole) - 1
      loop
         Combined := Combined + To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Whole, Index)));
         Combined := Combined * To_Float_Base(BASE_10);
         
         pragma Loop_Invariant (Old_Index < Index);
         Old_Index := Index;
      end loop;
      Combined := Combined + To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Whole, Digit_Array.Last_Index (Partial_Number.Whole))));
      
      if Partial_Number.Has_Fraction then
         Old_Index := Natural'Last;
         for Index in reverse
           Digit_Array.First_Index (Partial_Number.Fraction) ..
           Digit_Array.Last_Index (Partial_Number.Fraction)
         loop
            Fraction := Fraction + To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Fraction, Index)));
            Fraction := Fraction / To_Float_Base(BASE_10);
            
            pragma Loop_Invariant (Old_Index > Index);
            Old_Index := Index;
         end loop;

         Combined := Combined + Fraction;
      end if;
      
      if Partial_Number.Has_Exponent then
         if Exponent = 0 then
            return To_Float_Base(1);
         end if;
         Based_Exponent := Based_Exponent ** (abs(Exponent));
         if Exponent < 0 then
            Combined := Combined / Based_Exponent;
         else
            Combined := Combined * Based_Exponent;
         end if;
      end if;

      if Partial_Number.Whole_Is_Negative then
         Combined := Combined * To_Float_Base(-1);
      end if;
      
      return Combined;
   end Combine;
   
   function Convert_Big_Real(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Number is
      package Big_Num renames Ada.Numerics.Big_Numbers;
      
      Result : Number(Big_Real);
      Combined : Big_Num.Big_Reals.Valid_Big_Real := Number_To_Big_Real(To_Integer(Partial_Number.Whole, False));
      Fraction : Big_Num.Big_Reals.Valid_Big_Real;
      Divisor : Big_Num.Big_Integers.Valid_Big_Integer;
      Based_Exponent : Big_Num.Big_Reals.Valid_Big_Real := Ada.Numerics.Big_Numbers.Big_Reals.To_Real(BASE_10);
      
      use type Big_Num.Big_Reals.Valid_Big_Real;
      use type Big_Num.Big_Integers.Valid_Big_Integer;
   begin
      if Partial_Number.Has_Fraction then
         Fraction := Number_To_Big_Real(To_Integer(Partial_Number.Fraction, False));
         Divisor := Big_Num.Big_Integers.To_Big_Integer(BASE_10) ** Digit_Array.Length(Partial_Number.Fraction);
         Fraction := Fraction / Big_Num.Big_Reals.To_Big_Real(Divisor);
         Combined := Combined + Fraction;
      end if;
      
      if Partial_Number.Has_Exponent then
         if Exponent = 0 then
            return Number'(Kind => Big_Real, Big_Real => Big_Num.Big_Reals.To_Real(1));
         end if;
         Based_Exponent := Based_Exponent ** (abs(Exponent));
         if Exponent < 0 then
            Combined := Combined / Based_Exponent;
         else
            Combined := Combined * Based_Exponent;
         end if;
      end if;

      if Partial_Number.Whole_Is_Negative then
         Combined := Combined * Big_Num.Big_Reals.To_Real(-1);
      end if;
      
      Result.Big_Real := Combined;
      return Result;
   end Convert_Big_Real;
   
   function Number_To_Float(Number : Standard.Integer) return Standard.Float is
   begin
      return Standard.Float(Number);
   end Number_To_Float;

   function Number_To_Long_Float(Number : Standard.Integer) return Standard.Long_Float is
   begin
      return Standard.Long_Float(Number);
   end Number_To_Long_Float;
   
   function Number_To_Long_Long_Float(Number : Standard.Integer) return Standard.Long_Long_Float is
   begin
      return Standard.Long_Long_Float(Number);
   end Number_To_Long_Long_Float;
   
   function Number_To_Big_Real(Integer_Part : Number) return Ada.Numerics.Big_Numbers.Big_Reals.Valid_Big_Real is
      package Long_To_Big is new Ada.Numerics.Big_Numbers.Big_Integers.Signed_Conversions(Int => Standard.Long_Integer);
      package Long_Long_To_Big is new Ada.Numerics.Big_Numbers.Big_Integers.Signed_Conversions(Int => Standard.Long_Long_Integer);
   begin
      case Integer_Part.Kind is
         when Integer => return Ada.Numerics.Big_Numbers.Big_Reals.To_Real(Integer_Part.Integer);
         when Long_Integer => return Ada.Numerics.Big_Numbers.Big_Reals.To_Big_Real(Long_To_Big.To_Big_Integer(Integer_Part.Long_Integer));
         when Long_Long_Integer => return Ada.Numerics.Big_Numbers.Big_Reals.To_Big_Real(Long_Long_To_Big.To_Big_Integer(Integer_Part.Long_Long_Integer));
         when Big_Integer => return Ada.Numerics.Big_Numbers.Big_Reals.To_Big_Real(Integer_Part.Big_Integer);
         when others => raise Program_Error;
      end case;
   end Number_To_Big_Real;

end Vaton.Float_Conversions;
