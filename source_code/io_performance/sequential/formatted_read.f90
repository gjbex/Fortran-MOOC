program formatted_read
    use, intrinsic :: iso_fortran_env, only : error_unit, iostat_end, &
        DP => REAL64
    implicit none
    integer :: unit_nr, istat
    character(len=1024) :: file_name, msg
    real(kind=DP) :: r, theta, x, y, distance, x_old, y_old

    call get_arguments(file_name)
    open (newunit=unit_nr, file=file_name, form='formatted', &
          access='sequential', action='read', status='old', iostat=istat, &
          iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 3
    end if
    distance = 0.0_DP
    x_old = 1.0_DP
    y_old = 0.0_DP
    do
        read (unit=unit_nr, fmt='(2E27.15)', iostat=istat, iomsg=msg) &
            r, theta
        if (istat == iostat_end) exit
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        end if
        x = r*cos(theta)
        y = r*sin(theta)
        distance = distance + sqrt((x_old - x)**2 + (y_old - y)**2)
        x_old = x
        y_old = y
    end do
    close (unit=unit_nr)

    print '(A, E27.15)', 'distance = ', distance

contains

    subroutine get_arguments(file_name)
        implicit none
        character(len=*), intent(out) :: file_name

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting file name as argument'
            stop 1
        end if

        call get_command_argument(1, file_name)
    end subroutine get_arguments

end program formatted_read
