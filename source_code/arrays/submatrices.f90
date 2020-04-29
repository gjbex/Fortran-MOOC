program submatrices
    implicit none
    integer, dimension(3, 4) :: A
    integer :: i, j

    A = reshape([ (((i - 1)*size(A, 2) + j, j=1, size(A, 2)), i=1,size(A, 1)) ], &
                shape(A))
    print *, A(2, :)
    print *, A(:, 3)
    print '(A, I0)', 'rank = ', rank(A(2, :))
    print '(A, I0)', 'shape = ', shape(A(2, :))
end program submatrices
