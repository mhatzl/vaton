with Ada.Numerics.Big_Numbers.Big_Reals;

package Vaton.Float_Conversions with SPARK_Mode is

   generic
      type Float_Base is digits <>;
      
      --with function "-"(L,R : Float_Base) return Float_Base;
      with function "+"(L,R : Float_Base) return Float_Base;
      with function "*"(L,R : Float_Base) return Float_Base;
      with function "/"(L,R : Float_Base) return Float_Base;
      with function "**"(L : Float_Base; R : Standard.Integer) return Float_Base;
      --with function "<"(L,R : Float_Base) return Boolean;
      --with function ">"(L,R : Float_Base) return Boolean;
      --with function ">="(L,R : Float_Base) return Boolean;
      with function To_Float_Base(Integer_Part : Number) return Float_Base;
   function Convert(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Float_Base
     with Pre => Is_Valid_Number(Partial_Number);
   
   function Convert_Big_Real(Partial_Number : Number_Pieces; Exponent : Standard.Integer) return Ada.Numerics.Big_Numbers.Big_Reals.Valid_Big_Real
     with Pre => Is_Valid_Number(Partial_Number);
   
   
   function Number_To_Float(Integer_Part : Number) return Standard.Float
     with Pre => Integer_Part.Kind = Integer;
   
   function Number_To_Long_Float(Integer_Part : Number) return Standard.Long_Float
     with Pre => Integer_Part.Kind = Integer or else Integer_Part.Kind = Long_Integer;

   function Number_To_Long_Long_Float(Integer_Part : Number) return Standard.Long_Long_Float
     with Pre => Integer_Part.Kind = Integer or else Integer_Part.Kind = Long_Integer or else Integer_Part.Kind = Long_Long_Integer;
   
   function Number_To_Big_Real(Integer_Part : Number) return Ada.Numerics.Big_Numbers.Big_Reals.Valid_Big_Real
     with Pre => Integer_Part.Kind = Integer or else Integer_Part.Kind = Long_Integer or else Integer_Part.Kind = Long_Long_Integer or else Integer_Part.Kind = Big_Integer;
   
end Vaton.Float_Conversions;
