program next_up
    use, intrinsic :: ieee_arithmetic
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none
    real :: x, next_x
    integer :: e

    do e = -37, 37
        x = 10.0**e
        next_x = ieee_next_after(x, x + 1.0)
        print '(4E15.7)', x, next_x, next_x - x, (next_x - x)/x
    end do
end program next_up
