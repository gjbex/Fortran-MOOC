program diffusion
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64, error_unit
    use :: diffusion_mod
    implicit none
    integer, parameter :: max_steps = 1000
    integer :: n
    real(kind=SP), dimension(:, :), allocatable :: temp, new_temp
    real(kind=SP) :: error
    integer :: step_nr
    real(kind=DP) :: start_time, stop_time

    call get_arguments(n)
    call init_system(n, temp, new_temp)

    call cpu_time(start_time)
    do step_nr = 1, max_steps
          call diffusion_step(temp, new_temp, error)
          if (mod(step_nr, 100) == 0) &
              print '(A, I0, A, E10.3)', 'step ', step_nr, ': ', error
          call swap(new_temp, temp)
    end do
    call cpu_time(stop_time)
    if (n <= 10) call print_system(temp)
    call dealloc_system(temp, new_temp)
    print '(A, E15.7)', 'time = ', stop_time - start_time

contains

    subroutine get_arguments(n)
        implicit none
        integer, intent(out) :: n
        character(len=128) :: buffer, msg
        integer :: istat

        if (command_argument_count() < 1) then
            n = 10
        else
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iomsg=msg, iostat=istat) n
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') &
                    'error: ', trim(msg)
                stop 2
            end if
        end if
    end subroutine get_arguments

end program diffusion
