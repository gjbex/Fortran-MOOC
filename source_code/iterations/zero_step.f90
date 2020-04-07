program zero_step
    implicit none
    integer :: i

    do i = 1, 5, compute_step(0)
        print *, i
    end do

contains

    function compute_step(limit) result(step)
        implicit none
        integer, intent(in) :: limit
        integer :: step
        integer :: i

        do i = 10, limit, -1
            step = i
        end do
    end function compute_step

end program zero_step
