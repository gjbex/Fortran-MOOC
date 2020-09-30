program normalize
    use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
    implicit none
    integer, parameter :: rows = 3, cols = 4
    real(kind=DP), dimension(rows, cols) :: matrix, spread_norm
    real(kind=DP), dimension(rows) :: norm

    call random_number(matrix)
    print '(A)', 'original:'
    call print_matrix(matrix)

    norm = sum(matrix, dim=2)
    print '(A, *(F12.7))', 'norm:', norm

    spread_norm = spread(norm, 2, size(matrix, 2))
    call print_matrix(spread_norm)

    matrix = matrix/spread_norm
    print '(A)', 'row-normalized::'
    call print_matrix(matrix)

    norm = sum(matrix, dim=2)
    print '(A, *(F12.7))', 'norm:', norm

contains

    subroutine print_matrix(matrix)
        implicit none
        real(kind=DP), dimension(:, :), intent(in) :: matrix
        integer :: row

        do row = 1, size(matrix, 1)
            print '(*(F12.7))', matrix(row, :)
        end do
    end subroutine print_matrix

end program normalize
