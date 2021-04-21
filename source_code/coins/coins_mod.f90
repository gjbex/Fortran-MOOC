module coins_mod
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    private

    public :: nr_change_coins_greedy, change_coins_greedy, &
        nr_change_coins_dyn_prog, change_coins_dyn_prog

contains

    function nr_change_coins_greedy(amount, coins) result(nr_coins)
        implicit none
        integer, value :: amount
        integer, dimension(:), intent(in) :: coins
        integer :: nr_coins
        integer :: coin_nr, coin

        nr_coins = 0
        do coin_nr = size(coins), 1, -1
            coin = coins(coin_nr)
            nr_coins = nr_coins + amount/coin
            amount = mod(amount, coin)
        end do
    end function nr_change_coins_greedy

    function change_coins_greedy(amount, coins) result(change)
        implicit none
        integer, value :: amount
        integer, dimension(:), intent(in) :: coins
        integer, dimension(:), allocatable :: change
        integer :: status, coin_nr, coin

        allocate (change(size(coins)), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate change'
            stop 1
        end if
        do coin_nr = size(coins), 1, -1
            coin = coins(coin_nr)
            change(coin_nr) = amount/coin
            amount = mod(amount, coin)
        end do
    end function change_coins_greedy

    function nr_change_coins_dyn_prog(amount, coins) result(nr_coins)
        implicit none
        integer, value :: amount
        integer, dimension(:), intent(in) :: coins
        integer :: nr_coins
        integer, dimension(:), allocatable :: array
        integer :: status, coin_nr, coin, i
        integer, parameter :: infinity = huge(amount)

        allocate (array(0:amount), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate array'
            stop 1
        end if
        array = infinity
        array(0) = 0

        do coin_nr = 1, size(coins)
            coin = coins(coin_nr)
            do i = coin, ubound(array, 1)
                array(i) = min(array(i), 1 + array(i - coin))
            end do
        end do

        nr_coins = array(amount)
        deallocate (array)
    end function nr_change_coins_dyn_prog

    function compute_change(matrix, coins) result(change)
        implicit none
        integer, dimension(:), intent(in) :: coins
        integer, dimension(:, :), allocatable, intent(in) :: matrix
        integer, dimension(:), allocatable :: change
        integer :: i, j, status

        allocate (change(size(coins)), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate change'
            stop 1
        end if
        change = 0
        i = ubound(matrix, 1)
        j = ubound(matrix, 2)
        do while (matrix(i, j) /= 0)
            if (i > 0) then
                do while (matrix(i, j) == matrix(i - 1, j))
                    i = i - 1
                end do
            end if
            change(i) = change(i) + 1
            j = j - coins(i)
        end do
    end function compute_change

    function change_coins_dyn_prog(amount, coins) result(change)
        implicit none
        integer, value :: amount
        integer, dimension(:), intent(in) :: coins
        integer, dimension(:), allocatable :: change
        integer :: status, coin_nr, coin, i
        integer, dimension(:, :), allocatable :: matrix

        allocate (matrix(size(coins), 0:amount), stat=status)
        matrix = 0
        matrix(1, 1:) = [ (i, i=1, amount) ]
        do coin_nr = 2, ubound(matrix, 1)
            coin = coins(coin_nr)
            do i = 1, ubound(matrix, 2)
                if (i < coin) then
                    matrix(coin_nr, i) = matrix(coin_nr - 1, i)
                else
                    matrix(coin_nr, i) = min(matrix(coin_nr - 1, i), 1 + matrix(coin_nr, i - coin))
                end if
            end do
        end do
        change = compute_change(matrix, coins)
        deallocate (matrix)
    end function change_coins_dyn_prog

end module coins_mod
