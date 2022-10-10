with Ada.Numerics.Big_Numbers.Big_Reals;

package body Vaton.Float_Conversions with SPARK_Mode is


   function Combine(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Float_Base is
      BASED_10 : constant Float_Base := To_Float_Base(BASE_10);
      
      subtype Pos_Float_Base is Float_Base range 0.0 .. Float_Base'Last / 2.0;      
      Whole : Pos_Float_Base := To_Float_Base(0);
      Combined : Pos_Float_Base;
      
      subtype Fraction_Float_Base is Float_Base range 0.0 .. BASED_10;
      Fraction : Fraction_Float_Base := To_Float_Base(0);
      
      -- Lemma taken from the SPARK Lemma Library (credit to the SPARK Team)
      procedure Lemma_Add_Is_Monotonic
        (Val1 : Float_Base;
         Val2 : Float_Base;
         Val3 : Float_Base)
        with
          Ghost,
          Global => null,
          Pre => (Val1 in Float_Base'First / 2.0 .. Float_Base'Last / 2.0) and then
          (Val2 in Float_Base'First / 2.0 .. Float_Base'Last / 2.0) and then
          (Val3 in Float_Base'First / 2.0 .. Float_Base'Last / 2.0) and then
          Val1 <= Val2,
          Post => Val1 + Val3 <= Val2 + Val3
      is begin
         pragma Assume(Val1 + Val3 <= Val2 + Val3);
      end Lemma_Add_Is_Monotonic;
              
   begin
      for Index in
        Digit_Array.First_Index (Partial_Number.Whole) ..
        Digit_Array.Last_Index (Partial_Number.Whole) - 1
      loop
         Lemma_Add_Is_Monotonic(To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Whole, Index))), To_Float_Base(Standard.Integer(Digit'Last)), Whole);
         
         Whole := Whole + To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Whole, Index)));
         Whole := Whole * BASED_10;
         
         pragma Loop_Variant(Increases => Index);
      end loop;
      Lemma_Add_Is_Monotonic(To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Whole, Digit_Array.Last_Index (Partial_Number.Whole)))), To_Float_Base(Standard.Integer(Digit'Last)), Whole);
      Combined := Whole + To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Whole, Digit_Array.Last_Index (Partial_Number.Whole))));
      
      if Partial_Number.Has_Fraction and then Digit_Array.Last_Index (Partial_Number.Fraction) < Natural'Last then
         for Index in reverse
           Digit_Array.First_Index (Partial_Number.Fraction) ..
           Digit_Array.Last_Index (Partial_Number.Fraction)
         loop
            Lemma_Add_Is_Monotonic(To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Fraction, Index))), BASED_10, Fraction);
            Fraction := Fraction + To_Float_Base (Standard.Integer(Digit_Array.Element (Partial_Number.Fraction, Index)));
            pragma Assert(Fraction < BASED_10);            
            Fraction := Fraction / BASED_10;
            
            pragma Loop_Invariant(Fraction < To_Float_Base(1));
            pragma Loop_Variant(Decreases => Index);
         end loop;

         Lemma_Add_Is_Monotonic(Fraction, To_Float_Base(1), Combined);
         Combined := Combined + Fraction;
      end if;
      
      if Partial_Number.Has_Exponent then
         if Exponent = 0 then
            return To_Float_Base(1);
         end if;
         
         if Exponent < 0 then
            Combined := Combined / (BASED_10 ** (-Exponent));
         else
            Combined := Combined * (BASED_10 ** Exponent);
         end if;
      end if;

      if Partial_Number.Whole_Is_Negative then
         return Combined * To_Float_Base(-1);
      end if;
      
      return Combined;
   end Combine;
   
   function Convert_Big_Real(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Number is
      package Big_Num renames Ada.Numerics.Big_Numbers;
      
      Result : Number(Big_Real);
      Combined : Big_Num.Big_Reals.Valid_Big_Real := Number_To_Big_Real(To_Integer(Partial_Number.Whole, False));
      Fraction : Big_Num.Big_Reals.Valid_Big_Real;
      Divisor : Big_Num.Big_Integers.Valid_Big_Integer;
      Based_Exponent : constant Big_Num.Big_Reals.Valid_Big_Real := Ada.Numerics.Big_Numbers.Big_Reals.To_Real(BASE_10);
      
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
         
         if Exponent < 0 then
            Combined := Combined / (Based_Exponent ** (-Exponent));
         else
            Combined := Combined * (Based_Exponent ** Exponent);
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
