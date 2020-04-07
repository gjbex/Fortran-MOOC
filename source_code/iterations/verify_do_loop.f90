program verify_bounds
    implicit none
    integer, parameter :: NR_CASES = 10000
    integer :: i, start_val, end_val, step

    do i = 1, NR_CASES
        call generate_bounds(start_val, end_val, step)
        call test_do_loop(start_val, end_val, step)
    end do

contains

    subroutine test_do_loop(start_val, end_val, step)
        implicit none
        integer, value :: start_val, end_val, step
        integer :: i, expected_i, last_val, expected_last_val, &
                   nr_iters, expected_nr_iters

        nr_iters = 0
        last_val = start_val
        do i = start_val, end_val, step
            nr_iters = nr_iters + 1
            last_val = i
        end do
        expected_nr_iters = (end_val - start_val + step)/step
        if (nr_iters /= expected_nr_iters) then
            print '(5(A, I0))', 'start = ', start_val, &
                                ', end = ', end_val, &
                                ' step = ', step, &
                                ', expected nr. iters = ', expected_nr_iters, &
                                ', nr. iters = ', nr_iters
        end if
        if (nr_iters /= 0) then
            expected_last_val = start_val + (nr_iters - 1)*step
            if (last_val /= expected_last_val) then
                print '(5(A, I0))', 'start = ', start_val, &
                                    ', end = ', end_val, &
                                    ' step = ', step, &
                                    ', expected last = ', expected_last_val, &
                                    ', last = ', last_val
            end if
        end if
        expected_i = start_val + expected_nr_iters*step
        if (i /= expected_i) then
            print '(5(A, I0))', 'start = ', start_val, &
                                ', end = ', end_val, &
                                ' step = ', step, &
                                ', expected i = ', expected_i, &
                                ', i = ', i
        end if
    end subroutine test_do_loop

    subroutine generate_bounds(start_val, end_val, step)
        implicit none
        integer, intent(out) :: start_val, end_val, step

        step = 0
        do while (step == 0)
            step = random_int(-100, 100)
        end do
        if (step >= 0) then
            do while (.true.)
                start_val = random_int(-100, 100)
                end_val = random_int(-100, 100)
                if (start_val <= end_val) exit
            end do
        else
            do while (.true.)
                start_val = random_int(-100, 100)
                end_val = random_int(-100, 100)
                if (start_val >= end_val) exit
            end do
        end if
    end subroutine generate_bounds

    function random_int(from_val, to_val) result(r_int)
        implicit none
        integer ,value :: from_val, to_val
        integer ::  r_int
        real :: r
        
        call random_number(r)
        r_int = int(from_val + r*(to_val - from_val))
    end function random_int


end program verify_bounds
