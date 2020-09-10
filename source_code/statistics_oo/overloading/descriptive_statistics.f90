program descriptive_statistics
    use, intrinsic :: iso_fortran_env, only : error_unit, input_unit, output_unit
    use :: stats_mod
    implicit none
    type(descriptive_stats_t) :: stats
    real, dimension(3) :: data_values = [ 3.5, 5.7, 7.3 ]
    integer :: i

    do i = 1, size(data_values)
        call stats%add_data(data_values(i))
    end do
    print '(A, I0)', 'n      = ', stats%get_nr_values()
    print '(A, F10.3)', 'mean   = ', stats%get_mean()
    print '(A, F10.3)', 'stddev = ', stats%get_stddev()

    call stats%add_data(data_values)
    print '(A, I0)', 'n      = ', stats%get_nr_values()
    print '(A, F10.3)', 'mean   = ', stats%get_mean()
    print '(A, F10.3)', 'stddev = ', stats%get_stddev()

end program descriptive_statistics
