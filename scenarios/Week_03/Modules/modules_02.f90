program stats_test
    use :: stats_mod, only : stats_t, init_stats, add_stats_value, mean_stats
    implicit none
    real :: value
    type(stats_t) :: stats
    integer :: i

    call init_stats(stats)
    do i = 1, 10
        call random_number(value)
        call add_stats_value(stats, value)
    end do
    print *, 'mean', mean_stats(stats)

end program stats_test
