program compute_distance
    use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
    implicit none
    real(kind=DP), parameter :: PI = acos(-1.0_DP), &
                                PHI = 0.5_DP*(1.0_DP + sqrt(5.0_DP)), &
                                B_REC = 0.5_DP*PI/log(PHI), &
                                DELTA_R = 1e-3_DP
    integer :: nr_values, i
    real(kind=DP) :: r, theta, x, y, distance, x_old, y_old

    call get_arguments(nr_values)

    distance = 0.0_DP
    r = 1.0_DP
    x_old = 1.0_DP
    y_old = 0.0_DP
    do i = 1, nr_values
        theta = golden_spiral(r)
        x = r*cos(theta)
        y = r*sin(theta)
        distance = distance + sqrt((x_old - x)**2 + (y_old - y)**2)
        x_old = x
        y_old = y
        r = r + DELTA_R
    end do

    print '(A, E27.15)', 'distance = ', distance

contains

    subroutine get_arguments(nr_values)
        implicit none
        integer, intent(out) :: nr_values
        character(len=128) :: buffer, msg
        integer :: istat

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting number of values as argument'
            stop 1
        end if

        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iomsg=msg, iostat=istat) nr_values
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
    end subroutine get_arguments

    function golden_spiral(r) result(theta)
        implicit none
        real(kind=DP), value :: r
        real(kind=DP) :: theta
        theta = B_REC*log(r)
    end function golden_spiral

end program compute_distance
