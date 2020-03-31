module julia_set_mod
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none

    private
    integer, parameter :: MAX_ITERS = 255
    real(kind=DP), parameter :: MAX_NORM = 2.0_DP
    complex(kind=DP), parameter :: C = cmplx(-0.622772_DP, &
                                              0.42193_DP, kind=DP)

    public :: julia_iterate

contains

    elemental function julia_iterate(z0) result(n)
        implicit none
        complex(kind=DP), intent(in) :: z0
        integer :: n
        complex(kind=DP) :: z
        z = z0
        n = 0
        do while (abs(z) < MAX_NORM .and. n < MAX_ITERS)
            z = z**2 + C
            n = n + 1
        end do
    end function julia_iterate

end module julia_set_mod
