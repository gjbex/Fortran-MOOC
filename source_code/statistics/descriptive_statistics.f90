program descriptive_statistics
    use, intrinsic :: iso_fortran_env, only : error_unit, input_unit
    use :: stats_mod
    implicit none
    integer :: nr_values
    type(descriptive_stats_t) :: stats
    integer :: value_nr, istat
    character(len=2048) :: msg
    real :: data_value

    nr_values = get_command_llne_values()
    do value_nr = 1, nr_values
        read (unit=input_unit, fmt=*, iostat=istat, iomsg=msg) data_value
        if (istat == -1) then
            write (unit=error_unit, fmt='(2(A, I0))') &
                'warning: read ', get_nr_values(stats), ' values, expected ', nr_values
            exit
        end if
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'warning: ', trim(msg)
            cycle
        end if
        call add_value(stats, data_value)
    end do
    print '(A, I0)', 'n      = ', get_nr_values(stats)
    print '(A, F10.3)', 'mean   = ', get_mean(stats)
    print '(A, F10.3)', 'stddev = ', get_stddev(stats)

contains

    function get_command_llne_values() result(nr_values)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer :: nr_values
        character(len=1024) :: buffer

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                'error: number of values required as argument'
            stop 5
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*) nr_values
    end function get_command_llne_values

end program descriptive_statistics
