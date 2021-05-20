# Functions and subroutines

Fortran has two types of procedures: functions and
subroutines.  The functionality of the two is essentially
the same, so it depends on the usage which is most
convenient.

Both are "subprograms" in the sense that they perform
a computation based on their input, the arguments to
the procedure.  For functions, the result of that
computation is returned, and can be used in an expression.
Subroutines on the other hand usually modify the arguments
that are passed to them.

Procedures help you to avoid copy/pasting code (Don't Repeat
Yourself), but also to structure your code into subprograms.


## Functions

You will use a function when you want the result
of the computation it does in an expression.  Since Fortran
has many built-in functions, referred to as intrinsic
functions, we will use one to illustrate the typical use
of a function.

~~~~fortran
...
real :: x, y, hypot
...
hypot = sqrt(x**2 + y**2)
...
~~~~

The function `sqrt` is an intrinsic function that takes a
real or complex number as an argument and returns a real or
complex value, the square root of its argument.

Note: as opposed to C, C++, Java and Python, mathematical
function are intrinsic to the language, no header files
or modules need to be included.  This is of course due to
Fortran's primary focus: scientific computing.

As in any programming language, you can define your own
functions.  The general form is given below.

~~~~
function <function name>(<argument list>) result(<result name>)
    implicit none
    <argument declarations>
    <result declaration>
    <local variable declarations>

    <function statements>
end function <function name>
~~~~

If this is somewhat abstract, let's make it concrete with
the definition of a function that computes the distance
between two points given by their x and y coordinates.

~~~~fortran
function distance(x1, y1, x2, y2) result(d)
    implicit none
    real(kind=DP), intent(in) :: x1, y1, x2, y2
    real(kind=DP) :: d

    d = sqrt((x1 - x2)**2 + (y1 - y2)**2)
end function distance
~~~~

Here, `distance` is the name of the function, `x1`, `y1`,
`x2`, `y2` are the names of the function arguments and `d` is
the name of the variable that will hold the result.

The declaration of the arguments states that they are `real`
numbers with kind `DP`.  Also the intent of the arguments
is declared.  This can be

  * `in`: the argument's value in the caller will be used,
          but not modified.
  * `out`: the argument's value in the caller will be
           replaced by the function.
  * `inout`: the argument's value in the caller will be used,
             but also updated.

In this case, we need the values of the arguments passed to
the function to compute the distance, hence, the intent is
`in` for all arguments.

The result variable `d` is also declared as a `real`
variable of kind `DP`.

Note an important difference with many other programming
languages such as C, C++ or Java: you don't see a
return statement in the function.  The semantics of function
return values in Fortran differs from that in those
languages.  In those programming languages, the value
returned by the function is the value of the expression in
the return statement.  The return statement also transfers
control back to the caller of the function.

~~~~c
#include <math.h>
double distance(double x1, double y1, double x2, double y2) {
    return sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2));
}
~~~~

Although Fortran has a return statement, you could say that
it only does half the work that it does in many other
programming languages.  It only returns control back to the
caller, i.e., it terminates execution of the function.  In
Fortran, the return value of a function is determined by the
execution of the last assignment to the result variable, so
to `d` in our example.

That implies that an assignment to the result variable has
to be made in each execution path through the function.  The
function `factorial` below for instance has issues.

~~~~fortran
function factorial(n) result(fac)
    implicit none
    integer, intent(in) :: n
    integer :: fac
    integer :: i
    
    if (n >= 0) then
        fac = 1
        do i = 2, n
            fac = fac*i
        end do
    end if
end function factorial
~~~~

if the argument `n` is negative, no assignment is made to
the result variable `fac` which results in undefined
behavior.

You can define a function in a slightly different way as
well, although it is a bit less robust.

~~~~
<result type> function <function name>(<argument list>)
    implicit none
    <argument declarations>
    <local variable declarations>

    <function statements>
end function <function name>
~~~~

In this form, you declare the return type of the function
in the function's signature, and the return value will be
assigned to the function name.  The function to compute
the distance could also be defined as follows.

~~~~fortran
real(kind=DP) function distance(x1, y1, x2, y2)
    implicit none
    real(kind=DP), intent(in) :: x1, y1, x2, y2

    distance = sqrt((x1 - x2)**2 + (y1 - y2)**2)
end function distance
~~~~

Although functionally equivalent, this style of function
declaration is less robust to change.  If you decide to
rename the function, you would have to modify all assignment
statements as well, which can be error-prone for complex
functions.


## Subroutines

The second type of procedures in Fortran are subroutines.
You could view them as functions that don't return a value.
The definition of subroutines is very similar to that of
functions, except for the result value, which subroutines
don't have by definition.

Fortran has a number of intrinsic subroutines as well, for
example to generate pseudo-random numbers.

~~~~fortran
...
real :: x
...
call random_number(x)
...
~~~~

In the code fragment above, the variable `x` will be
assigned a pseudo-random number drawn from a uniform
distribution between 0 and 1.

Note the use of the keyword `call` required to call a
subroutine!

The general form of a subroutine definition is given below.

~~~~
subroutine <subroutine name>(<argument list>)
    implicit none
    <argument declarations>
    <local variable declarations>

    <subroutine statements>
end subroutines <subroutines name>
~~~~

You can see an example of a subroutine definition below.

~~~~fortran
subroutine clamp(val, min_val, max_val)
    implicit none
    real(kind=DP), intent(inout) :: val
    real(kind=DP), intent(in) :: min_val, max_val

    if (val < min_val) then
        val = min_val
    else if (max_val < val) then
        val = max_val
    end if
end subroutine clamp
~~~~

The subroutines takes three arguments, the first is `val`,
the value of interest.  If it is less than the second
argument, `min_val` then it is set to the value of `min_val`.
If it is greater than the second argument, `max_val` it is
set to the value of `max_val`.  Otherwise, it is left
unchanged.

This is also an illustration of the intent `inout`.  The
argument `val`'s value is required in the if statements,
but can be modified by the subroutine as well.

The subroutines `clamp` could be used as in the code
fragment below.

~~~~fortran
...
real(kind=DP) :: x
...
call clamp(x, 0.0, 1.0)
...
~~~~


## Call-by-value or call-by-reference?

A programming language such as C has call-by-value semantics.  If a variable is passed
as an argument to a function, its value is passed and assigned to the function's local
variable.  Changing that local variable doesn't change the value of the variable in the
caller's context.

If you would do the same in Fortran, the value of the variable in the caller's context
will be changed, Fortran has call-by-referred semantics.  The following program
illustrates this.

~~~~fortran
program call_by_reference
    implicit none
    integer :: m
    m = 5
    print *, m
    call increment(m)
    print *, m

contains

    subroutine increment(n)
        implicit none
        integer, intent(inout) :: n

        n = n + 1
    end subroutine increment

end program call_by_reference
~~~~

When you run this application, the output will be

~~~~
           5
           6
~~~~

The variable `m` was passed to the subroutine `increment` and modified in it.  The
intent of the argument is `inout`, the original value is used to compute the new
value, which changes the value of `m` in the calling context.

If you world try to call `increment` with an integer constant as an argument, i.e.,
`call increment(16)` you would get a compilation error as 

~~~~
    8 |     call increment(16)
      |                   1
Error: Non-variable expression in variable definition context (actual argument to INTENT = OUT/INOUT) at (1)
~~~~

Indeed, it doesn't make sense to call a subroutine that has an `inout` argument with
a constant.

However, clearly, there situation in which you would prefer call-by-value semantics.
Consider the following implementation of the factorial function.

~~~~fortran
function factorial(arg) result(fac)
    implicit none
    integer, intent(in) :: arg
    integer :: fac, n

    n = arg
    fac = 1
    do while (n > 1)
        fac = fac*n
        n = n - 1
    end do
end function factorial
~~~~

The code above is a little clunky.  On the one hand, we should ensure that the
argument `arg` is not modified, so it has intent `in`, but on the other hand, it
implies we have to introduce a local variable `n` that is initialized with the value
of `arg`, but can be modified.

We can get the best of both worlds by using call-by-value semantics, i.e., declaring
that the argument is passed by value, as in the code below.

~~~~fortran
    function factorial(n) result(fac)
        implicit none
        integer, value :: n
        integer :: fac

        fac = 1
        do while (n > 1)
            fac = fac*n
            n = n - 1
        end do
    end function factorial
~~~~

Although the argument `n` is modified in the function, it is not modified in the
calling context.


## Recursion procedures

In most programming languages, functions can be recursively defined, i.e., they
have a call to themselves in their definition.  Fortran allows recursive procedures,
but they have to be declared as such.  For instance, revisiting the example in the
precious section we can define that recursively as well.

~~~~fortran
recursive function factorial(n) result(fac)
    implicit none
    integer, intent(in) :: n
    integer :: fac

    if (n >= 2) then
        fac = n*factorial(n - 1)
    else
        fac = 1
    end if
end function factorial
~~~~

Please note that although it may be more convenient to formulate a recursive
algorithm, this will typically use more system resources and have worse efficiency
than its iterative counterpart.  In fact, any recursive algorithm can be converted
into an iterative algorithm, see for instance this
[blog post](https://blog.moertel.com/posts/2013-05-11-recursive-to-iterative.html).


## Keyword arguments

Fortran support keyword arguments, which can be very convenient when you have
procedures with multiple arguments.  Consider the example of the `clamp` subroutine
we defined above.  Do you remember the signature?  Perhaps you don't, if so, keyword
arguments can help, and make your code easier to understand.  You can call the
subroutine as follows.

~~~~fortran
...
real :: x
...
call clamp(min_val=0.0, max_val=1.0, val=x)
...
~~~~

Keyword arguments are labeled by the name of the procedure's argument, but they do
not have to appear in the same order as in the procedure's signature.  Just to remind
you, the subroutine was defined as:

~~~~fortran
subroutine clamp(val, min_val, max_val)
   ...
end subroutine clamp
~~~~

It is strongly recommended to use keyword arguments to make your code easier to
understand.


## Optional arguments

Arguments to procedures can be optional. Some extra code is required because the
procedure must check whether or not a value has been provided in the procedure call.

For example, let's revisit the `clamp` procedure and make `min_val` optional.

~~~~fortran
subroutine clamp(val, min_val, max_val)
    implicit none
    real(kind=DP), intent(inout) :: val
    real(kind=DP), value, optional :: min_val
    real(kind=DP), value :: max_val

    if (.not. present(min_val)) min_val = -max_val
    if (val < min_val) then
        val = min_val
    else if (max_val < val) then
        val = max_val
    end if
end subroutine clamp
~~~~

The subroutine can be called either with two, or three arguments.

~~~~fortran
...
real(kind=DP) :: value
...
call clamp(val=value, max_val=5.0_DP)
...
~~~~

~~~~fortran
...
real(kind=DP) :: value
...
call clamp(val=value, min_val=0.0_DP, max_val=5.0_DP)
...
~~~~


## Persistent values

In some cases, it can be useful to make values of local variables in procedures
persistent, so that they can be used in future calls.  In C and C++, you would do
this by adding the keyword `static` to the local variable declaration.  In Fortran
you can use `save`.

The following example uses a uniform random number distribution to generate numbers
from a normal distribution.  The algorithm actually generates two random values, so
the second one is stored for the next call in the `save` variable `next_val.  The
variable `is_next_val` will be true when a value is available, false when two new
values need to be computed.

~~~~fortran
function get_exp_rand() result(val)
    implicit none
    real :: val
    real, save :: next_val
    logical, save :: is_next_set = .false.
    real :: x, y, radius, factor

    if (is_next_set) then
        is_next_set = .false.
        val = next_val
    else
        do while (.not. is_next_set)
            call random_number(x) 
            call random_number(y) 
            x = 2.0*x - 1.0
            y = 2.0*y - 1.0
            radius = x**2 + y**2
            if (0.0 < radius .and. radius <= 1.0) exit
        end do
        factor = sqrt(-2.0*log(radius)/radius)
        val = x*factor
        next_val =y*factor
        is_next_set = .true.
    end if
end function get_exp_rand
~~~~


## Pure procedures

You can help the compiler to generate more efficient code by writing pure procedures
and marking them as such.  A pure procedure is a function or a subroutine that has
no side effects.

More specifically, all non-pointer argument must be of intent `in. For subroutines,
all arguments must have their intent specified.

For procedures in general:

  * no local variables can have the `save` attribute;
  * I/O and stop statement are not allowed;
  * it can not be recursive;
  * an internal procedure or a procedure that is passed as an argument must be pure.


The following function can be declared pure.

~~~~fortran
pure function factorial(n) result(fac)
    implicit none
    integer, intent(in) :: n
    integer :: fac, i

    fac = 1
    do i = 2, n
        fac = fac*n
    end do
end function factorial
~~~~

A subroutine can also be marked as pure, e.g.,

~~~~fortran
pure subroutine clamp(val, min_val, max_val)
    implicit none
    real(kind=DP), intent(inout) :: val
    real(kind=DP), intent(in) :: min_val, max_val

    if (val < min_val) then
        val = min_val
    else if (max_val < val) then
        val = max_val
    end if
end subroutine clamp
~~~~


## Intrinsic procedures

The Fortran specification defines a large number of procedures, both functions
and subroutines as part of the language.  You already encountered the `sqrt`
function and the `random_number` subroutine.

Many mathematical functions are implemented as intrinsic functions, e.g.,

1. the absolute value `abs` the complex conjugate `conjg`, the square root
   function `sqrt` and the modulo function `mod`;
1. the trigonometric functions `sin`, `cos`, `tan` and their inverse `asin`,
   `acos` and `atan`;
1. the hyper-trigonometric functions `sinh`, `cosh`, `tanh` and their inverse
   `asinh`, `acosh` and `atanh`;
1. the natural and base-10 logarithm `log` and `log10` as well as the
   exponential function `exp`;
1. Bessel functions of the first and second kind `bessel_j0`, `bessel_j1`,
   `bessel_jn`, `bessel_y0`, `bessel_y1`, `bessel_yn`;
1. the gamma function `gamma`, the error function `erf` and the complementary
   error function `erfc`.

All these functions are elemental functions, so they can be applied element-wise
to arrays as well.

Several mathematical functions defined on vectors or matrices are also part of
the specification, e.g.,

1. the minimum and maximum value in an array: `min` and `max`;
1. the sum and product of array elements: `sum` and `product`;
1. counting the number of elements in an array that satisfy some Boolean
   condition: `count`;
1. the Euclidean norm of an array `norm2`;
1. the transpose of a two-dimensional array `transpose`;
1. the dot product between two arrays `dot_product` and the product between
   two-dimensional arrays `matmul`.

Functions such as `min`, `max` and similar take optional arguments to restrict
the operation to certain dimensions so that you can compute a row or a
column-wise sum.  They also accept a mask so that operations can be restricted
to elements that satisfy some Boolean condition.

Although it is very unlikely that anyone would argue that Fortran is the ideal
programming language for string manipulations, some intrinsic procedures ease
the pain, e.g.,

1. the `trim` function will remove trailing blank characters from a string;
1. the `index` function returns the position of a substring in a string,
   while `scan` returns the position of a set of characters in a string;
1. the function `verify` will return `.true.` when all characters in a string
   belong to a given set of characters;
1. the `repeat` function creates a string by repeating a given string a
   number of times.

Obviously this is not an exhaustive list of all the intrinsic procedures
defined in the Fortran specification, so it really pays off to check what is
available to avoid reinventing the wheel.

You can find a list of intrinsic procedures 
[implemented by GCC](https://gcc.gnu.org/onlinedocs/gfortran/Intrinsic-Procedures.html#Intrinsic-Procedures).
Note that not all these procedures are standard Fortran, some are GNU
extensions.  This is clearly indicated though.
