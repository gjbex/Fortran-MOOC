program arrays
    implicit none
    integer :: i, j
    real, dimension(2, 3) :: matrix1
    real, dimension(3, 2) :: matrix2
    real, dimension(2, 2) :: matrix3

    matrix1 = reshape([ (i, i=1, 6) ], [2, 3])
    do i = 1, size(matrix1, 1)
        print *, matrix1(i, :)
    end do
    matrix2 = reshape([ ((i - 2*j, i=1, 2), j=1, 3) ], [3, 2])
    do i = 1, size(matrix2, 1)
        print *, matrix2(i, :)
    end do
    print *, size(matrix2)
    print *, size(matrix2, 1), size(matrix2, 2)
    matrix3 = matmul(matrix1, matrix2)
    do i = 1, size(matrix3, 1)
        print *, matrix3(i, :)
    end do
end program arrays
