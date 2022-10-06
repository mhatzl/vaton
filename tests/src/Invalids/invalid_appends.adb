with AUnit.Assertions; use AUnit.Assertions;
with Vaton; use Vaton;

package body Invalid_Appends is

   procedure More_Than_One_Leading_Zero(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
   begin
      Vaton.Append(Partial_Number, '0', Success);
      Assert(Success, "Appending number failed");
      
      Assert(Vaton.Is_Possible_Piece(Partial_Number, Character => '0') = False, "More than one leading zero was allowed");
   end More_Than_One_Leading_Zero;
   
   procedure Underscore_After_Non_Digit(T : in out Test_Fixture) is
      Partial_Number : Vaton.Number_Pieces;
      Success : Boolean;
   begin
      Vaton.Append(Partial_Number, '-', Success);
      Assert(Success, "Appending minus failed");
      
      Assert(Vaton.Is_Possible_Piece(Partial_Number, Character => '_') = False, "Underscore after minus was allowed");
      
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '_', Success);
      Assert(Success, "Appending underscore failed");
      
      Assert(Vaton.Is_Possible_Piece(Partial_Number, Character => '_') = False, "Underscore after underscore was allowed");
      
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, '.', Success);
      Assert(Success, "Appending number failed");
      
      Assert(Vaton.Is_Possible_Piece(Partial_Number, Character => '_') = False, "Underscore after decimal point was allowed");
      
      Vaton.Append(Partial_Number, '1', Success);
      Assert(Success, "Appending number failed");
      
      Vaton.Append(Partial_Number, 'e', Success);
      Assert(Success, "Appending exponent mark failed");
      
      Assert(Vaton.Is_Possible_Piece(Partial_Number, Character => '_') = False, "Underscore after exponent start was allowed");
   end Underscore_After_Non_Digit;

end Invalid_Appends;
