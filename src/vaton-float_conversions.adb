package body Vaton.Float_Conversions with SPARK_Mode is

   function Convert(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Float_Base is
      Combined : Float_Base := To_Float_Base(To_Integer(Partial_Number.Whole, False));
      Fraction : Float_Base;
      Divisor : Natural;
   begin
      if Partial_Number.Has_Fraction then
         Fraction := To_Float_Base(To_Integer(Partial_Number.Fraction, False));
         Divisor := BASE_10 * Digit_Array.Length(Partial_Number.Fraction);
         Fraction := Fraction / To_Float_Base(Number'(Kind => Integer, Integer => Divisor));
         Combined := Combined + Fraction;
      end if;
      
      if Partial_Number.Has_Exponent then
         Combined := Combined ** Exponent;
      end if;

      if Partial_Number.Whole_Is_Negative then
         Combined := Combined * To_Float_Base(Number'(Kind => Integer, Integer => -1));
      end if;
      
      return Combined;
   end Convert;
   
   function Convert_Big_Real(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Ada.Numerics.Big_Numbers.Big_Reals.Valid_Big_Real is
      Combined : Ada.Numerics.Big_Numbers.Big_Reals.Valid_Big_Real := Number_To_Big_Real(To_Integer(Partial_Number.Whole, False));
      Fraction : Ada.Numerics.Big_Numbers.Big_Reals.Valid_Big_Real;
      Divisor : Natural;
   begin
      if Partial_Number.Has_Fraction then
         Fraction := Number_To_Big_Real(To_Integer(Partial_Number.Fraction, False));
         Divisor := BASE_10 * Digit_Array.Length(Partial_Number.Fraction);
         Fraction := Ada.Numerics.Big_Numbers.Big_Reals."/"(Fraction, Ada.Numerics.Big_Numbers.Big_Reals.To_Real(Divisor));
         Combined := Ada.Numerics.Big_Numbers.Big_Reals."+"(Combined, Fraction);
      end if;
      
      if Partial_Number.Has_Exponent then
         Combined := Ada.Numerics.Big_Numbers.Big_Reals."**"(Combined, Exponent);
      end if;

      if Partial_Number.Whole_Is_Negative then
         Combined := Ada.Numerics.Big_Numbers.Big_Reals."*"(Combined, Ada.Numerics.Big_Numbers.Big_Reals.To_Real(-1));
      end if;
      
      return Combined;
   end Convert_Big_Real;
   
   function Number_To_Float(Integer_Part : Number) return Standard.Float is
   begin
      return Standard.Float(Integer_Part.Integer);
   end Number_To_Float;

   function Number_To_Long_Float(Integer_Part : Number) return Standard.Long_Float is
   begin
      case Integer_Part.Kind is
         when Integer => return Standard.Long_Float(Integer_Part.Integer);
         when Long_Integer => return Standard.Long_Float(Integer_Part.Long_Integer);
         when others => raise Program_Error;
      end case;
   end Number_To_Long_Float;
   
   function Number_To_Long_Long_Float(Integer_Part : Number) return Standard.Long_Long_Float is
   begin
      case Integer_Part.Kind is
         when Integer => return Standard.Long_Long_Float(Integer_Part.Integer);
         when Long_Integer => return Standard.Long_Long_Float(Integer_Part.Long_Integer);
         when Long_Long_Integer => return Standard.Long_Long_Float(Integer_Part.Long_Long_Integer);
         when others => raise Program_Error;
      end case;
   end Number_To_Long_Long_Float;
   
   function Number_To_Big_Real(Integer_Part : Number) return Ada.Numerics.Big_Numbers.Big_Reals.Valid_Big_Real is
      package Long_To_Big is new Ada.Numerics.Big_Numbers.Big_Integers.Signed_Conversions(Int => Standard.Long_Integer);
      package Long_Long_To_Big is new Ada.Numerics.Big_Numbers.Big_Integers.Signed_Conversions(Int => Standard.Long_Long_Integer);
   begin
      case Integer_Part.Kind is
         when Integer => return Ada.Numerics.Big_Numbers.Big_Reals.To_Real(Integer_Part.Integer);
         when Long_Integer => return Ada.Numerics.Big_Numbers.Big_Reals.To_Big_Real(Long_To_Big.To_Big_Integer(Integer_Part.Long_Integer));
         when Long_Long_Integer => return Ada.Numerics.Big_Numbers.Big_Reals.To_Big_Real(Long_Long_To_Big.To_Big_Integer(Integer_Part.Long_Long_Integer));
         when Big_Integer => return Ada.Numerics.Big_Numbers.Big_Reals.To_Big_Real(Integer_Part.Big_Integer);
         when others => raise Program_Error;
      end case;
   end Number_To_Big_Real;

end Vaton.Float_Conversions;
