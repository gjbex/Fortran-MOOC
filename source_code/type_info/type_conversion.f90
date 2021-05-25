program type_conversion
    use, intrinsic :: iso_fortran_env, only : &
        SP => REAL32, DP => REAL64, &
        I32 => INT32, I64 => INT64
    implicit none
    real(kind=SP) :: x_sp
    real(kind=DP) :: x_dp
    integer(kind=i32) :: i_I32
    integer(kind=i64) :: i_I64

    x_dp = 1.0e100_DP
    x_sp = real(x_dp, kind=SP)
    print *, x_sp

    i_i64 = 2**40
    i_I32 = int(i_I64, kind=I32)
    print *, i_I32
end program type_conversion
