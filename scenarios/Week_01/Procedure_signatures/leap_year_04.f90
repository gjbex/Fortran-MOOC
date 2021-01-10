program leap_year
    implicit none
    integer :: year
    logical :: has_error

    year = 1899
    print *, year, is_leap_year(year)
    print *, 'year is now', year
    print *, 1448, is_leap_year(1448, has_error)
    if (has_error) &
        print *, 'opsie'

contains

    logical function is_leap_year(year, has_error)
        implicit none
        integer, intent(in) :: year
        logical, optional, intent(out) :: has_error

        if (present(has_error)) then
            has_error = year <= 1582
        end if
        if (mod(year, 4) == 0) then
            if (mod(year, 100) == 0) then
                if (mod(year, 400) == 0) then
                    is_leap_year = .false.
                else
                    is_leap_year = .true.
                end if
            else
                is_leap_year = .true.
            end if
        else
            is_leap_year = .false.
        end if
    end function is_leap_year

end program leap_year

