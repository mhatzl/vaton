with AUnit;
with AUnit.Test_Fixtures;

package Long_Integers is

   type Test_Fixture is new AUnit.Test_Fixtures.Test_Fixture with record
      null;
   end record;
   
   procedure Create_Positive_Integer(T : in out Test_Fixture);
   
   procedure Create_Negative_Integer(T : in out Test_Fixture);

end Long_Integers;
