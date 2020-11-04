program random_integers
    implicit none
    integer :: nr_values, lower, upper, i

    call get_values(nr_values, lower, upper)
    do i = 1, nr_values
        print '(I0)', random_integer(lower, upper)
    end do

contains

    !> @brief copmute a random number in a given range
    !>
    !> The function returns a random integer value between a given lower and
    !> upper limits, inclusively.
    !>
    !> @param[in] lower lower value for the random value
    !> @param[in] upper upper value for the random value
    !> @returns integer value
    function random_integer(lower, upper) result(rand_int)
        implicit none
        integer, value :: lower, upper
        integer :: rand_int
        real :: rand_real

        call random_number(rand_real)
        rand_int = lower + floor(rand_real*(upper - lower + 1))
    end function random_integer

    subroutine get_values(nr_values, lower, upper)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: nr_values, lower, upper

        if (command_argument_count() /= 3) then
            write (unit=error_unit, fmt='(A)') &
                'error: argument nr_values lower upper expected'
            stop 1
        end if
        nr_values = get_integer(1)
        lower = get_integer(2)
        upper = get_integer(3)
        if (lower > upper) then
            write (unit=error_unit, fmt='(A)') &
                'error: upper should be larger or equal to lower'
            stop 3
        end if
    end subroutine get_values

    function get_integer(i) result(value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, value :: i
        integer :: value
        character(len=32) :: buffer
        integer :: istat
        character(len=1024) :: msg
        
        call get_command_argument(i, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) value
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', msg
            stop 2
        end if
    end function get_integer

end program random_integers
