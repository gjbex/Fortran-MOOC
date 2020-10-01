program blas_probabilities
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, error_unit
    use :: init_mod, only : initialize, create_matrix
    implicit none
    integer :: matrix_size, nr_iters, i
    real(kind=DP), dimension(:, :), allocatable :: prob_matrix, final_matrix, &
                                                   tmp_matrix
    real(kind=DP) :: max_val

    call initialize(matrix_size, nr_iters)
    prob_matrix = create_matrix(matrix_size)
    final_matrix = create_matrix(matrix_size)
    tmp_matrix = create_matrix(matrix_size)

    call random_number(prob_matrix)
    call normalize(prob_matrix)
    call dcopy(size(prob_matrix), prob_matrix, 1, final_matrix, 1)

    do i = 2, nr_iters, 2
        call dgemm('n', 'n', &
                   matrix_size, matrix_size, matrix_size, &
                   1.0_DP, final_matrix, matrix_size, &
                   prob_matrix, matrix_size, 0.0_DP, &
                   tmp_matrix, matrix_size)
        call dgemm('n', 'n', &
                   matrix_size, matrix_size, matrix_size, &
                   1.0_DP, tmp_matrix, matrix_size, &
                   prob_matrix, matrix_size, 0.0_DP, &
                   final_matrix, matrix_size)
    end do
    if (mod(nr_iters, 2) /= 0) then
        call dgemm('n', 'n', &
                   matrix_size, matrix_size, matrix_size, &
                   1.0_DP, final_matrix, matrix_size, &
                   prob_matrix, matrix_size, 0.0_DP, &
                   tmp_matrix, matrix_size)
        call dcopy(size(prob_matrix), tmp_matrix, 1, final_matrix, 1)
    end if

    max_val = 0.0_DP
    do i = 1, size(final_matrix, 1)
        if (final_matrix(i, i) > max_val) max_val = final_matrix(i, i)
    end do

    if (matrix_size <= 10) call print_matrix(final_matrix)

    deallocate (prob_matrix, final_matrix, tmp_matrix)

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
        integer :: row, istat, rows, cols

        rows = size(matrix, 1)
        cols = size(matrix, 2)
        allocate (norm(rows), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate norm'
            stop 8
        end if
        norm = sum(matrix, dim=2)
        do row = 1, rows
            call dscal(cols, 1.0_DP/norm(row), matrix(row, :), 1)
        end do

        deallocate (norm)
    end subroutine normalize

end program blas_probabilities
