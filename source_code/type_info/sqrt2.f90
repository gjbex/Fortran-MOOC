program sqrt_2
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
    implicit none
    real(kind=SP) :: sqr_root
    real(kind=DP) :: sqr_root_dp

    sqr_root = sqrt(2.0_SP)
    sqr_root_dp = sqrt(2.0_DP)
    print '(A, L)', 'sqrt(2)**2 == 2 (SP): ', sqr_root**2 == 2.0_SP
    print '(A, L)', 'sqrt(2)**2 =~ 2 (SP): ', abs(sqr_root**2 - 2.0_SP) <= 1.0e-6_SP
    print '(A, L)', 'sqrt(2)**2 == 2 (DP): ', sqr_root_dp**2 == 2.0_DP
    print '(A, L)', 'sqrt(2)**2 =~ 2 (DP): ', abs(sqr_root_dp**2 - 2.0_DP) <= 1.0e-14_DP
end program sqrt_2
