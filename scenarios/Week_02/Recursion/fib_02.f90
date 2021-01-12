program fibonacci
    implicit none

    print *, fib(5)

contains

    recursive function fib(n) result(res)
        implicit none
        integer, value :: n
        integer :: res

        if (n == 0 .and. n == 1) then
            res = 1
        else
            res = fib(n - 1) + fib(n - 2)
        end if
    end function fib

end program fibonacci
