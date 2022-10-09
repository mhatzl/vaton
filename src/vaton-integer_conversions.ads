package Vaton.Integer_Conversions with SPARK_Mode is
  
   generic
      type Integer_Base is range <>;
      
      with function "-"(L,R : Integer_Base) return Integer_Base;
      with function "+"(L,R : Integer_Base) return Integer_Base;
      with function "*"(L,R : Integer_Base) return Integer_Base;
      with function To_Integer_Base(Number : Standard.Integer) return Integer_Base;
   function Convert(Partial_Integer : Digit_Array.Unbound_Array; Is_Negative : Boolean) return Integer_Base
     with Pre => not Digit_Array.Is_Empty(Partial_Integer) and then Digit_Array.Length (Partial_Integer) <= BIG_NUMBER_DIGIT_LIMIT
     and then Digit_Array.Length (Partial_Integer) * BASE_10_LENGTH_TO_BIT_SIZE < Integer_Base'Size;
   
   function Convert_Big_Integer(Partial_Integer : Digit_Array.Unbound_Array; Is_Negative : Boolean) return Number
     with Pre => not Digit_Array.Is_Empty(Partial_Integer) and then Digit_Array.Length (Partial_Integer) <= BIG_NUMBER_DIGIT_LIMIT,
     Post => Convert_Big_Integer'Result.Kind = Big_Integer;

   
   -- Wrapper functions to be used for 'To_Integer_Base'
   
   function Integer_To_Integer (Value : Standard.Integer) return Standard.Integer is
     (Value)
     with Post => Integer_To_Integer'Result = Value;
   
   function Integer_To_Long_Integer (Value : Standard.Integer) return Standard.Long_Integer is
     (Standard.Long_Integer(Value))
       with Post => Integer_To_Long_Integer'Result = Standard.Long_Integer(Value);
   
   function Integer_To_Long_Long_Integer (Value : Standard.Integer) return Standard.Long_Long_Integer is
     (Standard.Long_Long_Integer(Value))
       with Post => Integer_To_Long_Long_Integer'Result = Standard.Long_Long_Integer(Value);
   
end Vaton.Integer_Conversions;
