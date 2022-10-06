with AUnit.Test_Caller;
with Exceeding_Limits;
with Invalid_Appends;

package body Invalids_Suite is

   package Exceeding_Limits_Test_Caller is new AUnit.Test_Caller(Exceeding_Limits.Test_Fixture);
   package Invalid_Appends_Test_Caller is new AUnit.Test_Caller(Invalid_Appends.Test_Fixture);   
   
   function Suite return Access_Test_Suite is
      Invalids_Suite : constant Access_Test_Suite := new Test_Suite;
   begin
      -- Exceeding Limits Tests --------------------------------- 
      Invalids_Suite.Add_Test(Exceeding_Limits_Test_Caller.Create("Exceeding_Limits Exceed_Supported_Integer_Length", Exceeding_Limits.Exceed_Supported_Integer_Length'Access));
      Invalids_Suite.Add_Test(Exceeding_Limits_Test_Caller.Create("Exceeding_Limits Exceed_Supported_Float_Length", Exceeding_Limits.Exceed_Supported_Float_Length'Access));
      
      -- Invalid Appends Tests --------------------------------- 
      Invalids_Suite.Add_Test(Invalid_Appends_Test_Caller.Create("Invalid_Appends More_Than_One_Leading_Zero", Invalid_Appends.More_Than_One_Leading_Zero'Access));
      Invalids_Suite.Add_Test(Invalid_Appends_Test_Caller.Create("Invalid_Appends Underscore_After_Non_Digit", Invalid_Appends.Underscore_After_Non_Digit'Access));
      
      return Invalids_Suite;
   end Suite;
      
end Invalids_Suite;
