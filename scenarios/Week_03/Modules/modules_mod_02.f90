module stats_mod
    implicit none

    private

    type, public :: stats_t
        real :: sum, sum2
        integer :: n
    end type stats_t

    public :: add_stats_value

contains

    subroutine add_stats_value(stats, value)
        implicit none
        type(stats_t), intent(inout) :: stats
        real, value :: value

        stats%sum = stats%sum + value
        stats%sum2 = stats%sum2 + value**2
        stats%n = stats%n + 1
    end subroutine add_stats_value

end module stats_mod
