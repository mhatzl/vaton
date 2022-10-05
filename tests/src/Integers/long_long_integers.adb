with AUnit.Assertions; use AUnit.Assertions;
with Vaton; use Vaton;

package body Long_Long_Integers is

   procedure Create_Positive_Integer(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Standard.Long_Long_Integer := 0;
   begin
      while Digit_Array.Length (Partial_Number.Whole) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Long_Integer'Size loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected := (Expected + 1) * Standard.Long_Long_Integer(BASE_10);
      end loop;
      Expected := Expected / Standard.Long_Long_Integer(BASE_10);
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Long_Long_Integer, "Result not of type Standard.Long_Long_Integer");
      Assert(Result.Long_Long_Integer = Expected, "Conversion resulted in wrong integer number");
   end Create_Positive_Integer;
   
   procedure Create_Negative_Integer(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Standard.Long_Long_Integer := 0;
   begin
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Setting negative integer failed");
      
      while Digit_Array.Length (Partial_Number.Whole) * BASE_10_LENGTH_TO_BIT_SIZE < Standard.Long_Integer'Size loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected := (Expected + 1) * Standard.Long_Long_Integer(BASE_10);
      end loop;
      Expected := Expected / Standard.Long_Long_Integer(BASE_10);
      Expected := Expected * (-1);
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Long_Long_Integer, "Result not of type Standard.Long_Long_Integer");
      Assert(Result.Long_Long_Integer = Expected, "Conversion resulted in wrong integer number");
   end Create_Negative_Integer;

end Long_Long_Integers;
