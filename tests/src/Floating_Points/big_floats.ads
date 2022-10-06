with AUnit;
with AUnit.Test_Fixtures;

package Big_Floats is

   type Test_Fixture is new AUnit.Test_Fixtures.Test_Fixture with record
      null;
   end record;
   
   procedure Create_Positive_Float(T : in out Test_Fixture);
   
   procedure Create_Negative_Float(T : in out Test_Fixture);
   
   procedure With_Positive_Exponent(T : in out Test_Fixture);
   
   procedure With_Implicit_Positive_Exponent(T : in out Test_Fixture);
   
   procedure With_Negative_Exponent(T : in out Test_Fixture);

end Big_Floats;
