program matrix
    implicit none
    integer, parameter :: ROWS = 3, COLS = 5
    real, dimension(ROWS, COLS) :: A
    integer :: i, j
    real :: total

    A = reshape([ (((i - 1)*size(A, 2) + j, j=1,size(A, 2)), i=1,size(A, 1)) ], &
                shape(A))
    do i = 1, size(A, 1)
        print *, A(i, :)
    end do
    total = 0.0
    do j = 1, size(A, 2)
        do i = 1, size(A, 1)
            total = total + A(i, j)**2
        end do
    end do
    print '(/, A, F10.2)', 'total = ', total
end program matrix
