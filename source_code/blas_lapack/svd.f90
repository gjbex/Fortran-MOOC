program svd
    use util_mod, only : print_matrix
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_rows = 3, nr_cols = 4
    real, dimension(nr_rows, nr_cols) :: A, A_orig, Sigma, tmp
    real, dimension(nr_rows, nr_rows) :: U
    real, dimension(nr_cols, nr_cols) :: VT
    real, dimension(min(nr_rows, nr_cols)) :: S
    real, dimension(:), allocatable :: work
    integer :: istat, lwork, info

    call random_number(A)
    A_orig = A

    ! compute full SVD of A
    allocate(work(1))
    info = 0
    call sgesvd('A', 'A', nr_rows, nr_cols, A, nr_rows, S, &
                U, nr_rows, VT, nr_cols, work, -1, info)
    lwork = int(work(1)) + 1
    write (unit=error_unit, fmt="(A, I0, A)") &
        "work size is ", lwork, " double"
    deallocate(work)
    allocate(work(lwork), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt="(A)") "can not allocate work array"
        stop
    end if
    call sgesvd('A', 'A', nr_rows, nr_cols, A, nr_rows, S, &
                U, nr_rows, VT, nr_cols, work, lwork, info)

    call compute_sigma(S, Sigma)

    ! print results if verbose
    print "(A)", "U"
    call print_matrix(U)
    print "(A)", "Sigma"
    call print_matrix(Sigma)
    print "(A)", "V^t"
    call print_matrix(VT)

    call sgemm('N', 'N', nr_rows, nr_cols, nr_rows, 1.0, U, nr_rows, &
               Sigma, nr_rows, 0.0, tmp, nr_rows)
    call sgemm('N', 'N', nr_rows, nr_cols, nr_cols, 1.0, tmp, nr_rows, &
               VT, nr_cols, 0.0, A, nr_rows)

    print "(A)", "A"
    call print_matrix(A)
    print "(A)", "orig. A"
    call print_matrix(A_orig)

    ! compute and print relative error
    print "(A, E10.3)", 'relative error = ', compute_error(A_orig, A)

contains

    subroutine compute_sigma(S, Sigma)
        implicit none
        real, dimension(:), intent(in) :: S
        real, dimension(:, :), intent(out) :: Sigma
        integer :: i
        Sigma = 0.0
        do i = 1, min(size(Sigma, 1), size(Sigma, 2))
            Sigma(i, i) = S(i)
        end do
    end subroutine compute_sigma

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

end program svd
