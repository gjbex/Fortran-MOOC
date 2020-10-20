program sv
    use util_mod, only : print_matrix
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: n_matrix = 3, nr_rhs = 1
    real, dimension(n_matrix, n_matrix) :: A, A_orig
    real, dimension(n_matrix, nr_rhs) :: X, B, B_orig
    integer, dimension(n_matrix) :: P
    integer :: info

    A = reshape( [ &
        3.0, 5.0, 7.0, &
        11.0, 13.0, 17.0, &
        19.0, 23.0, 29.0, 31.0 &
    ], [ 3, 3 ])
    A_orig = A
    B = reshape( [ 1.0, 11.0, 3.0 ], [ 3, 1 ])
    B_orig = B

    ! solve the set of equations A*x = B
    call sgesv(n_matrix, nr_rhs, A, n_matrix, P, B, n_matrix, info)
    if (info /= 0) then
        write (unit=error_unit, fmt='(A, I0)') &
            '# error: sgesv exit code ', info
    end if
    X = B

    ! check solution
    call sgemm('N', 'N', n_matrix, nr_rhs, n_matrix, 1.0, A_orig, n_matrix, &
               X, n_matrix, 0.0, B, n_matrix)

    call print_matrix(A_orig, 'orig. A', '(*(F9.3))')
    call print_matrix(X, 'X', '(F12.6)')
    call print_matrix(B, 'B', '(F12.6)')
    call print_matrix(B_orig, 'orig. B', '(F9.3)')

    ! compute and print relative error
    print '(A, E10.3)', 'relative error = ', compute_error(B_orig, B)

contains

    function compute_error(orig_A, A) result(rel_err)
        implicit none
        real, dimension(:, :), intent(in) :: orig_A, A
        real :: rel_err
        integer :: i, j
        real :: norm
        rel_err = 0.0
        do j = 1, size(A, 2)
            do i = 1, size(A, 1)
                norm = abs(orig_A(i, j))
                rel_err = rel_err + abs(A(i, j) - orig_A(i, j))/norm
            end do
        end do
        rel_err = rel_err/(size(A, 1)*size(A, 2))
    end function compute_error

end program sv
