program ddot_timing
    use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
    implicit none
    integer :: n, runs, run, i, istat
    real(kind=DP), dimension(:), allocatable :: u, v
    real(kind=DP) :: scale_u, scale_v, r, r_ddot
    real(kind=DP), external :: ddot
    real :: start_time, end_time, ddot_time, loop_time


    call get_arguments(runs, n)
    allocate (u(n), v(n), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate vectors'
        stop 2
    end if

    do run = 1, runs
        scale_u = 1.17*run
        scale_v = 0.17*run
        do i = 1, n
            u(i) = scale_u*sqrt(real(i))/n
            v(i) = scale_v*sqrt(real(i))/n
        end do
        call cpu_time(start_time)
        r_ddot = ddot(n, u, 1, v, 1)
        call cpu_time(end_time)
        ddot_time = end_time - start_time
        call cpu_time(start_time)
        r = 0.0_DP
        do i = 1, n
            r = r + u(i)*v(i)
        end do
        call cpu_time(end_time)
        loop_time = end_time - start_time
        print '(A, F10.6, A, F10.6)', 'ddot time: ', ddot_time, &
                                      ', loop time: ', loop_time
    end do

    deallocate (u, v)

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
        n = 50000000
        if (command_argument_count() >= 2) then
            call get_command_argument(2, buffer)
            read (buffer, fmt=*) n
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 1
            end if
        end if
    end subroutine get_arguments

end program ddot_timing
