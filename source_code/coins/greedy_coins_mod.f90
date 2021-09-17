module greedy_coins_mod
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    private

    public :: nr_change_coins, change_coins

contains

    function nr_change_coins(amount, coins) result(nr_coins)
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
    end function nr_change_coins

    function change_coins(amount, coins) result(change)
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
    end function change_coins

end module greedy_coins_mod
