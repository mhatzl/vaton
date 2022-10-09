# vaton

Verified Ascii To Number conversion written in Ada/SPARK.

This library offers formally verified functions to convert character streams into the smallest standard type representation the resulting number may fit in.
The allowed formats are based on the [JSON-Number format](https://www.json.org/json-en.html), with the addition to allow single underscores between digits.

**Note:** Only decimal based numbers are supported!

**Examples:**

```
-10_000 -> Standard.Integer
1.0 -> Standard.Float
1e4 -> Standard.Float
```

## Usage

The conversion starts with the type `Number_Pieces` that is used to keep track of the different parts of a number, like fraction or exponent.
A new character is added using the `Append` procedure. After all characters have been set using `Append`, the function `To_Number` may be used
to create a number with the converted value being represented in the smallest type the value may fit in.

**Example:**

```Ada
with Vaton; use Vaton;

procedure Conversion_Test is
  Split_Number     : Vaton.Number_Pieces;
  Assembled_Number : Vaton.Number;
  Success          : Boolean;
begin
  Vaton.Append (Partial_Number => Split_Number, Character => '-', Success => Success);
  Vaton.Append (Partial_Number => Split_Number, Character => '1', Success => Success);
  Vaton.Append (Partial_Number => Split_Number, Character => '2', Success => Success);
  Vaton.Append (Partial_Number => Split_Number, Character => '3', Success => Success)

  Assembled_Number := Vaton.To_Number (Partial_Number => Split_Number);

  pragma Assert(Assembled_Number.Kind = Vaton.Integer);
  pragma Assert(Assembled_Number.Integer = -123);
end Conversion_Test;
```

## Supported Types

The `Number` type supports the following types:

- `Integer` representing `Standard.Integer`
- `Long_Integer` representing `Standard.Long_Integer`
- `Long_Long_Integer` representing `Standard.Long_Long_Integer`
- `Big_Integer` representing `Ada.Numerics.Big_Numbers.Big_Integers.Valid_Big_Integer`
- `Float` representing `Standard.Float`
- `Long_Float` representing `Standard.Long_Float`
- `Long_Long_Float` representing `Standard.Long_Long_Float`
- `Big_Real` representing `Ada.umerics.Big_Numbers.Big_Reals.Valid_Big_Real`

## Smallest Type Selection

Since the type ranges might be platform dependent, the ranges are approximated using different type attributes.

The `Size` attribute is used for discrete (integer) types, where the length of a given number must not exceed four times this size.
This approximation is based on the correlation between bit- and decimal-length being `log(10)/log(2) ~ 3.4`.
If none of the standard integers are within the length of the given number, it is converted to `Big_Integer`.

**Note:** In the GNAT implementation, Big_Integers are bound to ~1900 digits! To prevent `Contraint_Error`s, this limit is also used in Vaton.

For floating point ranges, the attributes `Machine_Emin`, `Machine_Emax` are used to get the smallest/largest exponent of a type,
and the `Digits` attribute to get the maximal precision a type supports.

**Note:** For `Big_Real` the same digit limit applies as for `Big_Integer`!

## Crate State

This crate was created to showcase a possible usage scenario for the [Spark_Unbound]() crate.

At the moment, absence of Runtime Errors is not yet fully proven for floating point and `Long_Long_Integer` conversions.
Functional correctness is partially supplied by unit tests, but not formally proven.

## License

MIT Licensed
