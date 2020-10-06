program dot_test
    use :: blas95
    implicit none
    integer, parameter :: v_size = 5
    integer :: i
    real, dimension(v_size) :: vector1 = [ (0.5*I, i=1, v_size) ], &
                               vector2 = [ (0.1*i, i=1, v_size) ]
    real, dimension(v_size, v_size) :: matrix = reshape( &
        [ (real(i), i=1, v_size*v_size) ], [ v_size, v_size ] &
    )
    
    print '(A20, *(F5.1))', 'vector 1: ', vector1
    print '(A20, *(F5.1))', 'vector 2: ', vector2
    print '(A20, F6.2)', 'dot N 1 1: ', &
        sdot(vector1, vector2)

    print '(A)', 'matrix:'
    do i = 1, size(matrix, 1)
        print '(*(F5.1))', matrix(i, :)
    end do
    print '(A, F6.1)', 'col 2 . col 4:', &
        sdot(matrix(:, 2), matrix(:, 4))
    print '(A, F6.1)', 'row 2 . row 4:', &
        sdot(matrix(2, :), matrix(4, :))
end program dot_test
