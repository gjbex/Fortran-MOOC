program compute_gcd
    implicit none
    integer, parameter :: MAX_VALUE = 10
    integer :: a, b
    do a = 1, MAX_VALUE
        do b = 1, MAX_VALUE
            print '(3I10)', a, b, gcd(a, b)
        end do
    end do

contains

    integer function gcd(a, b)
        implicit none
        integer, value :: a, b

        do while (a /= b)
            if (a > b) then
                a = a - b
            else if (b > a) then
                b = b - a
            end if
        end do
        gcd = a
    end function gcd

end program compute_gcd
