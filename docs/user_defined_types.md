# User defined types

Representing data is key to software design.  You've already encountered Fortran basic
types to represent numbers, logical values and strings, as well as (multi-dimensional)
arrays of such data.

However, some data items that belong together do not fit into an array since they have
different types.  For instance, consider configuration settings for an imaginary
application that can be configured using the name of an integration method, represented
as a string, a precision represented as a real value and a number of iterations,
represented as an integer.

It would of course be possible to define three independent variables to store these
values, but it makes more sense to aggregate this data into a special purpose data
structure.  For this purpose, Fortran offers user defined types.  These are very
similar to `struct` is C/C++ or named tuples in Python.


## Type definition

The definition of a new type `config_t` is given below.

~~~~fortran
    type :: config_t
        character(len=1024) :: method
        integer :: nr_iters
        real(kind=DP) :: precision
    end type config_t
~~~~

The type `config_t` has three element, named `method`, `nr_iters` and `precision`.
Note that the elements have distinct types, e.g., `nr_iters` is an integer, while
`method` is a string.

It is good practice to append the `_t` suffix to make it very clear that this is the
name of a type.


## Variable declaration and use

`config_t` is a type, so if you can declare variables that have this type, e.g.,

~~~~fortran
type(config_t) :: config
~~~~

The variable `config` has type `config_t`.  You can assign values to the various
arguments as shown below.  The string `'none'` is assigned to the `method` element,
the integer 0 to the `nr_iters` element, and so on.

~~~~fortran
config%method = 'none'
config%nr_iters = 0
config%precision = 1.0e-10_DP
~~~~

Elements of user defined type variables can be used like any other variable in
expressions, or as arguments in procedure calls, e.g.,

~~~~
if (abs(value) < config%precision) then
    ...
end if
~~~~


## Procedure arguments

User defined type variables can be passed to procedures, for instance, the following
subroutine takes a variable of type `config_t` as an argument.

~~~~fortran
subroutine print_config(config)
    implicit none
    type(config_t), intent(in) :: config

    print "('method = ', A)", trim(config%method)
    print "('nr_iters = ', I0)", config%nr_iters
    print "('precision = ', E26.15)", config%precision
end subroutine print_config
~~~~
