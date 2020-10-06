program syr
    use :: util_mod
    implicit none
    integer, parameter :: n = 3
    real, dimension(n) :: vector = [ 3.0, 5.0, 7.0 ]
    real, dimension(n, n) :: matrix = 0.0

    call print_vector(vector, 'vector:', '(*(F5.1))')
    call print_matrix(matrix, 'original matrix:', '(*(F5.1))')
    call ssyr('u', n, 1.0, vector, 1, matrix, n)
    call print_matrix(matrix, 'matrix:', '(*(F5.1))')
end program syr
