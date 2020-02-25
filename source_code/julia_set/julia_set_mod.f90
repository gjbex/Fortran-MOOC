module julia_set_mod
    use, intrinsic :: iso_fortran_env, only : dp => REAL64
    implicit none

    private
    integer, parameter :: max_iters = 255
    real(kind=dp), parameter :: max_norm = 2.0_dp
    complex(kind=dp), parameter :: C = cmplx(-0.622772_dp, 0.42193_dp, kind=dp)

    public :: julia_iterate

contains

    elemental function julia_iterate(z0) result(n)
        implicit none
        complex(kind=dp), intent(in) :: z0
        integer :: n
        complex(kind=dp) :: z
        z = z0
        n = 0
        do while (abs(z) < max_norm .and. n < max_iters)
            z = z**2 + C
            n = n + 1
        end do
    end function julia_iterate

end module julia_set_mod
