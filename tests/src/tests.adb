with Vaton; use Vaton;
with Text_IO;
with AUnit.Reporter.Text;
with AUnit.Run;
with GNAT.OS_Lib;
with Integers_Suite;
with Floating_Points_Suite;
with Invalids_Suite;

procedure Tests is
   use type AUnit.Status;

   Reporter : AUnit.Reporter.Text.Text_Reporter;

   function Integers_Test_Runner is new AUnit.Run.Test_Runner_With_Status(Integers_Suite.Suite);
   function Floating_Points_Test_Runner is new AUnit.Run.Test_Runner_With_Status(Floating_Points_Suite.Suite);
   function Invalids_Test_Runner is new AUnit.Run.Test_Runner_With_Status(Invalids_Suite.Suite);

   procedure Manual_Test is
      Split_Number     : Vaton.Number_Pieces;
      Assembled_Number : Vaton.Number;
      Success          : Boolean;
   begin
      Vaton.Append (Partial_Number => Split_Number, Character => '-', Success => Success);
      Vaton.Append (Partial_Number => Split_Number, Character => '1', Success => Success);
      Vaton.Append (Partial_Number => Split_Number, Character => '.', Success => Success);
      Vaton.Append (Partial_Number => Split_Number, Character => '2', Success => Success);
      Vaton.Append (Partial_Number => Split_Number, Character => '3', Success => Success);

      Assembled_Number := Vaton.To_Number (Partial_Number => Split_Number);

      Text_IO.Put_Line ("Converted Number");
      if Assembled_Number.Kind = Vaton.Integer then
         Text_IO.Put ("Integer: ");
         Text_IO.Put_Line (Assembled_Number.Integer'Image);
      elsif Assembled_Number.Kind = Vaton.Long_Integer then
         Text_IO.Put ("Long_Integer: ");
         Text_IO.Put_Line (Assembled_Number.Long_Integer'Image);
      elsif Assembled_Number.Kind = Vaton.Long_Long_Integer then
         Text_IO.Put ("Long_Long_Integer: ");
         Text_IO.Put_Line (Assembled_Number.Long_Long_Integer'Image);
      elsif Assembled_Number.Kind = Vaton.Big_Integer then
         Text_IO.Put ("Big_Integer: ");
         Text_IO.Put_Line (Assembled_Number.Big_Integer'Image);
      elsif Assembled_Number.Kind = Vaton.Float then
         Text_IO.Put ("Float: ");
         Text_IO.Put_Line (Assembled_Number.Float'Image);
      elsif Assembled_Number.Kind = Vaton.Long_Float then
         Text_IO.Put ("Long Float: ");
         Text_IO.Put_Line (Assembled_Number.Long_Float'Image);
      elsif Assembled_Number.Kind = Vaton.Long_Long_Float then
         Text_IO.Put ("Long Long Float: ");
         Text_IO.Put_Line (Assembled_Number.Long_Long_Float'Image);
      elsif Assembled_Number.Kind = Vaton.Big_Real then
         Text_IO.Put ("Big Real: ");
         Text_IO.Put_Line (Assembled_Number.Big_Real'Image);
      elsif Assembled_Number.Kind = Vaton.NaN then
         Text_IO.Put_Line ("Given characters did not resolve to a number!");
      end if;
   end Manual_Test;

begin
   Tests.Manual_Test;

   -- Run valid Integer conversion tests
   if Integers_Test_Runner(Reporter) /= AUnit.Success then
      GNAT.OS_Lib.OS_Exit(1);
   end if;

   -- Run valid Float conversion tests
   if Floating_Points_Test_Runner(Reporter) /= AUnit.Success then
      GNAT.OS_Lib.OS_Exit(1);
   end if;

   -- Run invalid conversion tests
   if Invalids_Test_Runner(Reporter) /= AUnit.Success then
      GNAT.OS_Lib.OS_Exit(1);
   end if;

end Tests;

