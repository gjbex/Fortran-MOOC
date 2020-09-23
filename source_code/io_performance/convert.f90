program convert
    use, intrinsic :: iso_fortran_env, only : error_unit, iostat_end, &
        DP => REAL64
    implicit none
    integer :: unit_nr, istat
    character(len=1024) :: file_name, msg
    real(kind=DP) :: r, theta

    call get_arguments(file_name)
    open (newunit=unit_nr, file=file_name, form='unformatted', &
          access='sequential', action='read', status='old', iostat=istat, &
          iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 3
    end if
    do
        read (unit=unit_nr, iostat=istat, iomsg=msg) r, theta
        if (istat == iostat_end) exit
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        end if
        print '(2E27.15)', r, theta
    end do
    close(unit=unit_nr)

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

end program convert
