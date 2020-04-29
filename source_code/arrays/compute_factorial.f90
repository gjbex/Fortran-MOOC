program compute_factorial
    implicit none
    integer :: i
    integer, dimension(5) :: values = [ (i, i=1,5) ]

    print *, values
    print *, factorial(values)

contains

    elemental integer function factorial(n)
        implicit none
        integer, value :: n
        integer :: i

        factorial = 1
        do i = 2, n
            factorial = factorial*i
        end do
    end function factorial

end program compute_factorial
