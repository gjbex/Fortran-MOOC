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

|         | int8    | int16   | int32      | int64               |
|---------|---------|---------|------------|---------------------|
| `huge`  | 127     | 32767   | 2147483647 | 9223372036854775807 |
| `range` |   2     |     4   |          9 |                  18 |

### Real values

The `real` type in Fortran represents mathematical real numbers.  Always bear in mind
that values of this type have a limited precision.  Constants of this type are, e.g.,
`-3.5`, `0.0032`, `13.6e6` ($$1.36 \cdot 10^6$$) , `-1.3e-4` ($$-1.3 \cdot 10^{-4}$$).

The operators defined on real numbers are the same as for integers, except that `/` is
the division, so `1.0/2.0 == 0.5`.

The list of intrinsic procedures defined on real numbers is quite impressive and
includes the usual suspects such as `sqrt` (square root), `exp` (exponential
function), the trigonometric functions and their inverses, but also `erf` and
`erfc` (error function and complementary error function).

The `iso_fortran_env` module defines three kinds for real numbers:

  * `REAL32`: 4 byte representation, single precision,
  * `REAL64`: 8 byte representation, double precision,
  * `REAL128`: 16 byte representation, quad precision.

As for integers, the function `huge` can be used to determine the largest number that
can be represented by a real kind.

|             | real32         | real64                  | real128                                     |
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
For instance, `complex(kind=real64)` means that the real and imaginary part of the
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


### Type conversions


## Logical

## Character values
