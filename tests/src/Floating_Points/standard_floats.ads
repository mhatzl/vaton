with AUnit;
with AUnit.Test_Fixtures;

package Standard_Floats is

   type Test_Fixture is new AUnit.Test_Fixtures.Test_Fixture with record
      null;
   end record;
   
   procedure Create_Positive_Float(T : in out Test_Fixture);
   
   procedure Create_Negative_Float(T : in out Test_Fixture);
   
   procedure Create_Zero(T : in out Test_Fixture);
   
   procedure Use_Underline_Randomly(T : in out Test_Fixture);
   
   procedure With_Positive_Exponent(T : in out Test_Fixture);
   
   procedure With_Implicit_Positive_Exponent(T : in out Test_Fixture);
   
   procedure With_Negative_Exponent(T : in out Test_Fixture);

end Standard_Floats;
