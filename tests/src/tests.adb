with Vaton; use Vaton;
with Text_IO;

procedure Tests is
   Split_Number : Vaton.Number_Pieces;
   Assembled_Number : Vaton.Number;
   Success : Boolean;
begin
   Vaton.Append(Partial_Number => Split_Number, Character => '0', Success => Success);
   if Vaton.Is_Possible_Piece(Partial_Number => Split_Number, Character => '1') then
      Text_IO.Put_Line("Leading zeros not allowed!");
      Reset(Split_Number);
   end if;

   Vaton.Append(Partial_Number => Split_Number, Character => '-', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '1', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '2', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '3', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '_', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '4', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '5', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '6', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '_', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '7', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '8', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '9', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '0', Success => Success); -- needs 64 Bit
   Vaton.Append(Partial_Number => Split_Number, Character => '1', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '2', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '3', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '4', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '5', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '6', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '7', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '8', Success => Success);
   Vaton.Append(Partial_Number => Split_Number, Character => '9', Success => Success); -- needs >64 Bit


   if Vaton.Is_Possible_Piece(Partial_Number => Split_Number, Character => 'A') then
      Vaton.Append(Partial_Number => Split_Number, Character => 'A', Success => Success); -- bad char
   end if;

   Assembled_Number := Vaton.To_Number(Partial_Number => Split_Number);

   Text_IO.Put_Line("Converted Number");
   if Assembled_Number.Kind = Vaton.Integer then
      Text_IO.Put("Integer: ");
      Text_IO.Put_Line(Assembled_Number.Integer'Image);
   elsif Assembled_Number.Kind = Vaton.Long_Integer then
      Text_IO.Put("Long_Integer: ");
      Text_IO.Put_Line(Assembled_Number.Long_Integer'Image);
   elsif Assembled_Number.Kind = Vaton.Long_Long_Integer then
      Text_IO.Put("Long_Long_Integer: ");
      Text_IO.Put_Line(Assembled_Number.Long_Long_Integer'Image);
   elsif Assembled_Number.Kind = Vaton.Big_Integer then
      Text_IO.Put("Big_Integer: ");
      Text_IO.Put_Line(Assembled_Number.Big_Integer'Image);
   elsif Assembled_Number.Kind = Vaton.NaN then
      Text_IO.Put_Line("Given characters did not resolve to a number!");
   end if;

end Tests;
