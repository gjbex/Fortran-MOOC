program compute_pi
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    implicit none
    real, parameter :: PI = acos(-1.0)
    integer(kind=I8), parameter :: nr_tries = 500000000
    integer(kind=I8), codimension[*] :: nr_success
    integer(Kind=I8) :: i
    real :: x, y

    nr_success = 0
    if (this_image() == 1) &
        print '(A, I0, A)', 'running with ', num_images(), ' images'
    do i = 1, nr_tries/num_images()
        call random_number(x)
        call random_number(y)
        if (x**2 + y**2 <= 1.0) nr_success = nr_success + 1
    end do
    sync all
    call co_sum(nr_success, result_image=1)
    if (this_image() == 1) then
        print '(A, F10.7)', 'sampled pi = ', 4.0*real(nr_success)/real(nr_tries)
        print '(A, F10.7)', 'real pi = ', PI
    end if
end program compute_pi
