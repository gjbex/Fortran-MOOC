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
        integer, intent(in) :: a, b
        integer :: x, y

        x = a
        y = b
        do while (x /= y)
            if (x > y) then
                x = x - y
            else if (y > x) then
                y = y - x
            end if
        end do
        gcd = x
    end function gcd

end program compute_gcd
