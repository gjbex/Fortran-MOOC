program gemv_test
    use :: util_mod
    implicit none
    integer, parameter :: rows = 3, cols = 2
    integer :: i
    real, dimension(rows, cols) :: A = reshape( [ (real(i), i=1, rows*cols) ], [ rows, cols ])
    real, dimension(cols) :: v = [ 1.0, 2.0 ]
    real, dimension(rows) :: u
    character(len=12) :: fmt_str = '(*(F6.1))'
    
    call print_matrix(A, 'A', fmt_str)
    call print_vector(v, 'v', fmt_str)
    call sgemv('n', rows, cols, 1.0, A, rows, v, 1, 0.0, u, 1)
    call print_vector(u, 'u', fmt_str)

end program gemv_test
