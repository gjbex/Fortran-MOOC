program do_factorials
    implicit none
    integer, parameter :: MAX_N = 10
    integer :: i

    do i = 1, MAX_N
        print *, i, factorial(i)
    end do

contains

    function factorial(n) result(fac)
        implicit none
        integer, intent(in) :: n
        integer :: fac
        integer :: i

        fac = 1
        do i = 2, n
            fac = fac*i
        end do
    end function factorial

end program do_factorials
