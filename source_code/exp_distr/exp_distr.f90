program exp_distr_program
    implicit none
    integer, parameter :: NR_VALUES = 1000
    integer :: i

    do i = 1, NR_VALUES
        print *, get_exp_rand()
    end do

contains

    function get_exp_rand() result(val)
        implicit none
        real :: val
        real, save :: next_val
        logical, save :: is_next_set = .false.
        real :: x, y, radius, factor

        if (is_next_set) then
            is_next_set = .false.
            val = next_val
        else
            do while (.not. is_next_set)
                call random_number(x) 
                call random_number(y) 
                x = 2.0*x - 1.0
                y = 2.0*y - 1.0
                radius = x**2 + y**2
                if (0.0 < radius .and. radius <= 1.0) exit
            end do
            factor = sqrt(-2.0*log(radius)/radius)
            val = x*factor
            next_val =y*factor
            is_next_set = .true.
        end if
    end function get_exp_rand

end program exp_distr_program
