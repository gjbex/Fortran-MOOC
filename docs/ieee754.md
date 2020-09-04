# IEEE 754 standard for Floating-Point Arithmetic

[This standard](https://en.wikipedia.org/wiki/IEEE_754) was established by the
Institute of Electrical and Electronics Engineers (IEEE) in 1985 to address
various issues encountered when performing floating point arithmetic.

The standard defines:

* arithmetic formats: sets of binary and decimal floating-point data,
  which consist of finite numbers (including signed zeros and subnormal
  numbers), infinities, and special "Not a Number" values (NaNs);
* interchange formats: encodings (bit strings) that may be used to exchange
  floating-point data in an efficient and compact form;
* rounding rules: properties to be satisfied when rounding numbers during
  arithmetic and conversions;
* operations: arithmetic and other operations (such as trigonometric
  functions) on arithmetic formats;
* exception handling: indications of exceptional conditions (such as
  division by zero, overflow, etc.).

Clearly a standard such as this is crucial for interoperability and
compatibility between systems and programming languages.  The standard has
been widely adopted.

Fortran supports the IEEE 754 standard via three intrinsic modules:

* `ieee_exceptions`;
* `ieee_arithmetic`;
* `ieee_features`.

Note that this was a "late" addition, these modules were introduced only in
the Fortran 2003 specification, and it has taken more than a decade before
compilers added reliable support for them.

Recently John Gustafson proposed
[Unum](https://en.wikipedia.org/wiki/Unum_(number_format)), an alternative
to IEEE 754 that has many interesting properties and generated considerable
attention from vendors in the scientific computing market, but thus far no
implementations have emerged.


## 0.0 versus -0.0

IEEE 754 specifies two ways to represent zero, positive and negative.  The
Fortran specification states that `0.0 == -0.0`.  This is illustrated by
the program below.

~~~~fortran
program ieee754
    implicit none
    real :: zero, minus_zero = 0

    minus_zero = sign(zero, -1.0)
    print '(A, 2F7.2)', '0 vs. -0: ', zero, minus_zero
    if (zero == minus_zero) then
        print '(A)', '0 == -0'
    else
        print '(A)', '0 / -0'
    end if
    print '(A, F5.1)', 'sqrt(0.0) = ', sqrt(zero)
    print '(A, F5.1)', 'sqrt(-0.0) = ', sqrt(minus_zero)
end program ieee754
~~~~

So although positive and negative zero have two distinct bit representations,
the values are arithmetically the same, although they have distinct string
representations for formatted output.


## Infinity

Some operations such as raising a number to a large power, or dividing it
by a very small number will yield `Infinity` or `-Infinity`.  These are
valid IEEE 754 values and can be computed with.

Needless to say that you are likely to be disappointed with the result
of your computation since any operation on an infinite value will result
in an infinite value or a NaN.  However, it is easy to check whether a value
is finite or not.

The intrinsic module `ieee_arithmetic` has a function `ieee_is_finite` that
will return `.true.` when its argument is finite, `.false.` otherwise.

In the same intrinsic module you will find a function `ieee_value` that can be
used to create a positive or negative IEEE representation for infinity.  The
constants `ieee_positive_inf` and `ieee_negative_inf` will determine the value.

~~~~fortran
...
use, intrinsic :: ieee_arithmetic, only : ieee_value, ieee_positive_inf
use, intrinsic :: iso_fortran_env, only : DP => REAL32
real(kind=DP) :: infinity
...
infinity = ieee_value(0.0_DP, ieee_positive_inf)
...
~~~~

The first argument of the function `ieee_value` is a real value that is used
to determine the kind of the result.  The second argument is the IEEE class.


## Not a Number (NaN)

Some arithmetic operations are not well-defined, e.g., division of 0 by 0,
or the square root of a negative number.  The IEEE 754 representation of
the "result" of such a computation is NaN (Not a Number).  Further computations
with NaN will result in further NaN values.

Interestingly, NaN is the only IEEE 754 number that is not equal to
itself.

As with infinite values, you may want to check.  This can be done using the
`ieee_is_nan` function defined in the intrinsic module `ieee_arithmetic`.  It
returns `.true.` if the argument is NaN, `.false.` otherwise.

A NaN value can be constructed explicitly using `ieee_value` for the class
`ieee_quiet_nan`.
