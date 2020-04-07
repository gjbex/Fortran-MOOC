program messing_up
    implicit none
    integer :: i, n, step

    n = 10
    step = 1
    do i = 1, n, step
        print *, i
        if (i == 2) n = 10
        step = 2
    end do
end program messing_up
