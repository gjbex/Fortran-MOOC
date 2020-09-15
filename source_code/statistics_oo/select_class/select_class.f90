program select_class
    use, intrinsic :: iso_fortran_env, only : error_unit, input_unit
    use :: stats_mod
    use :: median_stats_mod
    implicit none
    integer :: nr_values
    class(descriptive_stats_t), allocatable :: stats
    integer :: value_nr = 0, istat
    character(len=2048) :: msg, stats_type
    real :: data_value

    call get_command_llne_values(nr_values, stats_type)
    if (stats_type == 'median') then
        allocate (stats, source=median_stats_t(nr_values))
    else
        allocate (stats, source=descriptive_stats_t())
    end if
    do while (value_nr < nr_values)
        read (unit=input_unit, fmt=*, iostat=istat, iomsg=msg) data_value
        if (istat == -1) then
            write (unit=error_unit, fmt='(2(A, I0))') &
                'warning: read ', stats%get_nr_values(), &
                ' values, expected ', nr_values
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
    select type (stats)
        class is (median_stats_t)
            print '(A, F10.3)', 'median   = ', stats%get_median()
    end select
    print '(A, F10.3)', 'stddev = ', stats%get_stddev()

    deallocate (stats)

contains

    subroutine get_command_llne_values(nr_values, stats_type)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: nr_values
        character(len=*), intent(out) :: stats_type
        integer :: istat
        character(len=1024) :: buffer, msg

        if (command_argument_count() < 1) then
            write (unit=error_unit, fmt='(A)') &
                'error: number of values required as argument'
            stop 5
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) nr_values
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 6
        end if
        stats_type = 'simple'
        if (command_argument_count() >= 2) then
            call get_command_argument(2,stats_type)
            if (trim(stats_type) /= 'median') stats_type = 'simple'
        end if
    end subroutine get_command_llne_values

end program select_class
