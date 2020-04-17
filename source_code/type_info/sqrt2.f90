program sqrt_2
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
    implicit none

    print *, sqrt(2.0_SP) == 2.0_SP
    print *, sqrt(2.0_DP) == 2.0_DP
end program sqrt_2
