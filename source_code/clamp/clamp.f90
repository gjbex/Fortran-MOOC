program clamp_program
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, &
                                              input_unit, error_unit
    implicit none
    real(kind=DP) :: min_val, max_val
    real(kind=DP) :: val
    integer :: status
    character(len=1024) :: msg

    call get_limits(min_val, max_val)
    do
        read (unit=input_unit, fmt=*, iostat=status, iomsg=msg) val 
        if (status < 0) exit
        call check_status(status, msg)
        call clamp(val, min_val, max_val)
        print *, val
    end do

contains

    subroutine check_status(status, msg)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(in) :: status
        character(len=*), intent(in) :: msg
        
        if (status > 0) then
            write (unit=error_unit, fmt='(2A)') &
                'I/O error: ', trim(msg)
            stop status
        end if
    end subroutine check_status

    subroutine get_limits(min_val, max_val)
        implicit none
        real(kind=DP), intent(out) :: min_val, max_val
        character(len=1024) :: buffer
        integer :: status
        character(len=1024) :: msg

        if (command_argument_count() == 0) then
            max_val = 1.0_DP
        else if (command_argument_count() >= 1) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) max_val
            call check_status(status, msg)
        end if
        if (command_argument_count() == 2) then
            min_val = max_val
            call get_command_argument(2, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) max_val
            call check_status(status, msg)
        else
            min_val = -max_val
        end if
    end subroutine get_limits

    subroutine clamp(val, min_val, max_val)
        implicit none
        real(kind=DP), intent(inout) :: val
        real(kind=DP), intent(in) :: min_val, max_val

        if (val < min_val) then
            val = min_val
        else if (max_val < val) then
            val = max_val
        end if
    end subroutine clamp

end program clamp_program
