with AUnit;
with AUnit.Test_Fixtures;

package Exceeding_Limits is

   type Test_Fixture is new AUnit.Test_Fixtures.Test_Fixture with record
      null;
   end record;
   
   procedure Exceed_Supported_Integer_Length(T : in out Test_Fixture);
   
   procedure Exceed_Supported_Float_Length(T : in out Test_Fixture);
   
end Exceeding_Limits;
