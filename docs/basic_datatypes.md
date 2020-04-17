# Basic data types

Just as most programming languages, Fortran has a number of basic data types.


## Numerical types

As Fortran is a language primarily designed for scientific computing, it has a number
of numerical types representing integers, real and complex numbers.  All these types
come in various kinds, i.e., roughly the number of bits used to represent their values.


### Integer values

Fortran's `integer` is the integral data type to represent mathematical integers.
Integer constants are values such as `23`, `0`, `-39` and so on.

Besides the unary `-` operator that changes the sign of an integer, the following
binary operators are defined on integers:

  * `+`: addition
  * `-`: subtraction
  * `*`: multiplication
  * `/`: integer division, e.g., `3/2 == 1`
  * '**`: exponentiation

Integers can be compared using the following binary operators.

  * `==`: equal,
  * `/=`: not equal,
  * `<`: less than,
  * `<=`: less than or equal,
  * `>`: larger than,
  * `>=`: larger than or equal.

Furthermore, the Fortran specification defines quite a number of intrinsic procedures
that  operate on integers such as `abs` (absolute value) and `mod` (modulo).

The intrinsic `iso_fortran_env` module defines four integer kinds:

  * `INT8`: 1 byte representation,
  * `INT16`: 2 byte representation,
  * `INT32`: 4 byte representation,
  * `INT64`: 8 byte representation.

So, 8, 16, 32 and 64 are the number of bits to represent an integer value.

  * `integer(kind=IN8)  :: i` implies that $$-2^7  \le i < 2^7$$
  * `integer(kind=IN16) :: i` implies that $$-2^15 \le i < 2^15$$
  * `integer(kind=IN32) :: i` implies that $$-2^31 \le i < 2^31$$
  * `integer(kind=IN64) :: i` implies that $$-2^63 \le i < 2^63$$

As you see, the largest integer that can be represented in Fortran is $$2^63 - 1$$.
The largest value for a kind can be computed using the `huge` function, e.g.,
`huge(int(0, kind=INT16)) == 32767`.  Another useful function to determine properties
of an integer kind is `range`, it returns the order of (decimal) magnitude for the kind.
The following table summarizes the results of `huge` and `range` on each of the
integer kinds.

|         | INT8    | INT16   | INT32      | INT64               |
|---------|---------|---------|------------|---------------------|
| `huge`  | 127     | 32767   | 2147483647 | 9223372036854775807 |
| `range` |   2     |     4   |          9 |                  18 |

### Real values

The `real` type in Fortran represents mathematical real numbers.  Always bear in mind
that values of this type have a limited precision.  Constants of this type are, e.g.,
`-3.5`, `0.0032`, `13.6e6` ($$1.36 \cdot 10^6$$) , `-1.3e-4` ($$-1.3 \cdot 10^{-4}$$).

The operators defined on real numbers are the same as for integers, except that `/`
is the division, so `1.0/2.0 == 0.5`.

The comparison operators for real values are the same as for integers, but of course,
you have to bear in mind that testing for equality (`==`) and inequality (`/=`) may
not make much sense since values are computed, and hence subject to round-off errors.

For instance, while mathematically, $$\sqrt{2}^2 = 2$$, this does not hold for
floating point values.

~~~~fortran
program sqrt_2
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
    implicit none

    print *, sqrt(2.0_SP) == 2.0_SP
    print *, sqrt(2.0_DP) == 2.0_DP
end program sqrt_2
~~~~

This will print the following output.

~~~~
F
F
~~~~

The list of intrinsic procedures defined on real numbers is quite impressive and
includes the usual suspects such as `sqrt` (square root), `exp` (exponential
function), the trigonometric functions and their inverses, but also `erf` and
`erfc` (error function and complementary error function) and even Bessel functions.

The `iso_fortran_env` module defines three kinds for real numbers:

  * `REAL32`: 4 byte representation, single precision,
  * `REAL64`: 8 byte representation, double precision,
  * `REAL128`: 16 byte representation, quad precision.

As for integers, the function `huge` can be used to determine the largest number that
can be represented by a real kind.

|             | REAL32         | REAL64                  | REAL128                                     |
|-------------|----------------|-------------------------|---------------------------------------------|
| `tiny`      | 1.17549435E-38 | 2.2250738585072014E-308 | 3.36210314311209350626267781732175260E-4932 |
| `epsilon`   | 1.19209290E-07 | 2.2204460492503131E-016 | 1.92592994438723585305597794258492732E-0034 |
| `huge`      | 3.40282347E+38 | 1.7976931348623157E+308 | 1.18973149535723176508575932662800702E+4932 |
| `precision` | 6              | 15                      | 33                                          |

For each kind, `tiny` returns the smallest number that is larger than zero. `epsilon`
returns the smallest number $$\epsilon$$ such that $$1 < 1 + \epsilon$$.  The
precision is the number of significant digits for a value of that kind.


### Complex values

You won't be surprised that Fortran has first-class support for complex numbers since
the language has been designed for scientific computing.  The name of the type is
`complex`, and it has the same kinds as `real`, so `REAL32`, `REAL64` and `REAL128`.
For instance, `complex(kind=REAL64)` means that the real and imaginary part of the
complex variable will be stored as double precision values.

The operators that are defined for real numbers also work as expected for complex
numbers, as do many of the intrinsic procedures.  There are a number of procedures
that are specific to complex numbers such as `real` and `aimag` that return the
real and imaginary part of a complex number respectively, but also `conjg` that
computes the conjugate of a complex number.

Somewhat confusingly, the function that creates a complex value out of a real and an
imaginary part is called `cmplx`, as the following code fragment illustrates that
initializing a complex constant.

~~~~fortran
complex(kind=REAL64), parameter :: C = cmplx(-0.622772_REAL64, &
                                              0.42193_REAL64, kind=REAL64)
~~~~


### Kind and type conversions

Sometimes you will want to do a type conversion, e.g., converting a real value into
an integer.  Fortran has many intrinsic procedures to accomplish this.  It also has
intrinsic procedures to convert a value to a different kind of the same type.

#### Kind conversions

Every conversion procedure has an optional `kind` argument. 
from an `INT32` to an `INT64`, you would use

~~~~fortran
program type_conversion
    use, intrinsic :: iso_fortran_env, only : I32 => INT32, I64 => INT64
    implicit none
    integer(kind=i32) :: i_i32
    integer(kind=i64) :: i_i64

    i_i64 = 2**40
    i_i32 = int(i_i64, kind=I64)
    print *, i_i32
end program type_conversion
~~~~

The `int` function is called with a `kind` argument specifying the result type, an
`INT32` in this case.  Note that the value of the variable `i_i64` can not be stored
in a variable of `i_i32`, so the compiler will issue a warning about this.  When
you run the program and check the output, you will see the following, which may not
be what you expect.

~~~~
 -2147483648
~~~~

The conversion resulted in an overflow.  This is the result of converting a larger
kind into a smaller one: information is lost.  Note that a inadvertent conversion
such as this may give rise to very nasty bugs (hence the compiler warning).

On the other hand, converting from a smaller kind to a larger one works perfectly
well.

~~~~fortran
program type_conversion
    use, intrinsic :: iso_fortran_env, only : I32 => INT32, I64 => INT64
    implicit none
    integer(kind=i32) :: i_i32
    integer(kind=i64) :: i_i64

    i_i32 = 2**10
    i_i64 = int(i_i32, kind=I32)
    print *, i_i64
end program type_conversion
~~~~

This application would print what you would expect.

~~~~
1024
~~~~

The `real` and `cmplx` functions do the same for `real` and `complex` values
respectively.  Converting from a smaller kind to a larger is no problem, converting
from a larger to a smaller again gives problems, although thanks to the IEEE 754
standard (although there are caveats), bugs are easier to spot.

~~~~fortran
program type_conversion
    use, intrinsic :: iso_fortran_env, only : &
        SP => REAL32, DP => REAL64
    implicit none
    real(kind=SP) :: x_sp
    real(kind=DP) :: x_dp

    x_dp = 1.0e100_DP
    x_sp = real(x_dp, kind=SP)
    print *, x_sp
end program type_conversion
~~~~

The overflow of the value for the variable `x_sp` results in `infinity`.

~~~~
Infinity
~~~~

#### Type conversions

To truncate a real value to an integer, you can use `aint`, while to convert it
to the nearest integer, you can use `anint`.

To explicitly convert an integer to a real value, the function `real` can be used.
That same function will also return the real part of a complex argument as you
saw earlier.  Similarly, `aimag` will return the imaginary part of a complex value
as a real value.

The function `cmplx` will convert two numbers to a complex value.


## Logical

The type logical represents Boolean values.  It has only two constant values,
`.TRUE.` and `.FALSE.`.  The unary `.not.` operator represents the Boolean negation.
The semantics of the unary and binary operators `.and.`, `.or.`, .eqv.` and `.neqv.`
is summarized in the table below.

| p         | q         | `.not.`   | `.and.`   | `.or.`    | `.eqv.`   | `.neqv.`  |
|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| `.TRUE.`  | `.TRUE.`  | `.FALSE.` | `.TRUE.`  | `.TRUE.`  | `.TRUE.`  | `.FALSE.` |
| `.TRUE.`  | `.FALSE.` | `.FALSE.` | `.FALSE.` | `.TRUE.`  | `.FALSE.` | `.TRUE.`  |
| `.FALSE.` | `.TRUE.`  | `.TRUE.`  | `.FALSE.` | `.TRUE.`  | `.FALSE.` | `.TRUE.`  |
| `.FALSE.` | `.FALSE.` | `.TRUE.`  | `.FALSE.` | `.FALSE.` | `.TRUE.`  | `.FALSE.` |


## Character values
