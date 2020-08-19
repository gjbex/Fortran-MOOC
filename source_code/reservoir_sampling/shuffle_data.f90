program shuffle_data
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: recl = 10
    integer :: unit_nr, istat, val_i, val_j, file_size, nr_values, i, j
    real :: r
    character(len=1024) :: file_name, msg

    call get_arguments(file_name)

    open (newunit=unit_nr, file=trim(file_name), form='formatted', &
          status='old', action='readwrite', access='direct', recl=recl, &
          iostat=istat, iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', msg
        stop 2
    end if
    inquire (unit=unit_nr, size=file_size)
    nr_values = file_size/recl
    do i = 1, nr_values - 1
        call random_number(r)
        j = i + floor(r*(nr_values - i + 1))
        val_i = read_value(unit_nr, i)
        val_j = read_value(unit_nr, j)
        call write_value(unit_nr, i, val_j)
        call write_value(unit_nr, j, val_i)
    end do
    close (unit_nr)

contains

    function read_value(unit_nr, rec) result(val)
        implicit none
        integer, value :: unit_nr, rec
        integer :: val
        integer :: istat
        character(len=1024) :: msg

        read (unit=unit_nr, fmt='(I10)', rec=rec, iostat=istat, iomsg=msg) val
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
    end function read_value

    subroutine write_value(unit_nr, rec, val)
        implicit none
        integer, value :: unit_nr, rec, val
        integer :: istat
        character(len=1024) :: msg

        write (unit=unit_nr, fmt='(I10)', rec=rec, iostat=istat, iomsg=msg) val
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
    end subroutine write_value

    subroutine get_arguments(file_name)
        implicit none
        character(len=*), intent(out) :: file_name

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') 'error: expecting file name'
            stop 1
        end if
        call get_command_argument(1, file_name)
    end subroutine get_arguments

end program shuffle_data
