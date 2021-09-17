program real32_vs_real64
    use, intrinsic :: iso_fortran_env, only : error_unit, I8 => INT64, &
        SP => REAL32, DP => REAL64
    implicit none
    integer(kind=I8) :: nr_values
    real(kind=SP), dimension(:), allocatable :: x_sp, y_sp
    real(kind=SP), parameter :: alpha_sp = 0.5_SP
    real(kind=DP), dimension(:), allocatable :: x_dp, y_dp
    real(kind=DP), parameter :: alpha_dp = 0.5_DP
    real :: start_time, end_time
    integer :: status

    call get_argument(nr_values)

    ! double precison
    allocate (x_dp(nr_values), y_dp(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate x_dp/y_dp'
        stop 1
    end if
    call random_number(x_dp)
    call random_number(y_dp)

    call cpu_time(start_time)
    x_dp = alpha_dp*x_dp + y_dp 
    call cpu_time(end_time)
    print '(A, F12.6)', 'double precision: ', end_time - start_time
    print '(A, F25.15)', '    result: ', sum(x_dp)
    deallocate (x_dp, y_dp)

    ! mixed precision
    allocate (x_sp(nr_values), y_dp(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate x_sp/y_dp'
        stop 1
    end if
    call random_number(x_sp)
    call random_number(y_dp)

    call cpu_time(start_time)
    x_sp = alpha_dp*x_sp + y_dp 
    call cpu_time(end_time)
    print '(A, F12.6)', 'mixed precision: ', end_time - start_time
    print '(A, F15.6)', '    result: ', sum(x_sp)
    deallocate (x_sp, y_dp)

    ! mixed precision with conversion
    allocate (x_sp(nr_values), y_dp(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate x_sp/y_dp'
        stop 1
    end if
    call random_number(x_sp)
    call random_number(y_dp)

    call cpu_time(start_time)
    x_sp = alpha_sp*x_sp + real(y_dp, kind=kind(x_sp))
    call cpu_time(end_time)
    print '(A, F12.6)', 'mixed precision with conversion: ', end_time - start_time
    print '(A, F15.6)', '    result: ', sum(x_sp)
    deallocate (x_sp, y_dp)

    ! single precision, double constant
    allocate (x_sp(nr_values), y_sp(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate x_sp/y_sp'
        stop 1
    end if
    call random_number(x_sp)
    call random_number(y_sp)

    call cpu_time(start_time)
    x_sp = alpha_dp*x_sp + y_sp 
    call cpu_time(end_time)
    print '(A, F12.6)', 'single precision, double constant: ', end_time - start_time
    print '(A, F15.6)', '    result: ', sum(x_sp)
    deallocate (x_sp, y_sp)

    ! single precision
    allocate (x_sp(nr_values), y_sp(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate x_sp/y_sp'
        stop 1
    end if
    call random_number(x_sp)
    call random_number(y_sp)

    call cpu_time(start_time)
    x_sp = alpha_sp*x_sp + y_sp 
    call cpu_time(end_time)
    print '(A, F12.6)', 'single precision: ', end_time - start_time
    print '(A, F15.6)', '    result: ', sum(x_sp)
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
