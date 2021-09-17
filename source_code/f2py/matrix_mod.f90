module matrix_mod
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    private
    public :: norm_matrix_rows

contains

    subroutine norm_matrix_rows(matrix)
        implicit none
        integer, parameter :: DP = selected_real_kind(15, 307)
        real(kind=DP), dimension(:, :), intent(inout) :: matrix
        real(kind=DP), dimension(:), allocatable :: row_sums
        integer :: status, j

        allocate (row_sums(size(matrix, 1)), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate row sums'
            stop 11
        end if
        row_sums = sum(matrix, dim=2)
        do j = 1, size(matrix, 2)
            matrix(:, j) = matrix(:, j)/row_sums
        end do
        deallocate (row_sums)
    end subroutine norm_matrix_rows

end module matrix_mod
