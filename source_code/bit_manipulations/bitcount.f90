program bitcount
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: bitmanip_mod
    implicit none
    integer :: nr_vals
    integer(kind=I4), dimension(:), allocatable :: vals
    integer(kind=I4) :: result
    integer :: i, istat
    real :: r, start_time, end_time

    print '(A)', 'sanity check: naive, early stopping, lookup table Kernighan'
    do i = -16, 16
        print '(I14, 3A, 4I3)', i, ': ', bit_repr(i), ': ', &
            naive_count_bits(i), early_stopping_count_bits(i), &
            lookup_table_count_bits(i), kernighan_count_bits(i)
    end do

    ! create values upfront for benchmarking
    call get_arguments(nr_vals)
    allocate (vals(nr_vals), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A, I0, A)') 'error: can not allocate ', &
            nr_vals, ' elements'
        stop 3
    end if
    do i = 1, size(vals)
        call random_number(r)
        vals(i) = int(r*real(huge(0_I4)), kind=I4)
    end do

    ! time naive implmentation
    call cpu_time(start_time)
    do i = 1, size(vals)
        result = xor(result, naive_count_bits(vals(i)))
    end do
    call cpu_time(end_time)
    print '(A, I0, A, F15.6)', 'naive implementation ', size(vals), &
        ' iterations: ', end_time - start_time

    ! time early stopping implmentation
    call cpu_time(start_time)
    do i = 1, size(vals)
        result = xor(result, early_stopping_count_bits(vals(i)))
    end do
    call cpu_time(end_time)
    print '(A, I0, A, F15.6)', 'early stopping implementation ', size(vals), &
        ' iterations: ', end_time - start_time

    ! time lookup table implmentation
    call cpu_time(start_time)
    do i = 1, size(vals)
        result = xor(result, lookup_table_count_bits(vals(i)))
    end do
    call cpu_time(end_time)
    print '(A, I0, A, F15.6)', 'lookup table implementation ', size(vals), &
        ' iterations: ', end_time - start_time

    ! time Kernighan's algorithm
    call cpu_time(start_time)
    do i = 1, size(vals)
        result = xor(result, kernighan_count_bits(vals(i)))
    end do
    call cpu_time(end_time)
    print '(A, I0, A, F15.6)', 'Kernighan implementation ', size(vals), &
        ' iterations: ', end_time - start_time
contains

    subroutine get_arguments(nr_vals)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: nr_vals
        character(len=1024) :: buffer, msg
        integer :: istat

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') 'error: expecting number of values'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) nr_vals
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
    end subroutine get_arguments

end program bitcount
