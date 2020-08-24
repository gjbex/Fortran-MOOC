module utilities_mod
    implicit none

    private

    public :: fisher_yates_shuffle

contains

    subroutine fisher_yates_shuffle(values)
        implicit none
        integer, dimension(:), intent(inout) :: values
        integer :: i, j, tmp
        real :: r
        
        do i = 1, size(values) - 1
            call random_number(r)
            j = i + floor(r*(size(values) - i + 1))
            tmp = values(i)
            values(i) = values(j)
            values(j) = tmp
        end do
    end subroutine fisher_yates_shuffle

end module utilities_mod
