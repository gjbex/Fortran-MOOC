program create_data
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_data_values = 3
    integer :: nr_values, data_value_nr, value_nr, unit_nr, istat, rec_nr
    character(len=1024) :: file_name, msg
    integer, dimension(nr_data_values) :: data_values = [ 1, 2, 3 ], &
                                          data_values_count = [ 1, 10, 100 ]

    call get_arguments(file_name, nr_values)

    open (newunit=unit_nr, file=trim(file_name), form='formatted', &
          status='new', action='write', access='direct', recl=10, &
          iostat=istat, iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 3
    end if
    rec_nr = 1
    do data_value_nr = 1, nr_data_values
        do value_nr = 1, nr_values*data_values_count(data_value_nr)
            write (unit=unit_nr, fmt='(I10)', rec=rec_nr) data_values(data_value_nr)
            rec_nr = rec_nr + 1
        end do
    end do
    close (unit_nr)

contains

    subroutine get_arguments(file_name, nr_values)
        implicit none
        character(len=*), intent(out) :: file_name
        integer, intent(out) :: nr_values
        integer :: istat
        character(len=1024) :: buffer, msg

        if (command_argument_count() /= 2) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting file name and number of values'
            stop 1
        end if
        call get_command_argument(1, file_name)
        call get_command_argument(2, buffer)
        read (buffer, '(I10)', iostat=istat, iomsg=msg) nr_values
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') msg
            stop 2
        end if
    end subroutine get_arguments

end program create_data
