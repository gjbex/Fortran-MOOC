program compute_pi
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, I8 => INT64
    implicit none
    integer(kind=I8) :: i, nr_iters
    real(kind=DP) :: delta, x, pi_val

    pi_val = 0.0_DP
    nr_iters = get_nr_iters()
    delta = 1.0_DP/nr_iters
    x = 0.0_DP
    do i = 1, nr_iters
        pi_val = pi_val + sqrt(1.0_DP - x**2)
        x = x + delta
    end do
    pi_val = 4.0_DP*pi_val/nr_iters
    print '(F25.15)', pi_val

contains
     
    function get_nr_iters() result(nr_iters)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer(kind=I8) :: nr_iters
        integer(kind=I8), parameter :: default_nr_iters = 1000_I8
        character(len=1024) :: buffer, msg
        integer :: istat

        if (command_argument_count() >= 1) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=istat, iomsg=msg) nr_iters
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') &
                    'error: ', msg
                stop 1
            end if
        else
            nr_iters = default_nr_iters
        end if
    end function get_nr_iters

end program compute_pi
