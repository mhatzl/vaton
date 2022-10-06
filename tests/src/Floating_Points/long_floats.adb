with AUnit.Assertions; use AUnit.Assertions;
with Vaton; use Vaton;

package body Long_Floats is

   procedure Create_Positive_Float(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Standard.Long_Float := 1.0;
      Expected_Fraction : Standard.Long_Float := 0.0;
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      while Digit_Array.Length (Partial_Number.Fraction) < Standard.Float'Digits loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected_Fraction := (Expected_Fraction + 1.0) / Standard.Long_Float(BASE_10);
      end loop;
      Expected := Expected + Expected_Fraction;
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Long_Float, "Result not of type Standard.Long_Float");
      Assert(Result.Long_Float = Expected, "Conversion resulted in wrong floating number");
   end Create_Positive_Float;
   
   procedure Create_Negative_Float(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Standard.Long_Float := 1.0;
      Expected_Fraction : Standard.Long_Float := 0.0;
   begin
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Setting negative integer failed");
      
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      while Digit_Array.Length (Partial_Number.Fraction) < Standard.Float'Digits loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected_Fraction := (Expected_Fraction + 1.0) / Standard.Long_Float(BASE_10);
      end loop;
      Expected := Expected + Expected_Fraction;
      Expected := Expected * (-1.0);
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Long_Float, "Result not of type Standard.Long_Float");
      Assert(Result.Long_Float = Expected, "Conversion resulted in wrong floating number");
   end Create_Negative_Float;
   
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
      
      Vaton.Append(Partial_Number, '7', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '3', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Long_Float, "Result not of type Standard.Long_Float");
      Assert(Result.Long_Float = 1.2e+73, "Conversion resulted in wrong float number");
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
      
      Vaton.Append(Partial_Number, '5', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '4', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Long_Float, "Result not of type Standard.Long_Float");
      Assert(Result.Long_Float = 1.2e54, "Conversion resulted in wrong float number");
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
      
      Vaton.Append(Partial_Number, '6', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '7', Success);
      Assert(Success, "Appending number failed");
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Long_Float, "Result not of type Standard.Long_Float");
      Assert(Result.Long_Float = 6.5e-67, "Conversion resulted in wrong float number");
   end With_Negative_Exponent;

end Long_Floats;
