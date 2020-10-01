program dot_test
    implicit none
    integer, parameter :: v_size = 5
    integer :: i
    real, dimension(v_size) :: vector1 = [ (0.5*I, i=1, v_size) ], &
                               vector2 = [ (0.1*i, i=1, v_size) ]
    real, dimension(v_size, v_size) :: matrix = reshape( &
        [ (real(i), i=1, v_size*v_size) ], [ v_size, v_size ] &
    )
    real, external :: sdot
    
    print '(A20, *(F5.1))', 'vector 1: ', vector1
    print '(A20, *(F5.1))', 'vector 2: ', vector2
    print '(A20, F6.2)', 'dot N 1 1: ', &
        sdot(size(vector1), vector1, 1, vector2, 1)

    print '(A)', 'matrix:'
    do i = 1, size(matrix, 1)
        print '(*(F5.1))', matrix(i, :)
    end do
    print '(A, F6.1)', 'col 2 . col 4:', &
        sdot(size(matrix, 2), matrix(:, 2), 1, matrix(:, 4), 1)
    print '(A, F6.1)', 'row 2 . row 4:', &
        sdot(size(matrix, 1), matrix(2, :), 1, matrix(4, :), 1)
end program dot_test
