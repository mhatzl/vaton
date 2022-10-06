with AUnit.Test_Caller;
with Standard_Floats;
with Long_Floats;
with Long_Long_Floats;
with Big_Floats;

package body Floating_Points_Suite is

   package Standard_Floats_Test_Caller is new AUnit.Test_Caller(Standard_Floats.Test_Fixture);
   package Long_Floats_Test_Caller is new AUnit.Test_Caller(Long_Floats.Test_Fixture);
   package Long_Long_Floats_Test_Caller is new AUnit.Test_Caller(Long_Long_Floats.Test_Fixture);
   package Big_Floats_Test_Caller is new AUnit.Test_Caller(Big_Floats.Test_Fixture);
   
   function Suite return Access_Test_Suite is
      Floating_Points_Suite : constant Access_Test_Suite := new Test_Suite;
   begin
      -- Note: All floating point tests compare for equality. This is possible, because the conversions keep in the precision range of each floating point type.
      -- Some really high numbers might not work, but most do.
      
      -- Standard Float Tests --------------------------------- 
      Floating_Points_Suite.Add_Test(Standard_Floats_Test_Caller.Create("Standard_Floats Create_Positive_Float", Standard_Floats.Create_Positive_Float'Access));
      Floating_Points_Suite.Add_Test(Standard_Floats_Test_Caller.Create("Standard_Floats Create_Negative_Float", Standard_Floats.Create_Negative_Float'Access));
      Floating_Points_Suite.Add_Test(Standard_Floats_Test_Caller.Create("Standard_Floats Create_Zero", Standard_Floats.Create_Zero'Access));
      Floating_Points_Suite.Add_Test(Standard_Floats_Test_Caller.Create("Standard_Floats Use_Underline_Randomly", Standard_Floats.Use_Underline_Randomly'Access));
      Floating_Points_Suite.Add_Test(Standard_Floats_Test_Caller.Create("Standard_Floats With_Positive_Exponent", Standard_Floats.With_Positive_Exponent'Access));
      Floating_Points_Suite.Add_Test(Standard_Floats_Test_Caller.Create("Standard_Floats With_Implicit_Positive_Exponent", Standard_Floats.With_Implicit_Positive_Exponent'Access));
      Floating_Points_Suite.Add_Test(Standard_Floats_Test_Caller.Create("Standard_Floats With_Negative_Exponent", Standard_Floats.With_Negative_Exponent'Access));
      
      -- Long Float Tests ---------------------------------
      Floating_Points_Suite.Add_Test(Long_Floats_Test_Caller.Create("Long_Floats Create_Positive_Float", Long_Floats.Create_Positive_Float'Access));
      Floating_Points_Suite.Add_Test(Long_Floats_Test_Caller.Create("Long_Floats Create_Negative_Float", Long_Floats.Create_Negative_Float'Access));
      Floating_Points_Suite.Add_Test(Long_Floats_Test_Caller.Create("Long_Floats With_Positive_Exponent", Long_Floats.With_Positive_Exponent'Access));
      Floating_Points_Suite.Add_Test(Long_Floats_Test_Caller.Create("Long_Floats With_Implicit_Positive_Exponent", Long_Floats.With_Implicit_Positive_Exponent'Access));
      Floating_Points_Suite.Add_Test(Long_Floats_Test_Caller.Create("Long_Floats With_Negative_Exponent", Long_Floats.With_Negative_Exponent'Access));
      
      -- Long Long Float Tests ---------------------------------
      Floating_Points_Suite.Add_Test(Long_Long_Floats_Test_Caller.Create("Long_Long_Floats Create_Positive_Float", Long_Long_Floats.Create_Positive_Float'Access));
      Floating_Points_Suite.Add_Test(Long_Long_Floats_Test_Caller.Create("Long_Long_Floats Create_Negative_Float", Long_Long_Floats.Create_Negative_Float'Access));
      Floating_Points_Suite.Add_Test(Long_Long_Floats_Test_Caller.Create("Long_Long_Floats With_Positive_Exponent", Long_Long_Floats.With_Positive_Exponent'Access));
      Floating_Points_Suite.Add_Test(Long_Long_Floats_Test_Caller.Create("Long_Long_Floats With_Implicit_Positive_Exponent", Long_Long_Floats.With_Implicit_Positive_Exponent'Access));
      Floating_Points_Suite.Add_Test(Long_Long_Floats_Test_Caller.Create("Long_Long_Floats With_Negative_Exponent", Long_Long_Floats.With_Negative_Exponent'Access));
      
      -- Big Real Tests --------------------------------- 
      Floating_Points_Suite.Add_Test(Big_Floats_Test_Caller.Create("Big_Floats Create_Positive_Float", Big_Floats.Create_Positive_Float'Access));
      Floating_Points_Suite.Add_Test(Big_Floats_Test_Caller.Create("Big_Floats Create_Negative_Float", Big_Floats.Create_Negative_Float'Access));
      Floating_Points_Suite.Add_Test(Big_Floats_Test_Caller.Create("Big_Floats With_Positive_Exponent", Big_Floats.With_Positive_Exponent'Access));
      Floating_Points_Suite.Add_Test(Big_Floats_Test_Caller.Create("Big_Floats With_Implicit_Positive_Exponent", Big_Floats.With_Implicit_Positive_Exponent'Access));
      Floating_Points_Suite.Add_Test(Big_Floats_Test_Caller.Create("Big_Floats With_Negative_Exponent", Big_Floats.With_Negative_Exponent'Access));
      
      return Floating_Points_Suite;
   end Suite;


end Floating_Points_Suite;
