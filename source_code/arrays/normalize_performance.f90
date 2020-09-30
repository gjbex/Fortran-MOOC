program normalize_performance
    use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
    implicit none
    integer :: matrix_size
    real(kind=DP), dimension(:, :), allocatable :: matrix
    integer :: row, istat
    real :: start_time, end_time

    call get_arguments(matrix_size)
    allocate (matrix(matrix_size, matrix_size), stat=istat)

    ! reinitialize the matrix to avoid cache effects
    call random_number(matrix)
    call cpu_time(start_time)
    do row = 1, size(matrix, 1)
        matrix(row, :) = matrix(row, :)/sum(matrix(row, :))
    end do
    call cpu_time(end_time)
    print '(A, F10.6)', 'row-wise norm: ', end_time - start_time
    if (.not. is_normed(matrix, abs_tol=1e-4_DP)) then
        write (unit=error_unit, fmt='(A)') 'error: array is not normalized (row-wise)'
    end if


    ! initialize the matrix
    call random_number(matrix)
    call cpu_time(start_time)
    matrix = matrix/spread(sum(matrix, dim=2), 2, size(matrix, 2))
    call cpu_time(end_time)
    print '(A, F10.6)', 'norm using spread: ', end_time - start_time
    if (.not. is_normed(matrix, abs_tol=1e-4_DP)) then
        write (unit=error_unit, fmt='(A)') 'error: array is not normalized (spread)'
    end if

    deallocate (matrix)

contains

    subroutine get_arguments(matrix_size)
        implicit none
        integer, intent(out) :: matrix_size
        character(len=1024) :: buffer, msg
        integer :: istat

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') 'error: expect matrix size as argument'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) matrix_size
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
    end subroutine get_arguments

    function is_normed(matrix, abs_tol) result(is_okay)
        implicit none
        real(kind=DP), dimension(:, :), intent(in) :: matrix
        real(kind=DP), value :: abs_tol
        logical :: is_okay
        
        is_okay = all(sum(matrix, dim=2) - 1.0_DP < abs_tol)
    end function is_normed

end program normalize_performance
