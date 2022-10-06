with AUnit.Assertions; use AUnit.Assertions;
with Vaton; use Vaton;

package body Standard_Floats is

   procedure Create_Positive_Float(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      Vaton.Append(Partial_Number, '2', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '3', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Float, "Result not of type Standard.Float");
      Assert(Result.Float = 1.23, "Conversion resulted in wrong float number");
   end Create_Positive_Float;
   
   procedure Create_Negative_Float(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Setting negative integer failed");
      
      Vaton.Append(Partial_Number, '6', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      Vaton.Append(Partial_Number, '5', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '4', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Float, "Result not of type Standard.Float");
      Assert(Result.Float = -6.54, "Conversion resulted in wrong float number");
   end Create_Negative_Float;
   
   procedure Create_Zero(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Float, "Result not of type Standard.Float");
      Assert(Result.Float = 0.0, "Conversion resulted in wrong float number");
   end Create_Zero;
   
   procedure Use_Underline_Randomly(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
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
      
      Vaton.Append(Partial_Number, '_', Success);
      Assert(Success, "Underscore mark failed");
      
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Float, "Result not of type Standard.Float");
      Assert(Result.Float = 1.0001, "Conversion resulted in wrong float number");
   end Use_Underline_Randomly;
   
   procedure With_Positive_Exponent(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      Vaton.Append(Partial_Number, '2', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, 'e', Success);
      Assert(Success, "Appending exponent mark failed");
      
      Vaton.Append(Partial_Number, '+', Success);
      Assert(Success, "Setting positive exponent failed");
      
      Vaton.Append(Partial_Number, '3', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Float, "Result not of type Standard.Float");
      Assert(Result.Float = 1.2e3, "Conversion resulted in wrong float number");
   end With_Positive_Exponent;
   
   procedure With_Implicit_Positive_Exponent(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      Vaton.Append(Partial_Number, '2', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, 'e', Success);
      Assert(Success, "Appending exponent mark failed");
      
      Vaton.Append(Partial_Number, '3', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Float, "Result not of type Standard.Float");
      Assert(Result.Float = 1.2e3, "Conversion resulted in wrong float number");
   end With_Implicit_Positive_Exponent;
   
   procedure With_Negative_Exponent(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
   begin      
      Vaton.Append(Partial_Number, '6', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      Vaton.Append(Partial_Number, '5', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, 'e', Success);
      Assert(Success, "Appending exponent mark failed");
      
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Setting negative exponent failed");
      
      Vaton.Append(Partial_Number, '4', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Float, "Result not of type Standard.Float");
      Assert(Result.Float = 6.5e-4, "Conversion resulted in wrong float number");
   end With_Negative_Exponent;

end Standard_Floats;
