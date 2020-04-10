program ball_throw
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, INT32
    use :: rk4_mod, only  : rk4vec
    implicit none
    integer, parameter :: NR_EQS = 4
    integer, parameter :: MAX_STEPS = 10000
    real(kind=DP), parameter :: DELTA_T = 0.01_DP
    real(kind=DP) :: t
    real(kind=DP), dimension(NR_EQS) :: u, u_new
    integer :: step

#define X u(1)
#define Y u(2)
#define VX u(3)
#define VY u(4)

    step = 0
    t = 0.0_DP
    X = 0.0_DP
    Y = 0.0_DP
    VX = 5.0_DP
    VY = 5.0_DP
    print *, step, t, X, Y, VX, VY
    do step = 1, MAX_STEPS
        call rk4vec(t, NR_EQS, u, DELTA_T, rhs, u_new)
        t = t + DELTA_T
        u = u_new
        if (Y < 0.0_DP) exit
        print *, step, t, X, Y, VX, VY
    end do

contains

#define X_prime  u_prime(1)
#define Y_prime  u_prime(2)
#define VX_prime u_prime(3)
#define VY_prime u_prime(4)

    subroutine rhs(t, n, u, u_prime)
        implicit none
        real(kind=DP), intent(in) :: t
        integer(kind=INT32) :: n
        real(kind=DP), dimension(n), intent(in) :: u
        real(kind=DP), dimension(n), intent(out) :: u_prime

        X_prime = VX
        Y_prime = VY
        VX_prime = 0.0_DP
        VY_prime = -9.81_DP
    end subroutine rhs

end program ball_throw
