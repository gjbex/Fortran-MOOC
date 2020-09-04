program nans
    use, intrinsic :: ieee_arithmetic
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none
    real :: r, x
    real(kind=DP) :: nan
    character(len=20) :: fmt_str = '(A15, F15.7)'

    ! The compiler will generate errors for expressions that generate
    ! obvious NaNs, so we have to trick it using random numbers.
    x = 1.0
    call random_number(r)
    if (r > 1.0e-38) x = -1.0
    print fmt_str, 'sqrt(-1.0) =', sqrt(x)
    if (r > 1.0e-38) x = 0.0
    print fmt_str, '0.0/0.0 =', 0.0/x

    nan = ieee_value(0.0_DP, ieee_quiet_nan)
    if (nan /= nan) then
        print '(A)', 'NaN is not equal to itself'
    else
        print '(A)', 'NaN should be equal to itself'
    end if
    if (ieee_is_nan(nan)) then
        print '(A)', 'NaN is NaN'
    else
        print '(A)', 'NaN is not NaN'
    end if

end program nans
