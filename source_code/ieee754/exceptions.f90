program exceptions
    use, intrinsic :: ieee_arithmetic
    implicit none
    logical :: halting_mode, stat
    logical, dimension(size(IEEE_USUAL)) :: stats
    real :: r

    ! show values of halting mode for IEEE exceptions
    call ieee_get_halting_mode(IEEE_DIVIDE_BY_ZERO, halting_mode)
    print '(A, L)', 'divide by zero halting mode: ', halting_mode
    call ieee_get_halting_mode(IEEE_INVALID, halting_mode)
    print '(A, L)', 'invalid halting mode: ', halting_mode
    call ieee_get_halting_mode(IEEE_OVERFLOW, halting_mode)
    print '(A, L)', 'overflow halting mode: ', halting_mode

    ! check the value of the the IEEE_INVALID
    call ieee_get_flag(IEEE_INVALID, stat)
    print '(A, L)', 'invalig flag = ', stat

    ! illustrate that the halting mode is .false. by default
    ! Note that the compiler will detect that the square root of a negative
    ! number results in NaN, so we outsmart it using a random number.
    call random_number(r)
    print '(A, F15.7)', 'sqrt(-1.0) = ', sqrt(r-1.0)
    
    ! check the value of the the IEEE_INVALID
    call ieee_get_flag(IEEE_INVALID, stat)
    print '(A, L)', 'invalig flag = ', stat

    ! check the usual suspects
    call ieee_get_flag(IEEE_USUAL, stats)
    print '(A, L)', 'usual flags = ', any(stats)

    ! set the halting mode for IEEE_INVALID to .true. and redo the computation
    ! it will crash this time
    call ieee_set_halting_mode(ieee_invalid, .true.)
    call ieee_get_halting_mode(ieee_invalid, halting_mode)
    print '(A, L)', 'invalid halting mode: ', halting_mode
    print '(A, F15.7)', 'sqrt(-1.0) = ', sqrt(r-1.0)
end program exceptions
