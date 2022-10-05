with AUnit.Assertions; use AUnit.Assertions;
with Vaton; use Vaton;

package body Standard_Integer is

   procedure Create_Positive_Integer(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '2', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '3', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Integer, "Result not of type Standard.Integer");
      Assert(Result.Integer = 123, "Conversion resulted in wrong integer number");
   end Create_Positive_Integer;
   
   procedure Create_Negative_Integer(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Setting negative integer failed");
      
      Vaton.Append(Partial_Number, '6', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '5', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '4', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Integer, "Result not of type Standard.Integer");
      Assert(Result.Integer = -654, "Conversion resulted in wrong integer number");
   end Create_Negative_Integer;
   
   procedure Create_Zero(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Integer, "Result not of type Standard.Integer");
      Assert(Result.Integer = 0, "Conversion resulted in wrong integer number");
   end Create_Zero;
   
   procedure Use_Underline_As_Thousand_Separator(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '_', Success);
      Assert(Success, "Underscore thousand mark failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Integer, "Result not of type Standard.Integer");
      Assert(Result.Integer = 1_000, "Conversion resulted in wrong integer number");
   end Use_Underline_As_Thousand_Separator;
   
   procedure Use_Underline_Randomly(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '_', Success);
      Assert(Success, "Underscore mark failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '_', Success);
      Assert(Success, "Underscore mark failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '_', Success);
      Assert(Success, "Underscore mark failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Integer, "Result not of type Standard.Integer");
      Assert(Result.Integer = 100_000, "Conversion resulted in wrong integer number");
   end Use_Underline_Randomly;

end Standard_Integer;
