program leapyear
    implicit none
    integer :: year

    year = get_year()
    if (is_leapyear(year)) then
        print '(I0, A)', year, ' is a leap year'
    else
        print '(I0, A)', year, ' is not a leap year'
    end if

contains

    integer function get_year()
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        character(len=256) :: buffer
        
        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting a year as argument'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, '(I10)') get_year
    end function get_year

    logical function is_leapyear(year)
        implicit none
        integer, intent(in) :: year

        if (mod(year, 4) /= 0) then
            is_leapyear = .false.
        else if (mod(year, 100) == 0) then
            if (mod(year, 400) == 0) then
                is_leapyear = .true.
            else
                is_leapyear = .false.
            end if
        else
            is_leapyear = .true.
        end if
    end function is_leapyear

end program leapyear
