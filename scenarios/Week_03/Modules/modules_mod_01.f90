module stats_mod
    implicit none

    private

    type, public :: stats_t
        real :: sum, sum2
        integer :: n
    end type stats_t

end module stats_mod
