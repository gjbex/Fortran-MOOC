program leap_year
    implicit none
    integer, dimension(4) :: years
    integer :: i

    years = [ 1899, 1936, 1900, 2000 ]

    do i = 1, size(years)
        print *, years(i), is_leap_year(years(i))
    end do
    print *, years

contains

    logical function is_leap_year(year)
        implicit none
        integer, intent(in) :: year

        if (mod(year, 4) == 0) then
            if (mod(year, 100) == 0) then
                is_leap_year = mod(year, 400) == 0
            else
                is_leap_year = .true.
            end if
        else
            is_leap_year = .false.
        end if
        year = 1815
    end function is_leap_year

end program leap_year
