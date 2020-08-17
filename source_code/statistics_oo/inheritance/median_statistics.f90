program median_statistics
    use, intrinsic :: iso_fortran_env, only : error_unit, input_unit
    use :: median_stats_mod
    implicit none
    integer :: nr_values
    type(median_stats_t) :: stats
    integer :: value_nr = 0, istat
    character(len=2048) :: msg
    real :: data_value

    nr_values = get_command_llne_values()
    stats = median_stats_t(nr_values)
    do while (value_nr < nr_values)
        read (unit=input_unit, fmt=*, iostat=istat, iomsg=msg) data_value
        if (istat == -1) then
            write (unit=error_unit, fmt='(2(A, I0))') &
                'warning: read ', stats%get_nr_values(), ' values, expected ', nr_values
            exit
        end if
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'warning: ', trim(msg)
            cycle
        end if
        call stats%add_value(data_value)
        value_nr = value_nr + 1
    end do
    print '(A, I0)', 'n      = ', stats%get_nr_values()
    print '(A, F10.3)', 'mean   = ', stats%get_mean()
    print '(A, F10.3)', 'median   = ', stats%get_median()
    print '(A, F10.3)', 'stddev = ', stats%get_stddev()

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

end program median_statistics
