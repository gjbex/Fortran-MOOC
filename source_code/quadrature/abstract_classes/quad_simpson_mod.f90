module quad_simpson_mod
    use :: quad_mod
    implicit none

    private
    type, public, extends(quad_t) :: quad_simpson_t
    contains
        procedure :: compute => compute_simpson
    end type

    interface quad_simpson_t
        module procedure :: create_quad
    end interface

contains

    function create_quad() result(quad)
        implicit none
        type(quad_simpson_t) :: quad
    end function create_quad

    function compute_simpson(this, func, a, b) result(res)
        implicit none
        class(quad_simpson_t), intent(in) :: this
        procedure(func_t) :: func
        real, value :: a, b
        real :: res
        integer, parameter :: n = 10
        integer :: i
        real :: delta_x

        delta_x = (b - a)/n
        res = func(a) + func(b)
        do i = 1, n - 1, 2
            res = res + 4.0*func(a + i*delta_x)
        end do
        do i = 2, n - 1, 2
            res = res + 2.0*func(a + i*delta_x)
        end do
        res = res*delta_x/3.0
    end function compute_simpson

end module quad_simpson_mod
