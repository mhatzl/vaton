with Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Numerics.Big_Numbers.Big_Reals;
with Spark_Unbound.Arrays;

package Vaton with
   SPARK_Mode
is
   package Big_Numbers renames Ada.Numerics.Big_Numbers;

   BIG_NUMBER_DIGIT_LIMIT : constant Standard.Integer :=
     1_900; -- Limitation of the Big_Number implementation

   type Number_Kind is
     (NaN, Float, Integer, Long_Float, Long_Long_Float, Long_Integer, Long_Long_Integer, Big_Real,
      Big_Integer);

   type Number (Kind : Number_Kind := NaN) is record
      case Kind is
         when NaN =>
            null;
         when Float =>
            Float : Standard.Float := 0.0;
         when Integer =>
            Integer : Standard.Integer := 0;
         when Long_Float =>
            Long_Float : Standard.Long_Float := 0.0;
         when Long_Integer =>
            Long_Integer : Standard.Long_Integer := 0;
         when Long_Long_Float =>
            Long_Long_Float : Standard.Long_Long_Float := 0.0;
         when Long_Long_Integer =>
            Long_Long_Integer : Standard.Long_Long_Integer := 0;
         when Big_Real =>
            Big_Real : Big_Numbers.Big_Reals.Valid_Big_Real := 0.0;
         when Big_Integer =>
            Big_Integer : Big_Numbers.Big_Integers.Valid_Big_Integer := 0;
      end case;
   end record;

   type Digit is range 0 .. 9;

   package Digit_Array is new Spark_Unbound.Arrays (Element_Type => Digit, Index_Type => Positive);
   use Digit_Array;

   type Number_Pieces is record
      Whole                : Digit_Array.Unbound_Array;
      Fraction             : Digit_Array.Unbound_Array;
      Exponent             : Digit_Array.Unbound_Array;
      Whole_Is_Negative    : Boolean := False;
      Exponent_Is_Negative : Boolean := False;
      Has_Exponent         : Boolean := False;
      Has_Fraction         : Boolean := False;
      Next_Must_Be_Digit   : Boolean := False;
   end record;

   overriding function "=" (Left, Right : Number_Pieces) return Boolean is
     (Left.Whole = Right.Whole and then Left.Fraction = Right.Fraction
      and then Left.Exponent = Right.Exponent
      and then Left.Whole_Is_Negative = Right.Whole_Is_Negative
      and then Left.Exponent_Is_Negative = Right.Exponent_Is_Negative
      and then Left.Has_Exponent = Right.Has_Exponent
      and then Left.Has_Fraction = Right.Has_Fraction);

   -- Function returns `True` if the given character is a decimal digit (0..9).
   function Is_Digit (Character : Wide_Character) return Boolean;

   -- Function to convert the character representation of a digit into the Digit type.
   function Character_To_Digit (Character : Wide_Character) return Digit with
      Pre => Is_Digit (Character);

   -- Function returns `True` if the given character could represent a part of a number.
   -- e.g. `-` is allowed at the beginning of the whole number and the exponential number,
   -- the decimal point marks the beginning of the fraction part,
   -- and `e` or `E` mark the beginning of the exponential part.
   -- '+' may be set after the beginning of the exponential part.
   -- Underscore '_' is allowed between digits.
   -- Digits 0..9 are always possible.
   function Is_Possible_Piece
     (Partial_Number : Number_Pieces; Character : Wide_Character;
      Decimal_Point  : Wide_Character := '.') return Boolean with
      Pre => Is_Valid_Decimal_Point (Decimal_Point);

   function Is_Valid_Partial_Number (Partial_Number : Number_Pieces) return Boolean;

   function Is_Valid_Number (Partial_Number : Number_Pieces) return Boolean;

   function Is_Valid_Decimal_Point (Decimal_Point : Wide_Character := '.') return Boolean is
     (not
      (Decimal_Point = '-' or else Decimal_Point = '+' or else Decimal_Point = '_'
       or else Decimal_Point = 'e' or else Decimal_Point = 'E' or else Is_Digit (Decimal_Point)));

   function To_Number (Partial_Number : Number_Pieces) return Number with
      Pre => Is_Valid_Number (Partial_Number);

   function To_Integer
     (Partial_Integer : Digit_Array.Unbound_Array; Is_Negative : Boolean) return Number;

   procedure Append
     (Partial_Number : in out Number_Pieces; Character : Wide_Character; Success : out Boolean;
      Decimal_Point  :        Wide_Character := '.') with
      Pre => Is_Valid_Decimal_Point (Decimal_Point)
      and then Is_Possible_Piece (Partial_Number, Character, Decimal_Point)
      and then Is_Valid_Partial_Number (Partial_Number),
      Post => Is_Valid_Partial_Number (Partial_Number);

   procedure Reset (Partial_Number : in out Number_Pieces);

private

   -- 4 is a good enough approximation from bits to base 10 length (log(10)/log(2) ~ 3.4 would be correct, but would require float conversions)
   BASE_10_LENGTH_TO_BIT_SIZE : constant Standard.Integer := 4;
   BASE_10                    : constant Standard.Integer := 10;

   -- 0.3 is approximation for log(2)/log(10) to get lower bound
   -- Note: 2^Standard.Float'EMax = 10^MAX_FLOAT_EXPONENT => log(2)/log(10) * Standard.Float'EMax = MAX_FLOAT_EXPONENT
   -- Note: Length of whole part must also be added since normalization moves number to 1.x
   MAX_FLOAT_EXPONENT : constant Standard.Integer :=
     Standard.Integer (0.3 * Standard.Float'Machine_Emax);
   MIN_FLOAT_EXPONENT : constant Standard.Integer :=
     Standard.Integer (0.3 * Standard.Float'Machine_Emin);

   MAX_LONG_FLOAT_EXPONENT : constant Standard.Integer :=
     Standard.Integer (0.3 * Standard.Long_Float'Machine_Emax);
   MIN_LONG_FLOAT_EXPONENT : constant Standard.Integer :=
     Standard.Integer (0.3 * Standard.Long_Float'Machine_Emin);

   MAX_LONG_LONG_FLOAT_EXPONENT : constant Standard.Integer :=
     Standard.Integer (0.3 * Standard.Long_Long_Float'Machine_Emax);
   MIN_LONG_LONG_FLOAT_EXPONENT : constant Standard.Integer :=
     Standard.Integer (0.3 * Standard.Long_Long_Float'Machine_Emin);

end Vaton;
