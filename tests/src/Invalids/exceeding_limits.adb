with AUnit.Assertions; use AUnit.Assertions;
with Vaton; use Vaton;

package body Exceeding_Limits is

   procedure Exceed_Supported_Integer_Length(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : constant Vaton.Number_Kind := Vaton.NaN;
   begin
      while Digit_Array.Length (Partial_Number.Whole) <= Vaton.BIG_NUMBER_DIGIT_LIMIT loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
      end loop;
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Expected, "Supported length exceeded, but returned valid number");
   end Exceed_Supported_Integer_Length;
   
   procedure Exceed_Supported_Float_Length(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : constant Vaton.Number_Kind := Vaton.NaN;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      while (Digit_Array.Length (Partial_Number.Whole) + Digit_Array.Length (Partial_Number.Fraction)) <= Vaton.BIG_NUMBER_DIGIT_LIMIT loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
      end loop;
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Expected, "Supported length exceeded, but returned valid number");
   end Exceed_Supported_Float_Length;

end Exceeding_Limits;
