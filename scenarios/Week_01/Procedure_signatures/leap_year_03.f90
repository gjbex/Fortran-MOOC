program leap_year
    implicit none
    integer :: year

    year = 1899
    print *, year, is_leap_year(year)
    print *, 'year is now', year

contains

    logical function is_leap_year(year)
        implicit none
        integer, intent(in) :: year

        year = 1948
        if (year <= 1582) then
            print *, 'Gregorian calendar was not yet introduced'
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

