program operators
    use :: stats_mod
    implicit none
    type(descriptive_stats_t) :: stats1, stats2, stats_all, stats_offset, stats_mult
    real :: x
    integer :: i

    x = 1.0
    do i = 1, 5
        call stats1%add_value(x)
        x = x + 0.3
    end do
    print '(A20, dt)', 'stats 1: ', stats1

    x = -1.0
    do i = 1, 5
        call stats2%add_value(x)
        x = x - 0.3
    end do
    print '(A20, dt)', 'stats 2: ', stats2

    stats_all = stats1 + stats2
    print '(A20, dt)', 'stats all: ', stats_all

    stats_offset = stats1 + 5.0
    print '(A20, dt)', 'stats_offset: ', stats_offset

    stats_mult = 2.0*stats1
    print '(A20, dt)', 'stats_mult: ', stats_mult

end program operators
