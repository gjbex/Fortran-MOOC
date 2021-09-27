# Interfaces

Interface blocks serve a number of purposes in Fortran.  In general, they
provide the compiler with information about procedures.  Interface blocks
contain the signature of procedures, i.e., their name and the type of
arguments, and the return type for functions.


## procedures as arguments of procedures

It can sometimes be quite useful to pass a procedure as an argument to
a procedure.  For instance, consider computing the quadrature of a function.
The functions you can use map a real number to a real number, the signature
is specified in the interface block below.

~~~~fortran
module quad_func_interface_mod

    interface
        function quad_func_t(x) result(f)
            use, intrinsic :: iso_fortran_env, only : DP => REAL64
            implicit none
            real(kind=DP), value :: x
            real(kind=DP) :: f
        end function quad_func_t
    end interface

end module quad_func_interface_mod
~~~~

This function has a single real-valued argument, and returns a real value,
both of kind double precision.  The interface is declared in a module for
convenience, since it may be required in multiple compilation units.

The `quad` function will take a function `f` with the signature of
`quad_func_t` as an argument, as well as the boundaries of the integration
interval `a` and `b`.

~~~~fortran
function quad(f, a, b) result(q_f)
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    use :: quad_func_interface_mod
    implicit none
    procedure(quad_func_t) :: f
    real(kind=DP), intent(in) :: a, b
    real(kind=DP) :: q_f
    q_f = 0.5_DP*(f(b) + f(a))*(b - a)
end function quad
~~~~ 

Obviously, this isn't even remotely a reasonable implementation of a
quadrature method such as Simpson's or Gauss methods, it only serves to
provide a simple example of a function that takes a function as an argument.

The function argument `f` is declared using `procedure` and the name of the
interface `quad_func_t`.  `f` can be used as any function.

The function `quad` can now be used to compute the quadrature of an
arbitrary function that has the signature defined in the interface for
`quad_func_t`.

~~~~fortran
program quad_test
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    use :: quad_func_interface_mod
    use :: quad_mod, only : quad
    implicit none
    real(kind=DP), parameter :: a = -1.0_DP, b = 1.0_DP

    print *, quad(func, a, b)

contains

    function func(x) result(f)
        implicit none
        real(kind=DP), value :: x
        real(kind=DP) :: f
        f = exp(x)
    end function func

end program quad_test
~~~~

The function `func` takes a single real-valued argument and returns a real
value.


## Generic programming

A second application of interfaces is generic programming, or overloading.
Consider a subroutine that takes two variables as arguments, and swaps the
values.  Unfortunately, we have to define an implementation for the case when
the arguments are real, a second one for integer arguments, and so on.

These implementations would be called, e.g., `real_swap` and `int_swap`
respectively.  However, it would be much more convenient if you could simply
use `swap`, and have the compiler figure out whether to use `real_swap` or
`int_swap` based on the types of the arguments the subroutine `swap` is called
with.  The following module uses an interface block to achieve exactly that.

~~~~fortran
module swap_mod
    implicit none

    private
    public :: swap

    interface swap
        module procedure real_swap
        module procedure int_swap
    end interface swap

contains

    subroutine real_swap(a, b)
        implicit none
        real, intent(inout) :: a, b
        real :: tmp

        tmp = a
        a = b
        b = tmp
    end subroutine real_swap

    subroutine int_swap(a, b)
        implicit none
        integer, intent(inout) :: a, b
        integer :: tmp

        tmp = a
        a = b
        b = tmp
    end subroutine int_swap

end module swap_mod
~~~~

The following code illustrates how this can be used.

~~~~fortran
program swap_test
    use :: swap_mod, only : swap
    implicit none
    real :: a = 3.1, b = 4.5
    integer :: i = 13, j = 11
    character(len=20), parameter :: real_fmt = '(A, 2F7.1)'
    character(len=20), parameter :: int_fmt = '(A, 2I3)'

    ! swap on real values
    print real_fmt, 'before', a, b
    call swap(a, b)
    print real_fmt, 'after', a, b

    ! swap on integer values
    print int_fmt, 'before', i, j
    call swap(i, j)
    print int_fmt, 'after', i, j
end program swap_test
~~~~

When the subroutine `swap` is called with the real arguments `a` and `b` the
compiler will generate instructions to call the subroutine `real_swap`.  On
the other hand, when `swap` is called with integer arguments `i` and `j`, the
subroutine `int_swap` will be called.
