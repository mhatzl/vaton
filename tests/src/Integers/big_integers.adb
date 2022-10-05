with AUnit.Assertions; use AUnit.Assertions;
with Vaton; use Vaton;
with Ada.Numerics.Big_Numbers.Big_Integers;

package body Big_Integers is
   package Big_Int renames Ada.Numerics.Big_Numbers.Big_Integers;
   use type Big_Int.Valid_Big_Integer;

   procedure Create_Positive_Integer(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Big_Int.Valid_Big_Integer := Big_Int.To_Big_Integer(0);
   begin
      while Digit_Array.Length (Partial_Number.Whole) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Long_Long_Integer'Size loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected := (Expected + Big_Int.To_Big_Integer(1)) * Big_Int.To_Big_Integer(BASE_10);
      end loop;
      Expected := Expected / Big_Int.To_Big_Integer(BASE_10);
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Big_Integer, "Result not of type Standard.Long_Long_Integer");
      Assert(Result.Big_Integer = Expected, "Conversion resulted in wrong integer number");
   end Create_Positive_Integer;
   
   procedure Create_Negative_Integer(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Big_Int.Valid_Big_Integer := Big_Int.To_Big_Integer(0);
   begin
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Setting negative integer failed");
      
      while Digit_Array.Length (Partial_Number.Whole) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Long_Long_Integer'Size loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected := (Expected + Big_Int.To_Big_Integer(1)) * Big_Int.To_Big_Integer(BASE_10);
      end loop;
      Expected := Expected / Big_Int.To_Big_Integer(BASE_10);
      Expected := Expected * Big_Int.To_Big_Integer(-1);
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Big_Integer, "Result not of type Standard.Long_Long_Integer");
      Assert(Result.Big_Integer = Expected, "Conversion resulted in wrong integer number");
   end Create_Negative_Integer;

end Big_Integers;
