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


## Interfaces and submodules

Suppose a module defines a procedure that is used in many compilation units.
If the implementation of the procedure is modified, the module itself, but
also all compilation units that depend on it will be recompiled, which can be
an issue when working with large code bases.

That recompilation is unnecessary when the procedure's interface is unchanged,
and this can be achieved using submodules.  The module itself declares the
procedure's interface, while the submodule defines the implementation.  When
the implementation is changed, only the submodule is recompiled.

A second argument for using submodules is that it makes your code easier to
maintain.  The strict separation between the interface and the implementation
ensures that when an interface change is required, it only has to be done
in a single location.

Consider again the example of computing quadratures.  Since there are many
quadrature methods, you would create many functions to create them, all
defined in the module `quad_mod`.

~~~~fortran
module quad_mod
    implicit none

    private
    public :: quad_gauss, quad_simpson

    interface
        function quad_gauss(f, a, b) result(q_f)
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real, value :: a, b
            real :: q_f
        end function quad_gauss
    end interface
    
    interface
        function quad_simpson(f, a, b) result(q_f)
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real, value :: a, b
            real :: q_f
        end function quad_simpson
    end interface

contains

    function quad_gauss(f, a, b) result(q_f)
        use :: types_mod, only : DP
        use :: quad_func_interface_mod
        implicit none
        procedure(quad_func_t) :: f
        real(kind=DP), intent(in) :: a, b
        real(kind=DP) :: q_f
        ...
    end function quad_gauss
        
    function quad_simpson(f, a, b) result(q_f)
        use :: types_mod, only : DP
        use :: quad_func_interface_mod
        implicit none
        procedure(quad_func_t) :: f
        real(kind=DP), intent(in) :: a, b
        real(kind=DP) :: q_f
        ...
    end function quad_simpson

end module quad_mod
~~~~

A code change in `quad_gauss` would force a recompilation of all compilation
units in the module.  For this particular example, there are only two, but
there might be many, in which case compilation would potentially take a long
time.

You can address this problem using submodules.  The interface declaration
remains in the module `quad_mod`, but the implementation is put into separate
submodules, each in their own file.

~~~~fortran
module quad_mod
    implicit none

    private
    public :: quad
    
    interface
        module function quad_gauss(f, a, b) result(q_f)
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real, intent(in) :: a, b
            real :: q_f
        end function quad_gauss
    end interface

    interface
        module function quad_gauss(f, a, b) result(q_f)
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real, intent(in) :: a, b
            real :: q_f
        end function quad_gauss
    end interface

end module quad_submod_mod
~~~~

The implementations are defined in the submodules `quad_gauss_smod` and
`quad_simpson_smod`.  The former is shown below.

~~~~fortran
submodule(quad_mod) quad_gauss_smod
    implicit none
contains

    module procedure quad_gauss
        implicit none
        ...
    end procedure quad_gauss

end submodule(quad_mod) quad_gauss_smod
~~~~

Note that the interface of the function `quad_gauss` is not repeated
in the submodule.  Also, changing the implementation of `quad_gauss` will
cause the file that contains it to be recompiled, but the files that contain
the implementations of other functions.

Of course, creating a submodule for each individual function is likely
overkill, since the sheer number of files would make project maintenance
unwieldy.  A proper balance has to be struck.
