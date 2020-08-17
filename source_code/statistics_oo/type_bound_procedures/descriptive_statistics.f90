program descriptive_statistics
    use, intrinsic :: iso_fortran_env, only : error_unit, input_unit, output_unit
    use :: stats_mod
    implicit none
    type(descriptive_stats_t) :: stats
    integer :: istat
    character(len=2048) :: msg
    real :: data_value

    do
        read (unit=input_unit, fmt=*, iostat=istat, iomsg=msg) data_value
        if (istat == -1) exit
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'warning: ', trim(msg)
            cycle
        end if
        call stats%add_value(data_value)
    end do
    print '(A, I0)', 'n      = ', stats%get_nr_values()
    print '(A, F10.3)', 'mean   = ', stats%get_mean()
    print '(A, F10.3)', 'stddev = ', stats%get_stddev()
    write (unit=output_unit, fmt='(dt)') stats
    print '(dt(7, 2, 7, 2))', stats

end program descriptive_statistics
