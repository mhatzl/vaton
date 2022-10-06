with AUnit;
with AUnit.Test_Fixtures;

package Invalid_Appends is

   type Test_Fixture is new AUnit.Test_Fixtures.Test_Fixture with record
      null;
   end record;
   
   procedure More_Than_One_Leading_Zero(T : in out Test_Fixture);

   procedure Underscore_After_Non_Digit(T : in out Test_Fixture);
   
end Invalid_Appends;
