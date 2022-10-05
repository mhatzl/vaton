with AUnit;
with AUnit.Test_Fixtures;

package Standard_Integer is

   type Test_Fixture is new AUnit.Test_Fixtures.Test_Fixture with record
      null;
   end record;
   
   procedure Create_Positive_Integer(T : in out Test_Fixture);
   
   procedure Create_Negative_Integer(T : in out Test_Fixture);
   
   procedure Create_Zero(T : in out Test_Fixture);
   
   procedure Use_Underline_As_Thousand_Separator(T : in out Test_Fixture);
   
   procedure Use_Underline_Randomly(T : in out Test_Fixture);

end Standard_Integer;
