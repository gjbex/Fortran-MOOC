module fib_mod
    use, intrinsic :: iso_fortran_env, only : I8 => INT64, DP => REAL64
    implicit none

    private
    public :: fib_recursive, fib_skip_ahead, fib_memoization, &
        fib_iterative, fib_closed_form

contains

    recursive function fib_recursive(n) result(fib)
        implicit none
        integer(Kind=I8), value :: n
        integer(kind=I8) :: fib

        if (n == 0_I8) then
            fib = 0_I8
        else if (n == 1_I8) then
            fib = 1_I8
        else
            fib = fib_recursive(n - 1_I8) + fib_recursive(n - 2_I8)
        end if
    end function fib_recursive

    recursive function fib_skip_ahead(n) result(fib)
        implicit none
        integer(kind=I8), value :: n
        integer(kind=I8) :: fib
        if (n == 0_I8) then
            fib = 0_I8
        else if (n == 1_I8 .or. n == 2_I8) then
            fib = 1_I8
        else if (mod(n, 2_I8) == 0) then
            fib = fib_skip_ahead(n/2_I8)*(fib_skip_ahead(n/2_I8 + 1_I8) + &
                                          fib_skip_ahead(n/2_I8 - 1_I8))
        else
            fib = fib_skip_ahead(n/2_I8 + 1_I8)**2 + fib_skip_ahead(n/2_I8)**2
        end if
    end function fib_skip_ahead

    recursive function fib_memoization(n) result(fib)
        implicit none
        integer(kind=I8), value :: n
        integer(kind=I8) :: fib
        integer(kind=I8), parameter :: buffer_size = 1000000
        integer(kind=I8), dimension(0:buffer_size), save :: buffer = -1_I8

        buffer(0) = 0_I8
        buffer(1) = 1_I8
        if (n <= buffer_size) then
            if (buffer(n) == -1_I8) then
                buffer(n) = fib_memoization(n - 1_I8) + fib_memoization(n - 2_I8)
            end if
            fib = buffer(n)
        else
            fib = fib_memoization(n - 1_I8) + fib_memoization(n - 2_I8)
        end if
    end function fib_memoization

    function fib_iterative(n) result(fib)
        implicit none
        integer(kind=I8), value :: n
        integer(kind=I8) :: fib
        integer(kind=I8) :: fib_n_1, i, tmp

        if (n == 0_I8) then
            fib = 0_I8
        else
            fib_n_1 = 0_I8
            fib = 1_I8
            do i = 2_I8, n
                tmp = fib
                fib = fib + fib_n_1
                fib_n_1 = tmp
            end do
        end if
    end function fib_iterative

    function fib_closed_form(n) result(fib)
        implicit none
        integer(kind=I8), value :: n
        integer(kind=I8) :: fib
        real(kind=DP) :: alpha = (1.0_DP + sqrt(5.0_DP))/2.0_DP, &
                         beta  = (1.0_DP - sqrt(5.0_DP))/2.0_DP, &
                         pre_factor = 1.0_DP/sqrt(5.0_DP)

        fib = nint(pre_factor*(alpha**n - beta**n), kind=I8)
    end function fib_closed_form

end module fib_mod
