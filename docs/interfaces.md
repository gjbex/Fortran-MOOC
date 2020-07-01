# Interfaces

Interface blocks serve a number of purposes in Fortran.  In general, they
provide the compiler with information about procedures.  Interface blocks
contain the signature of procedures, i.e., their name and the type of
arguments, and for return type for functions.


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
