with AUnit.Assertions; use AUnit.Assertions;
with Vaton; use Vaton;
with Ada.Numerics.Big_Numbers.Big_Reals;

package body Big_Floats is
   package Big_Reals renames Ada.Numerics.Big_Numbers.Big_Reals;
   
   use type Big_Reals.Valid_Big_Real;

   procedure Create_Positive_Float(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(1);
      Expected_Fraction : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(0);
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      while Digit_Array.Length (Partial_Number.Fraction) < Standard.Long_Long_Float'Digits loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected_Fraction := (Expected_Fraction + Big_Reals.To_Real(1)) / Big_Reals.To_Real(BASE_10);
      end loop;
      Expected := Expected + Expected_Fraction;
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Big_Real, "Result not of type Big_Real");
      Assert(Result.Big_Real = Expected, "Conversion resulted in wrong floating number");
   end Create_Positive_Float;
   
   procedure Create_Negative_Float(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(4);
      Expected_Fraction : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(0);
   begin
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Setting negative integer failed");
      
      Vaton.Append(Partial_Number, '4', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      while Digit_Array.Length (Partial_Number.Fraction) < Standard.Long_Long_Float'Digits loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected_Fraction := (Expected_Fraction + Big_Reals.To_Real(1)) / Big_Reals.To_Real(BASE_10);
      end loop;
      Expected := Expected + Expected_Fraction;
      Expected := Expected * Big_Reals.To_Real(-1);
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Big_Real, "Result not of type Big_Real");
      Assert(Result.Big_Real = Expected, "Conversion resulted in wrong floating number");
   end Create_Negative_Float;
   
   procedure With_Positive_Exponent(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(3);
      Expected_Fraction : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(0);
   begin
      Vaton.Append(Partial_Number, '3', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      while Digit_Array.Length (Partial_Number.Fraction) < Standard.Long_Long_Float'Digits loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected_Fraction := (Expected_Fraction + Big_Reals.To_Real(1)) / Big_Reals.To_Real(BASE_10);
      end loop;
      Expected := Expected + Expected_Fraction;
      
      Vaton.Append(Partial_Number, 'e', Success);
      Assert(Success, "Appending exponent mark failed");
      
      Vaton.Append(Partial_Number, '+', Success);
      Assert(Success, "Setting positive exponent failed");
      
      Vaton.Append(Partial_Number, '4', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '5', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '6', Success);
      Assert(Success, "Appending number failed");
      
      Expected := Expected * (Big_Reals.To_Real(Base_10) ** 456);
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Big_Real, "Result not of type Big_Real");
      Assert(Result.Big_Real = Expected, "Conversion resulted in wrong float number");
   end With_Positive_Exponent;
   
   procedure With_Implicit_Positive_Exponent(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(1);
      Expected_Fraction : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(0);
   begin
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      while Digit_Array.Length (Partial_Number.Fraction) < Standard.Long_Long_Float'Digits loop
         Vaton.Append(Partial_Number, '1', Success);
         Assert(Success, "Appending number failed");
         
         Expected_Fraction := (Expected_Fraction + Big_Reals.To_Real(1)) / Big_Reals.To_Real(BASE_10);
      end loop;
      Expected := Expected + Expected_Fraction;
      
      Vaton.Append(Partial_Number, 'e', Success);
      Assert(Success, "Appending exponent mark failed");
      
      Vaton.Append(Partial_Number, '2', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '5', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '4', Success);
      Assert(Success, "Appending number failed");
      
      Expected := Expected * (Big_Reals.To_Real(Base_10) ** 254);
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Big_Real, "Result not of type Big_Real");
      Assert(Result.Big_Real = Expected, "Conversion resulted in wrong float number");
   end With_Implicit_Positive_Exponent;
   
   procedure With_Negative_Exponent(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
      Result : Vaton.Number;
      Expected : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(6);
      Expected_Fraction : Big_Reals.Valid_Big_Real := Big_Reals.To_Real(0);
   begin      
      Vaton.Append(Partial_Number, '6', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending decimal point failed");
      
      while Digit_Array.Length (Partial_Number.Fraction) < Standard.Long_Long_Float'Digits loop
         Vaton.Append(Partial_Number, '4', Success);
         Assert(Success, "Appending number failed");
         
         Expected_Fraction := (Expected_Fraction + Big_Reals.To_Real(4)) / Big_Reals.To_Real(BASE_10);
      end loop;
      Expected := Expected + Expected_Fraction;
      
      Vaton.Append(Partial_Number, 'e', Success);
      Assert(Success, "Appending exponent mark failed");
      
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Setting negative exponent failed");
      
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '6', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '8', Success);
      Assert(Success, "Appending number failed");
      
      Expected := Expected / (Big_Reals.To_Real(Base_10) ** (1_068));
      
      Result := Vaton.To_Number(Partial_Number);
      Assert(Result.Kind = Vaton.Big_Real, "Result not of type Big_Real");
      Assert(Result.Big_Real = Expected, "Conversion resulted in wrong float number");
   end With_Negative_Exponent;

end Big_Floats;
