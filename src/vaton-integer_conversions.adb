with Ada.Numerics.Big_Numbers.Big_Integers;

package body Vaton.Integer_Conversions with SPARK_Mode is

   function Convert(Partial_Integer : Digit_Array.Unbound_Array; Is_Negative : Boolean) return Integer_Base is
      Combined : Integer_Base := To_Integer_Base(0);
      Old_Index : Natural := 0;
   begin
      for Index in
        Digit_Array.First_Index (Partial_Integer) ..
        Digit_Array.Last_Index (Partial_Integer) - 1
      loop
         if Combined < To_Integer_Base(0) or else Integer_Base'Last - Combined > To_Integer_Base (Standard.Integer(Digit_Array.Element (Partial_Integer, Index))) then
            Combined :=
              Combined + To_Integer_Base (Standard.Integer(Digit_Array.Element (Partial_Integer, Index)));
         end if;
         if (Combined >= To_Integer_Base(0) and then Integer_Base'Last / To_Integer_Base(BASE_10) > Combined)
           or else (Combined < To_Integer_Base(0) and then Integer_Base'First / To_Integer_Base(BASE_10) < Combined) then
            Combined := Combined * To_Integer_Base(BASE_10);
         end if;
         pragma Loop_Invariant (Old_Index < Index);
         Old_Index := Index;
      end loop;

      if Combined < To_Integer_Base(0) or else Integer_Base'Last - Combined > To_Integer_Base (Standard.Integer(Digit_Array.Element (Partial_Integer, Digit_Array.Last_Index (Partial_Integer)))) then
         Combined := Combined + To_Integer_Base (Standard.Integer(Digit_Array.Element (Partial_Integer, Digit_Array.Last_Index (Partial_Integer))));
      end if;

      if Is_Negative and then Combined > To_Integer_Base(0) then
         Combined := Combined * To_Integer_Base(-1);
      end if;

      return Combined;
   end Convert;

   function Convert_Big_Integer(Partial_Integer : Digit_Array.Unbound_Array; Is_Negative : Boolean) return Number is
      Combined : Number (Big_Integer);
      Old_Index : Natural := 0;
   begin
      for Index in
        Digit_Array.First_Index (Partial_Integer) ..
        Digit_Array.Last_Index (Partial_Integer) - 1
      loop
         Combined.Big_Integer :=
           Ada.Numerics.Big_Numbers.Big_Integers."+"
             (Combined.Big_Integer,
              Ada.Numerics.Big_Numbers.Big_Integers.To_Big_Integer
                (Standard.Integer (Digit_Array.Element (Partial_Integer, Index))));
         Combined.Big_Integer :=
           Ada.Numerics.Big_Numbers.Big_Integers."*"
             (Combined.Big_Integer,
              Ada.Numerics.Big_Numbers.Big_Integers.To_Big_Integer (BASE_10));

         pragma Loop_Invariant (Old_Index < Index);
         Old_Index := Index;
      end loop;

      Combined.Big_Integer :=
        Ada.Numerics.Big_Numbers.Big_Integers."+"
          (Combined.Big_Integer,
           Ada.Numerics.Big_Numbers.Big_Integers.To_Big_Integer
             (Standard.Integer
                (Digit_Array.Element
                     (Partial_Integer, Digit_Array.Last_Index (Partial_Integer)))));

      if Is_Negative then
         Combined.Big_Integer :=
           Ada.Numerics.Big_Numbers.Big_Integers."*"
             (Combined.Big_Integer,
              Ada.Numerics.Big_Numbers.Big_Integers.To_Big_Integer (-1));
      end if;
      return Combined;
   end Convert_Big_Integer;

end Vaton.Integer_Conversions;
