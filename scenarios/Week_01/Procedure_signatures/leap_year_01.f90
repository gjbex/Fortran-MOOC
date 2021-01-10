program leap_year
    implicit none

    print *, 1899, is_leap_year(1899)
    print *, 1936, is_leap_year(1936)
    print *, 1900, is_leap_year(1900)
    print *, 2000, is_leap_year(2000)
    print *, 1502, is_leap_year(1502)

contains

    logical function is_leap_year(year)
        implicit none
        integer :: year

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

