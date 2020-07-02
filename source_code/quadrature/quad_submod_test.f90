program quad_test
    use :: quad_func_interface_mod
    use :: types_mod, only : DP
    use :: quad_submod_mod, only : quad
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
