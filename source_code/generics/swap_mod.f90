module swap_mod
    implicit none

    private
    public :: swap

    interface swap
        module procedure real_swap
        module procedure int_swap
    end interface swap

contains

    subroutine real_swap(a, b)
        implicit none
        real, intent(inout) :: a, b
        real :: tmp

        tmp = a
        a = b
        b = tmp
    end subroutine real_swap

    subroutine int_swap(a, b)
        implicit none
        integer, intent(inout) :: a, b
        integer :: tmp

        tmp = a
        a = b
        b = tmp
    end subroutine int_swap

end module swap_mod
