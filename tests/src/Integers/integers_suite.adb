with AUnit.Test_Caller;
with Standard_Integer;
with Long_Integers;
with Long_Long_Integers;
with Big_Integers;

package body Integers_Suite is

   package Standard_Integer_Test_Caller is new AUnit.Test_Caller(Standard_Integer.Test_Fixture);
   package Long_Integers_Test_Caller is new AUnit.Test_Caller(Long_Integers.Test_Fixture);
   package Long_Long_Integers_Test_Caller is new AUnit.Test_Caller(Long_Long_Integers.Test_Fixture);
   package Big_Integers_Test_Caller is new AUnit.Test_Caller(Big_Integers.Test_Fixture);
   
   function Suite return Access_Test_Suite is
      Integer_Suite : constant Access_Test_Suite := new Test_Suite;
   begin
      -- Standard Integer Tests --------------------------------- 
      Integer_Suite.Add_Test(Standard_Integer_Test_Caller.Create("Standard_Integer Create_Positive_Integer", Standard_Integer.Create_Positive_Integer'Access));
      Integer_Suite.Add_Test(Standard_Integer_Test_Caller.Create("Standard_Integer Create_Negative_Integer", Standard_Integer.Create_Negative_Integer'Access));
      Integer_Suite.Add_Test(Standard_Integer_Test_Caller.Create("Standard_Integer Create_Zero", Standard_Integer.Create_Zero'Access));
      Integer_Suite.Add_Test(Standard_Integer_Test_Caller.Create("Standard_Integer Use_Underline_As_Thousand_Separator", Standard_Integer.Use_Underline_As_Thousand_Separator'Access));
      Integer_Suite.Add_Test(Standard_Integer_Test_Caller.Create("Standard_Integer Use_Underline_Randomly", Standard_Integer.Use_Underline_Randomly'Access));
      
      -- Long Integer Tests ---------------------------------
      -- Note: Integer and Long_Integer might be both 32-Bit, so Long_Integer will not be chosen
      if Standard.Integer'Size < Standard.Long_Integer'Size then
         Integer_Suite.Add_Test(Long_Integers_Test_Caller.Create("Long_Integer Create_Positive_Integer", Long_Integers.Create_Positive_Integer'Access));
         Integer_Suite.Add_Test(Long_Integers_Test_Caller.Create("Long_Integer Create_Negative_Integer", Long_Integers.Create_Negative_Integer'Access));
      end if;
      
      -- Long Long Integer Tests ---------------------------------
      if Standard.Long_Integer'Size < Standard.Long_Long_Integer'Size then 
         Integer_Suite.Add_Test(Long_Long_Integers_Test_Caller.Create("Long_Long_Integer Create_Positive_Integer", Long_Long_Integers.Create_Positive_Integer'Access));
         Integer_Suite.Add_Test(Long_Long_Integers_Test_Caller.Create("Long_Long_Integer Create_Negative_Integer", Long_Long_Integers.Create_Negative_Integer'Access));
      end if;
      
      -- Big Integer Tests --------------------------------- 
      Integer_Suite.Add_Test(Big_Integers_Test_Caller.Create("Big_Integer Create_Positive_Integer", Big_Integers.Create_Positive_Integer'Access));
      Integer_Suite.Add_Test(Big_Integers_Test_Caller.Create("Big_Integer Create_Negative_Integer", Big_Integers.Create_Negative_Integer'Access));
      
      return Integer_Suite;
   end Suite;

end Integers_Suite;
