program compute_factorial
    implicit none
    integer :: n

    n = 5
    print *, factorial(n)

contains

    recursive function factorial(n) result(fac)
        implicit none
        integer, intent(in) :: n
        integer :: fac

        if (n >= 2) then
            fac = n*factorial(n - 1)
        else
            fac = 1
        end if
    end function factorial

end program 
