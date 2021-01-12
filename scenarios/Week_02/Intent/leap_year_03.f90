program leap_year
    implicit none
    integer, dimension(5) :: years
    integer :: i
    logical :: error

    years = [ 1899, 1936, 1900, 2000, 1504 ]

    do i = 1, size(years)
        print *, years(i), is_leap_year(years(i), error)
        if (error) then
            print *, years(i), 'predates Gregorian calendar'
        end if
    end do
    print *, years

contains

    logical function is_leap_year(year, error)
        implicit none
        integer, intent(in) :: year
        logical, intent(out) :: error

        error = year <= 1582
        if (mod(year, 4) == 0) then
            if (mod(year, 100) == 0) then
                is_leap_year = mod(year, 400) == 0
            else
                is_leap_year = .true.
            end if
        else
            is_leap_year = .false.
        end if
    end function is_leap_year

end program leap_year
