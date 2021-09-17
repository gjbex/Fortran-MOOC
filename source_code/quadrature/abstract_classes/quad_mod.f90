module quad_mod
    implicit none

    interface
        function func_t(x) result(res)
            implicit none
            real, value :: x
            real :: res
        end function func_t
    end interface

    private

    type, public, abstract :: quad_t
    contains
        procedure(compute_t), pass, deferred :: compute
    end type

    abstract interface
        function compute_t(this, func, a, b) result(val)
            import :: quad_t, func_t
            implicit none
            class(quad_t), intent(in) :: this
            procedure(func_t) :: func
            real, value :: a, b
            real :: val
        end function compute_t
    end interface

end module quad_mod
