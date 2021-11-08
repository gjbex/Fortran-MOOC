program create_wave
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none
    real(kind=DP) :: t_min, t_max, t_delta, t
    
    call get_arguments(t_min, t_max, t_delta)

    t = t_min
    do while (t <= t_max)
        print '(2E25.15)', t, wave(t)
        t = t + t_delta
    end do

contains

    subroutine get_arguments(t_min, t_max, t_delta)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real(kind=DP), intent(out) :: t_min, t_max, t_delta
        character(len=1024) :: buffer, msg
        integer :: istat

        if (command_argument_count() /= 3) then
            write (unit=error_unit, fmt='(A)') &
                '# error: expecting t_min, t_max, t_delta as arguments'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) t_min
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                '# error: ', trim(msg)
            stop 2
        end if
        call get_command_argument(2, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) t_max
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                '# error: ', trim(msg)
            stop 2
        end if
        call get_command_argument(3, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) t_delta
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                '# error: ', trim(msg)
            stop 2
        end if
    end subroutine get_arguments

    function wave(t) result(f)
        implicit none
        real(kind=DP), value :: t
        real(kind=DP) :: f
        real(kind=DP), parameter :: PI = 3.14159265358979_DP
        f = 2.0_DP*sin(3.0_DP*PI*t) + 0.5_DP*sin(5.0_DP*PI*t + PI/4_DP) + &
            1.0_DP*sin(7.0_DP*PI*t)
    end function wave

end program create_wave
