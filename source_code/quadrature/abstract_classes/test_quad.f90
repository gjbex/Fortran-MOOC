program test_quad
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: quad_mod
    use :: quad_gauss_mod
    use :: quad_gauss5_mod
    use :: quad_gauss10_mod
    use :: quad_simpson_mod
    implicit none
    real, parameter :: PI = acos(-1.0)
    class(quad_t), allocatable :: quad
    character(len=20) :: method

    call get_arguments(method)

    select case (method)
    case ('quad5')
        allocate(quad, source=quad_gauss5_t())
    case ('quad10')
        allocate(quad, source=quad_gauss10_t())
    case ('simpson')
        allocate(quad, source=quad_simpson_t())
    case default
        write (unit=error_unit, fmt='(3A)') 'error: method ', trim(method), &
            ' is not implemented'
        stop 11
    end select
    print '(F10.7)', quad%compute(func, 0.0, PI)

contains

    function func(x) result(res)
        implicit none
        real, value :: x
        real :: res

        res = sin(x)
    end function func

    subroutine get_arguments(method)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        character(len=*), intent(out) :: method

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') 'error: expect method as argument'
            stop 10
        end if
        call get_command_argument(1, method)
    end subroutine get_arguments

end program test_quad
