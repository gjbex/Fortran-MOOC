program real32_vs_real64
    use, intrinsic :: iso_fortran_env, only : error_unit, I8 => INT64, &
        SP => REAL32, DP => REAL64
    implicit none
    integer(kind=I8) :: nr_values
    real(kind=SP), dimension(:), allocatable :: x_sp, y_sp
    real(kind=SP) :: result
    real :: start_time, end_time
    integer :: status, i

    call get_argument(nr_values)

    ! implicit loops
    allocate (x_sp(nr_values), y_sp(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate x_sp/y_sp'
        stop 1
    end if
    call random_number(x_sp)
    call random_number(y_sp)

    call cpu_time(start_time)
    result = sum(sqrt(x_sp**2 + y_sp**2))
    call cpu_time(end_time)
    print '(A, F12.6)', 'implicit loop: ', end_time - start_time
    print '(A, F15.6)', '    result: ', result
    deallocate (x_sp, y_sp)

    ! explicit loops
    allocate (x_sp(nr_values), y_sp(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate x_sp/y_sp'
        stop 1
    end if
    call random_number(x_sp)
    call random_number(y_sp)

    call cpu_time(start_time)
    result = 0.0_SP
    do i = 1, size(x_sp)
        result = result + sqrt(x_sp(i)**2 + y_sp(i)**2)
    end do
    call cpu_time(end_time)
    print '(A, F12.6)', 'explicit loop: ', end_time - start_time
    print '(A, F15.6)', '    result: ', result
    deallocate (x_sp, y_sp)

contains

    subroutine get_argument(nr_values)
        implicit none
        integer(Kind=I8), intent(out) :: nr_values
        character(len=1024) :: buffer, msg
        integer :: status

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') 'error: expect number of values'
            stop 2
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iomsg=msg, iostat=status) nr_values
        if (status /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 3
        end if
    end subroutine get_argument

end program real32_vs_real64
