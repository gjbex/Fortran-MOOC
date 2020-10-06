program gemv_vs_trmv
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer :: n, runs, run, i, istat
    real, dimension(:, :), allocatable :: matrix
    real, dimension(:), allocatable :: vector, orig_vector, tmp_vector, &
                                       tr_result, ge_result
    real :: start_time, end_time

    call get_arguments(runs, n)
    allocate (matrix(n, n), vector(n), orig_vector(n), tmp_vector(n), &
              tr_result(n), ge_result(n), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate data'
        stop 2
    end if
    do i = 1, n
        matrix(i, 1: i - 1) = 0.0
        call random_number(matrix(i, i:n))
    end do
    call random_number(vector)
    call scopy(size(vector), vector, 1, orig_vector, 1)

    ! vector = matrix*vector
    print '(A)', 'strmv'
    call cpu_time(start_time)
    do run = 1, runs
        call strmv('u', 'n', 'n', size(matrix, 2), matrix, size(matrix, 1), &
                   vector, 1)
    end do
    call cpu_time(end_time)
    print '(A10, F10.6)', 'strmv: ', end_time - start_time
    call scopy(size(vector), vector, 1, tr_result, 1)

    print '(A)', 'sgemv'
    call scopy(size(vector), orig_vector, 1, vector, 1)
    call cpu_time(start_time)
    do run = 1, runs, 2
        call sgemv('n', size(matrix, 1), size(matrix, 2), &
                   1.0, matrix, size(matrix, 1), vector, 1, &
                   0.0, tmp_vector, 1)
        call sgemv('n', size(matrix, 1), size(matrix, 2), &
                   1.0, matrix, size(matrix, 1), tmp_vector, 1, &
                   0.0, vector, 1)
    end do
    if (mod(runs, 2) /= 0) then
        call sgemv('n', size(matrix, 1), size(matrix, 2), &
                   1.0, matrix, size(matrix, 1), vector, 1, &
                   0.0, tmp_vector, 1)
    call scopy(size(vector), tmp_vector, 1, vector, 1)
    end if
    call cpu_time(end_time)
    print '(A10, F10.6)', 'sgemv: ', end_time - start_time
    call scopy(size(vector), vector, 1, ge_result, 1)

    if (all(abs(tr_result - ge_result) > 1.0e04)) then
        print '(A)', 'differences!'
        stop 3
    end if

    deallocate (matrix, vector, orig_vector, tmp_vector)

contains

    subroutine get_arguments(runs, n)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: runs, n
        integer :: istat
        character(len=1024) :: buffer, msg
        
        runs = 1
        if (command_argument_count() >= 1) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=istat, iomsg=msg) runs
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 1
            end if
        end if
        n = 500
        if (command_argument_count() >= 2) then
            call get_command_argument(2, buffer)
            read (buffer, fmt=*) n
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 1
            end if
        end if
    end subroutine get_arguments

end program gemv_vs_trmv
