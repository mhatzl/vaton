package Vaton.Float_Conversions with SPARK_Mode is

   generic
      type Float_Base is digits <>;
      
      with function "+"(L,R : Float_Base) return Float_Base;
      with function "*"(L,R : Float_Base) return Float_Base;
      with function "/"(L,R : Float_Base) return Float_Base;
      with function "**"(L : Float_Base; R : Standard.Integer) return Float_Base;
      with function "<"(L,R : Float_Base) return Boolean;
      with function To_Float_Base(Number : Standard.Integer) return Float_Base;
      
      MAX_DIGITS : Standard.Integer;
      MIN_DIGITS : Standard.Integer;
   function Combine(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Float_Base
     with Pre => Is_Valid_Number(Partial_Number) and then Digit_Array.Length (Partial_Number.Whole) <= MAX_DIGITS - Digit_Array.Length (Partial_Number.Fraction)
      and then (if Exponent >= 0 then Exponent <= MAX_DIGITS - Digit_Array.Length (Partial_Number.Fraction) - Digit_Array.Length (Partial_Number.Whole)
     	else Exponent + Digit_Array.Length (Partial_Number.Whole) + Digit_Array.Length (Partial_Number.Fraction) >= MIN_DIGITS);
   
   function Convert_Big_Real(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Number
     with Pre => Is_Valid_Number(Partial_Number) and then Digit_Array.Length (Partial_Number.Whole) <= BIG_NUMBER_DIGIT_LIMIT - Digit_Array.Length (Partial_Number.Fraction)
      and then (if Exponent >= 0 then Exponent <= BIG_NUMBER_DIGIT_LIMIT - Digit_Array.Length (Partial_Number.Fraction) - Digit_Array.Length (Partial_Number.Whole)
     	else Exponent + Digit_Array.Length (Partial_Number.Whole) + Digit_Array.Length (Partial_Number.Fraction) >= (-BIG_NUMBER_DIGIT_LIMIT)),
     Post => Convert_Big_Real'Result.Kind = Big_Real;
   
   
   function Number_To_Float(Number : Standard.Integer) return Standard.Float
     with Post => Number_To_Float'Result = Standard.Float(Number);
   
   function Number_To_Long_Float(Number : Standard.Integer) return Standard.Long_Float
     with Post => Number_To_Long_Float'Result = Standard.Long_Float(Number);

   function Number_To_Long_Long_Float(Number : Standard.Integer) return Standard.Long_Long_Float
     with Post => Number_To_Long_Long_Float'Result = Standard.Long_Long_Float(Number);
   
   function Number_To_Big_Real(Integer_Part : Number) return Ada.Numerics.Big_Numbers.Big_Reals.Valid_Big_Real
     with Pre => Integer_Part.Kind = Integer or else Integer_Part.Kind = Long_Integer or else Integer_Part.Kind = Long_Long_Integer or else Integer_Part.Kind = Big_Integer;
   
end Vaton.Float_Conversions;
