program assumed
    implicit none
    integer :: i
    integer, dimension(5) :: array1d = [ 2, 3, 5, 7, 11 ]

    print *, array1d
    call factorial(array1d)
    print *, array1d
contains

    integer function fac(n)
        implicit none
        integer, value :: n
        integer :: i

        fac = 1
        do i = 2, n
            fac = fac*i
        end do
    end function fac

    subroutine factorial(A)
        implicit none
        integer, dimension(:), intent(inout) :: A
        integer :: i

        do i = 1, size(A)
            A(i) = fac(A(i))
        end do
    end subroutine factorial

end program assumed
