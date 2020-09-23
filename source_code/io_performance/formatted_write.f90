program formatted_write
    use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
    implicit none
    real(kind=DP), parameter :: PI = acos(-1.0_DP), &
                                PHI = 0.5_DP*(1.0_DP + sqrt(5.0_DP)), &
                                B_REC = 0.5_DP*PI/log(PHI), &
                                DELTA_R = 1.0e-3_DP
    integer :: nr_values, i, unit_nr, istat
    character(len=1024) :: file_name, msg
    real(kind=DP) :: r

    call get_arguments(nr_values, file_name)
    open (newunit=unit_nr, file=file_name, form='formatted', &
          access='sequential', action='write', status='new', iostat=istat, &
          iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 3
    end if
    r = 1.0_DP
    do i = 1, nr_values
        write (unit=unit_nr, fmt='(2E27.15)', iostat=istat, iomsg=msg) &
            r, golden_spiral(r)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        end if
        r = r + DELTA_R
    end do
    close(unit=unit_nr)

contains

    subroutine get_arguments(nr_values, file_name)
        implicit none
        integer, intent(out) :: nr_values
        character(len=*), intent(out) :: file_name
        character(len=128) :: buffer, msg
        integer :: istat

        if (command_argument_count() /= 2) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting number of values and file name as arguments'
            stop 1
        end if

        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iomsg=msg, iostat=istat) nr_values
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
        call get_command_argument(2, file_name)
    end subroutine get_arguments

    function golden_spiral(r) result(theta)
        implicit none
        real(kind=DP), value :: r
        real(kind=DP) :: theta
        theta = B_REC*log(r)
    end function golden_spiral

end program formatted_write
