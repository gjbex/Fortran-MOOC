program matrix_test
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    use :: matrix_mod, only : norm_matrix_rows
    implicit none
    integer :: i
    real(kind=DP), dimension(3, 4) :: matrix = reshape( [ (i, i=1, 12) ], &
                                                       shape(matrix))
    print '(A)', 'Original:'
    call print_matrix(matrix)
    call norm_matrix_rows(matrix)
    print '(A)', 'Normed:'
    call print_matrix(matrix)

contains

    subroutine print_matrix(matrix)
        implicit none
        real(kind=DP), dimension(:, :), intent(in) :: matrix
        integer :: i

        do i = 1, size(matrix, 1)
            print '(*(F9.3))', matrix(i, :)
        end do
    end subroutine print_matrix

end program matrix_test
