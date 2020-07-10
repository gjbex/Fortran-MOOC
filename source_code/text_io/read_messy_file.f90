program read_messy_file
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_values = 3
    character(len=1024) :: file_name, msg
    integer :: i, istat, unit_nr
    real, dimension(nr_values) :: real_values
    integer, dimension(nr_values) :: int_values
    logical, dimension(nr_values) :: logical_values
    character(len=20), dimension(nr_values) :: char_values

    call get_file_name(file_name)
    open (newunit=unit_nr, file=file_name, access='sequential', action='read', &
          status='old', iostat=istat, iomsg=msg)

    do i = 1, nr_values
        read (unit=unit_nr, fmt=*, iostat=istat, iomsg=msg) &
            real_values(i), int_values(i), logical_values(i), char_values(i)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 1
        end if
    end do

    close (unit=unit_nr)

    print '(*(E20.7))', real_values
    print '(*(I20))', int_values
    print '(*(L20))', logical_values
    print '(*(A20))', char_values

contains

    subroutine get_file_name(file_name)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        character(len=*), intent(out) :: file_name

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') 'error: expecting file name as argument'
            stop 1
        end if
        call get_command_argument(1, file_name)
    end subroutine get_file_name

end program read_messy_file
