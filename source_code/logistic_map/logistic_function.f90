program logistic_function
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none
    real(kind=DP) :: x, x0, r
    integer :: nr_iterations, i

    call get_parameters(x0, r, nr_iterations)
    x = x0
    do i = 1, nr_iterations
        x = logistic_iteration(x, r)
        print '(I0, F15.7)', i, x
    end do

contains

    function logistic_iteration(x, r) result(y)
        implicit none
        real(kind=DP), value :: x, r
        real(kind=DP) :: y

        y = r*x*(1.0_DP - x)
    end function logistic_iteration

    subroutine get_parameters(x0, r, nr_iterations)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real(kind=DP), intent(out) :: x0, r
        integer, intent(out) :: nr_iterations
        character(len=1024) :: buffer, msg
        integer :: status

        if (command_argument_count() /= 3) then
            x0 = 0.5
            r = 3.0
            nr_iterations = 1000
        else
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) x0
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
                stop 1
            end if
            call get_command_argument(2, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) r
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
                stop 1
            end if
            call get_command_argument(3, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) nr_iterations
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
                stop 1
            end if
        end if
    end subroutine get_parameters

end program logistic_function
