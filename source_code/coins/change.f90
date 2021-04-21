program coins_change
    use, intrinsic :: iso_fortran_env, only : error_unit
    use coins_mod, only : nr_change_coins_greedy, change_coins_greedy, &
        nr_change_coins_dyn_prog, change_coins_dyn_prog
    implicit none
    integer :: amount
    integer, dimension(:), allocatable :: coins, change

    call get_arguments(amount, coins)
    print '(A, I0)', 'greedy: ', nr_change_coins_greedy(amount, coins)
    change = change_coins_greedy(amount, coins)
    call show_change(coins, change)
    deallocate (change)
    print '(A, I0)', 'dynamic programming:: ', nr_change_coins_dyn_prog(amount, coins)
    change = change_coins_dyn_prog(amount, coins)
    call show_change(coins, change)
    deallocate (coins, change)

contains

    subroutine show_change(coins, change)
        implicit none
        integer, dimension(:), intent(in) :: coins, change

        print '(A, *(I4))', '  coins : ', coins
        print '(A, *(I4))', '  change: ', change
    end subroutine show_change

    subroutine get_arguments(amount, coins)
        implicit none
        integer, intent(out) :: amount
        integer, dimension(:), allocatable, intent(out) :: coins
        character(len=1024) :: buffer, msg
        integer :: status, i, nr_coins

        if (command_argument_count() < 2) then
            write (unit=error_unit, fmt='(A)') 'error: expecting amount and coins'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iostat=status, iomsg=msg) amount
        if (status /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
        nr_coins = command_argument_count() - 1
        allocate (coins(nr_coins), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate coins'
            stop 3
        end if

        do i = 1, nr_coins
            call get_command_argument(1 + i, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) coins(i)
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 2
            end if
        end do
    end subroutine

end program coins_change
