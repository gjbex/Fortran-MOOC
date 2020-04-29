program array_elements
    implicit none
    integer, dimension(5) :: A
    integer :: i

    A(1) = 1
    do i = 2, size(A)
        A(i)  = 2*A(i - 1)
    end do
    print *, A
end program array_elements
