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
  * `integer(kind=IN16) :: i` implies that $$-2^{15} \le i < 2^{15}$$
  * `integer(kind=IN32) :: i` implies that $$-2^{31} \le i < 2^{31}$$
  * `integer(kind=IN64) :: i` implies that $$-2^{63} \le i < 2^{63}$$

As you see, the largest integer that can be represented in Fortran is $$2^{63} - 1$$.
The largest value for a kind can be computed using the `huge` function, e.g.,
`huge(int(0, kind=INT16)) == 32767`.  Another useful function to determine properties
of an integer kind is `range`, it returns the order of (decimal) magnitude for the
kind.  The following table summarizes the results of `huge` and `range` on each of
the integer kinds.

|         | INT8    | INT16   | INT32      | INT64               |
|---------|---------|---------|------------|---------------------|
| `huge`  | 127     | 32767   | 2147483647 | 9223372036854775807 |
| `range` |   2     |     4   |          9 |                  18 |

Integer arithmetic can be subject to overflow.  Consider the following program.

~~~~fortran
program overflow
    use, intrinsic :: iso_fortran_env, only : INT8
    implicit none
    integer(kind=INT8) :: val
    integer :: i

    val = 125
    do i = 1, 6
        print *, val
        val = val + 1
    end do
end program overflow
~~~~

You might expect that it will print integer values starting at 125 and up to 129.
However, note that the kind is `INT8`, so the maximum value that can be stored in
`val` is 127.  Indeed, the output of the application actually is given below.

~~~~
125
126
127
-128
-127
-126
~~~~


### Real values

The `real` type in Fortran represents mathematical real numbers.  Always bear in mind
that values of this type have a limited precision.  Constants of this type are, e.g.,
`-3.5`, `0.0032`, `1.36e6` ($$1.36 \cdot 10^6$$) , `-1.3e-4` ($$-1.3 \cdot 10^{-4}$$).

The operators defined on real numbers are the same as for integers, except that `/`
is the division, so `1.0/2.0 == 0.5`.

The comparison operators for real values are the same as for integers, but of course,
you have to bear in mind that testing for equality (`==`) and inequality (`/=`) may
not make much sense since values are computed, and hence subject to round-off errors.

For instance, while mathematically, $$(\sqrt{2})^2 = 2$$, this does not hold for
floating point values.

~~~~fortran
program sqrt_2
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
    implicit none

    print *, sqrt(2.0_SP)**2 == 2.0_SP
    print *, sqrt(2.0_DP)**2 == 2.0_DP
end program sqrt_2
~~~~

This will print the following output.

~~~~
F
F
~~~~

When compiling the code above, the compiler will warn that testing equality of two
real values is not a good idea.

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

Although the Fortran standard defines `REAL128`, it is not recommended to use this kind
in general.  Current CPUs have no support for it, hence there is a significant
performance impact when computing with this kind of real values.

Note that it is good practice to explicitly indicate the kind of a real value by
adding a suffix.

~~~~fortran
...
use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
...
real(kind=SP) :: x
real(kind=DP) :: y
...
x = 0.0_sp
y = -1.5e-3_dp
~~~~


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

Somewhat confusingly, you can use a tuple notation to assign a constant to a complex
variable, but for non-constant real and/or imaginary part, you would have to use
the function that creates a complex value out of a real and an imaginary part.
This function is called `cmplx`. as the following code fragment illustrates that
initializes two complex variables `z1` and `z2`.

~~~~fortran
...
use, intrinsic :: iso_fortran_env, only : DP => REAL64
...
complex(kind=DP) :: z1, z2
real(kind=DP) :: re, im
...
z1 = (-0.622772_DP, 0.42193_DP)
z2 = cmplx(re, im)
...
~~~~


### Kind and type conversions

Sometimes you will want to do a type conversion, e.g., converting a real value into
an integer.  Fortran has many intrinsic procedures to accomplish this.  It also has
intrinsic procedures to convert a value to a different kind of the same type.

#### Kind conversions

Every conversion procedure has an optional `kind` argument. 
From an `INT32` to an `INT64`, you would use

~~~~fortran
program type_conversion
    use, intrinsic :: iso_fortran_env, only : I32 => INT32, I64 => INT64
    implicit none
    integer(kind=i32) :: i_i32
    integer(kind=i64) :: i_i64

    i_i64 = 2**40
    i_i32 = int(i_i64, kind=I32)
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
kind into a smaller one: information is lost.  Note that an inadvertent conversion
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
    i_i64 = int(i_i32, kind=I64)
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
The semantics of the unary and binary operators `.and.`, `.or.`, `.eqv.` and `.neqv.`
is summarized in the table below.

### Negation

| p         | `.not.`   |
|-----------|-----------|
| `.TRUE.`  | `.FALSE.` |
| `.FALSE.` | `.TRUE.`  |

### Conjunction

| p         | q         | `.and.`   |
|-----------|-----------|-----------|
| `.TRUE.`  | `.TRUE.`  | `.TRUE.`  |
| `.TRUE.`  | `.FALSE.` | `.FALSE.` |
| `.FALSE.` | `.TRUE.`  | `.FALSE.` |
| `.FALSE.` | `.FALSE.` | `.FALSE.` |


### Disjunction

| p         | q         | `.or.`    |
|-----------|-----------|-----------|
| `.TRUE.`  | `.TRUE.`  | `.TRUE.`  |
| `.TRUE.`  | `.FALSE.` | `.TRUE.`  |
| `.FALSE.` | `.TRUE.`  | `.TRUE.`  |
| `.FALSE.` | `.FALSE.` | `.FALSE.` |

### Equivalence

| p         | q         | `.eqv.`   |
|-----------|-----------|-----------|
| `.TRUE.`  | `.TRUE.`  | `.TRUE.`  |
| `.TRUE.`  | `.FALSE.` | `.FALSE.` |
| `.FALSE.` | `.TRUE.`  | `.FALSE.` |
| `.FALSE.` | `.FALSE.` | `.TRUE.`  |


### Exclusive or

| p         | q         | `.neqv.   |
|-----------|-----------|-----------|
| `.TRUE.`  | `.TRUE.`  | `.FALSE.` |
| `.TRUE.`  | `.FALSE.` | `.TRUE.`  |
| `.FALSE.` | `.TRUE.`  | `.TRUE.`  |
| `.FALSE.` | `.FALSE.` | `.FALSE.` |



## Character values

To represent characters and strings, you can use the `character` type in Fortran.  The
following code snippet declares two variables, the first, `c`, that has a single
character as a value, the other, `str`, can have sequences of 5 characters, i.e.,
strings if you like, as values.

~~~~fortran
character :: c
character(len=5) :: str
~~~~

For convenience, we will use the term "string variable" to mean a variable with type
`character(len=...)`.

A single binary operator `//` is defined on strings, representing concatenation.

The comparison operators can be used to compare strings, but note that they will use
the order defined on characters by the CPU, which (in very rare cases) may not be
ASCII as you would expect.  There are intrinsic functions that guarantee comparison
according to lexicographic order.

  * `llt(x, y)`: less than,
  * `lle(x, y)`: less or equal to,
  * `lgt(x, y)`: greater than,
  * `lge(x, y)`: greater or equal to,
  * `x == y`: equal to,
  * `x /= y`: not equal to.

Literal values for `character` are sequences of characters quoted in either single or
double quotes, e.g., `'hello world'`, `'X'`, `"bananas"`.

An assignment of the string `'hello world'` to the variable `str` would trigger a
compiler warning, and the value of `str` would be `'hello'`.  If you assign a string
such as `'abc'` that is less than 5 characters to the variable `str`, the value of
the latter will be `'abc  '`, i.e., the assigned value is padded with white spaces.
Consequently, the length of `str` will always be 5.

Selecting a substring from a string variable is straightforward, e.g., `str(2:4)`
would select the second through the fourth character, i.e., `'bc '`.  Somewhat
counter-intuitively, individual characters also have to be selected as a range, e.g.,
`str(2:2)` would be the second character, i.e., `'b'`.

The intrinsic function `len` returns the length of a string, but including the padding
white space.  Since this is typically not of interest, the intrinsic function
`len_trim` is defined which doesn't take into account trailing white space, so
`len_trim(str)` would return 3.  The `trim` intrinsic function will return its
argument's value, but with trailing white space removed.  This function is convenient
for printing string values.

Below is a program that reads from standard input, and verifies for each line whether
that is a palindrome, i.e., a string that is the same when read from left to right, and
from right to left.

~~~~fortran
program palindromes
    use, intrinsic :: iso_fortran_env, only  : input_unit, iostat_end
    implicit none
    character(len=1024) :: buffer, msg
    integer :: istat

    do
        read(unit=input_unit, fmt=*, iostat=istat, iomsg=msg) buffer
        if (istat == iostat_end) exit
        print '(L1)', is_palindrome(buffer)
    end do

contains

    function is_palindrome(phrase) result(palindrome)
        implicit none
        character(len=*), intent(in) :: phrase
        logical :: palindrome
        integer :: i, n

        n = len_trim(phrase)
        palindrome = .true.
        do i = 1, n/2
            if (phrase(i:i) /= phrase(n-i+1:n-i+1)) then
                palindrome = .false.
                exit
            end if
        end do
    end function is_palindrome

end program palindromes
~~~~

Since the function `is_palindrome` should work for a string of any length, the
function's argument is declared as a deferred length `character(len=*)`.

Fortran has many intrinsic procedures to query and manipulate strings such as
`index` to find the position of a substring in a string, `adjustl` and `adjustr`
which will left or right align string respectively.  For example, the result of
`adjustr(str)` would be the string `'  abc'`.

### Type conversions

For some applications it can be necessary to convert a character to its numerical
representation, or vice versa.

The intrinsic function `iachar` returns the ASCII value of the character, e.g.,
`iachar('a')` will return 97.  The function `achar` does the reverse, given an
ASCII value, it will return the corresponding character, e.g., `achar(65)` will
return `'A'`.

