program no_blas_probabilities
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, error_unit
    use :: init_mod, only : initialize, create_matrix
    implicit none
    integer :: matrix_size, nr_iters, i
    real(kind=DP), dimension(:, :), allocatable :: prob_matrix, final_matrix
    real(kind=DP) :: max_val

    call initialize(matrix_size, nr_iters)
    prob_matrix = create_matrix(matrix_size)
    final_matrix = create_matrix(matrix_size)

    call random_number(prob_matrix)
    call normalize(prob_matrix)
    final_matrix = prob_matrix

    do i = 2, nr_iters
        final_matrix = matmul(final_matrix, prob_matrix)
    end do
    max_val = 0.0_DP
    do i = 1, size(final_matrix, 1)
        if (final_matrix(i, i) > max_val) max_val = final_matrix(i, i)
    end do

    if (matrix_size <= 10) call print_matrix(final_matrix)

    deallocate (prob_matrix, final_matrix)

    print '(A, e25.15)', 'maximum value = ', max_val

contains

    subroutine print_matrix(matrix)
        implicit none
        real(kind=DP), dimension(:, :), intent(in) :: matrix
        integer :: row

        do row = 1, size(matrix, 1)
            print '(*(F12.7))', matrix(row, :)
        end do
    end subroutine print_matrix

    subroutine normalize(matrix)
        implicit none
        real(kind=DP), dimension(:, :), intent(inout) :: matrix
        real(kind=DP), dimension(:), allocatable :: norm
        integer :: row, istat

        allocate (norm(size(matrix, 1)), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate norm'
            stop 8
        end if
        norm = sum(matrix, dim=2)
        do row = 1, size(matrix, 1)
            matrix(row, :) = matrix(row, :)/norm(row)
        end do

        deallocate (norm)
    end subroutine normalize

end program no_blas_probabilities
