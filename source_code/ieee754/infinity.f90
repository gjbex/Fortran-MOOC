program infinity
    use, intrinsic :: ieee_arithmetic
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none
    real :: r, x
    real(kind=DP) :: infty
    character(len=20) :: fmt_str = '(A20, E15.7)'

    x = 1.0e20**1.0e20
    print fmt_str, '1.0e20**1.0e20 =', x
    print fmt_str, '-1.0e20**1.0e20 =', -x
    if (ieee_is_finite(x)) then
        print '(A)', '1.0e20**1.0e20 is finite'
    else
        print '(A)', '1.0e20**1.0e20 is infinite'
    end if

    infty = ieee_value(0.0_DP, ieee_positive_inf)
    if (ieee_is_finite(infty)) then
        print '(A)', 'ieee_positive_inf is not infinite'
    else
        print '(A)', 'ieee_positive_inf is infinite'
    end if

    ! The compiler is fairly smart at figuring out when code will lead to
    ! overflow, so we have to deceive it.  Depending on the random value, the
    ! expression may sometimes evaluate to a finite value.
    call random_number(r)
    print fmt_str, '1.0/0.0 =', 1.0/(9.0e-37*r**30)
    print fmt_str, '-1.0/0.0 =', -1.0/(9.0e-37*r**30)
end program infinity
