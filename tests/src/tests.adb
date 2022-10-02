with Vaton; use Vaton;
with Text_IO;

procedure Tests is
   Split_Number     : Vaton.Number_Pieces;
   Assembled_Number : Vaton.Number;
   Success          : Boolean;
begin

   Vaton.Append (Partial_Number => Split_Number, Character => '-', Success => Success);
   for Index in 2 .. 1_900 loop
      Vaton.Append (Partial_Number => Split_Number, Character => '1', Success => Success);
   end loop;
   Vaton.Append (Partial_Number => Split_Number, Character => '.', Success => Success);
   Vaton.Append (Partial_Number => Split_Number, Character => '1', Success => Success);

   if Vaton.Is_Possible_Piece (Partial_Number => Split_Number, Character => 'A') then
      Vaton.Append
        (Partial_Number => Split_Number, Character => 'A', Success => Success); -- bad char
   end if;

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

end Tests;
