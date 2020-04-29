program compute_trace
    implicit none
    integer :: i
    real, dimension(5, 5) :: A

    call random_number(A)
    do i = 1, size(A, 1)
        print '(5F7.4)', A(i, :)
    end do
    print '(/, A, F7.4)', 'trace = ', trace(A)

contains

    real function trace(matrix)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real, dimension(:, :), intent(in) :: matrix
        integer :: i

        if (size(matrix, 1) /= size(matrix, 2)) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not compute trace of a non-square matrix'
            stop 1
        end if
        trace = 0.0
        do i = 1, size(matrix, 1)
            trace = trace + matrix(i, i)
        end do
    end function trace

end program compute_trace
