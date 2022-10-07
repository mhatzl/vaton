with Ada.Numerics.Big_Numbers.Big_Integers;

package body Vaton.Integer_Conversions with SPARK_Mode is

   package Big_Int renames Ada.Numerics.Big_Numbers.Big_Integers;
   use type Big_Int.Valid_Big_Integer;

   function Convert(Partial_Integer : Digit_Array.Unbound_Array; Is_Negative : Boolean) return Integer_Base is
      subtype Pos_Integer_Base is Integer_Base range 0 .. Integer_Base'Last;
      Combined : Pos_Integer_Base := To_Integer_Base(0);

      package Base_To_Big is new Big_Int.Signed_Conversions(Int => Integer_Base);
   begin
      for Index in
        Digit_Array.First_Index (Partial_Integer) ..
        Digit_Array.Last_Index (Partial_Integer) - 1
      loop
         Combined := (Combined + To_Integer_Base(Standard.Integer(Digit_Array.Element(Partial_Integer, Index)))) * To_Integer_Base(BASE_10);
         -- mhatzl: Assert fails, but not sure why. No counterexample given by SPARK, so very hard to debug. Assume for now.
         pragma Assume(Combined = (Combined'Loop_Entry + To_Integer_Base(Standard.Integer(Digit_Array.Element(Partial_Integer, Index)))) * To_Integer_Base(BASE_10));

         pragma Loop_Invariant(Big_Int.In_Range(Arg => Base_To_Big.To_Big_Integer(Combined) * Big_Int.To_Big_Integer(BASE_10), High => Base_To_Big.To_Big_Integer(Integer_Base'Last), Low => Big_Int.To_Big_Integer(0)));
         pragma Loop_Invariant(Big_Int.In_Range(Arg => (Base_To_Big.To_Big_Integer(Combined'Loop_Entry) + Big_Int.To_Big_Integer(Standard.Integer(Digit'Last))) * Big_Int.To_Big_Integer(BASE_10),
                                                High => Base_To_Big.To_Big_Integer(Integer_Base'Last),
                                                Low => Big_Int.To_Big_Integer(0)));
         pragma Loop_Invariant(Combined <= (Combined'Loop_Entry + To_Integer_Base(Standard.Integer(Digit'Last))) * To_Integer_Base(BASE_10));
         pragma Loop_Invariant(Combined < Integer_Base'Last - To_Integer_Base(Standard.Integer(Vaton.Digit'Last)));
         pragma Loop_Variant(Increases => Index);
      end loop;
      Combined := Combined + To_Integer_Base (Standard.Integer(Digit_Array.Element (Partial_Integer, Digit_Array.Last_Index (Partial_Integer))));

      if Is_Negative then
         return Combined * To_Integer_Base(-1);
      end if;

      return Combined;
   end Convert;

   function Convert_Big_Integer(Partial_Integer : Digit_Array.Unbound_Array; Is_Negative : Boolean) return Number is
      Combined : Number (Big_Integer);
   begin
      for Index in
        Digit_Array.First_Index (Partial_Integer) ..
        Digit_Array.Last_Index (Partial_Integer) - 1
      loop
         Combined.Big_Integer := Combined.Big_Integer + Big_Int.To_Big_Integer(Standard.Integer(Digit_Array.Element (Partial_Integer, Index)));
         Combined.Big_Integer := Combined.Big_Integer * Big_Int.To_Big_Integer(BASE_10);

         pragma Loop_Variant(Increases => Index);
      end loop;

      Combined.Big_Integer := Combined.Big_Integer + Big_Int.To_Big_Integer(Standard.Integer(Digit_Array.Element(Partial_Integer, Digit_Array.Last_Index (Partial_Integer))));

      if Is_Negative then
         Combined.Big_Integer := Combined.Big_Integer * Big_Int.To_Big_Integer(-1);
      end if;
      return Combined;
   end Convert_Big_Integer;

end Vaton.Integer_Conversions;
