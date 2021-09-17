program stats_test
    use :: stats_mod, only : stats_t, add_stats_value
    implicit none
    real :: value
    type(stats_t) :: stats = stats_t(0.0, 0.0, 0)
    integer :: i

    do i = 1, 10
        call random_number(value)
        call add_stats_value(stats, value)
    end do
    print *, 'mean', stats%sum/stats%n

end program stats_test
