program zero_vs_minus_zero
    implicit none
    real :: zero = 0.0, minus_zero

    minus_zero = sign(zero, -1.0)
    print '(A, 2F7.2)', '0 vs. -0: ', zero, minus_zero
    if (zero == minus_zero) then
        print '(A)', '0 == -0'
    else
        print '(A)', '0 / -0'
    end if
    print '(A, F5.1)', 'sqrt(0.0) = ', sqrt(zero)
    print '(A, F5.1)', 'sqrt(-0.0) = ', sqrt(minus_zero)
end program zero_vs_minus_zero
