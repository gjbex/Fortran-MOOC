program scal
    use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
    implicit none
    integer, parameter :: rows = 3, cols = 4
    real(kind=DP), dimension(rows, cols) :: matrix
    real(kind=DP), dimension(rows) :: norm
    integer :: row

    call random_number(matrix)
    print '(A)', 'original:'
    call print_matrix(matrix)

    norm = sum(matrix, dim=2)
    print '(A, *(F12.7))', 'norm:', norm

    do row = 1, rows
        print '(A, I0)', 'row: ', row
        call dscal(cols, 1.0_DP/norm(row), matrix(row, :), 1)
        call print_matrix(matrix)
    end do
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

end program scal
