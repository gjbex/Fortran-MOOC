program copy_test
    implicit none
    integer, parameter :: v_size = 10
    integer :: i
    real, dimension(v_size) :: vector1 = [ (real(i), i=1, v_size) ], vector2
    real, dimension(2*v_size) :: large_vector

    print '(A20, *(F5.1))', 'original: ', vector1
    vector2 = 0.0
    large_vector = 0.0
    call scopy(size(vector1), vector1, 1, vector2, 1)
    print '(A20, *(F5.1))', 'copy N 1 1: ', vector2

    vector2 = 0.0
    call scopy(size(vector1), vector1, 1, vector2, 2)
    print '(A20, *(F5.1))', 'copy N 1 2: ', vector2

    vector2 = 0.0
    call scopy(size(vector1), vector1, 2, vector2, 1)
    print '(A20, *(F5.1))', 'copy N 2 1`: ', vector2

    vector2 = 0.0
    call scopy(size(vector1), vector1, 2, vector2, 2)
    print '(A20, *(F5.1))', 'copy N 2 2`: ', vector2

    large_vector = 0.0
    call scopy(size(vector1), vector1, 1, large_vector, 2)
    print '(A20, *(F5.1))', 'copy N 1 2`: ', large_vector
    call scopy(size(vector1), 3.0*vector1, 1, large_vector(2), 2)
    print '(A20, *(F5.1))', 'shift copy N 1 2`: ', large_vector

end program copy_test
