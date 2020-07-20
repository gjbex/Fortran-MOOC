module functions_mod
    implicit none

    private
    public :: func

contains

    function simple_func(x) result(f) bind(C)
        use, intrinsic :: iso_c_binding
        implicit none
        real(kind=c_double), value :: x
        real(kind=c_double) :: f

        f = 2.0*x**3
    end function simple_func

    function func(x, params) result(f) bind(C)
        use, intrinsic :: iso_c_binding
        implicit none
        real(kind=c_double), value :: x
        real(kind=c_double), dimension(3) :: params
        real(kind=c_double) :: f

        f = params(1)*x**2 + params(2)*x + params(3)
!        print '(E25.15, A, E25.15)', x, ' -> ', f
    end function func

end module functions_mod
