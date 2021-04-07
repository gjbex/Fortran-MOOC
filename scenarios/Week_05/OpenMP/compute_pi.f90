program compute_pi
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    implicit none
    real, parameter :: PI = acos(-1.0)
    integer(kind=I8), parameter :: nr_tries = 500000000
    integer(kind=I8) :: nr_success, i
    integer :: num_threads = 1, thread_num = 0
    real :: x, y

    nr_success = 0
    do i = 1, nr_tries
        call random_number(x)
        call random_number(y)
        if (x**2 + y**2 <= 1.0) nr_success = nr_success + 1
    end do
    print '(A, F10.7)', 'sampled pi = ', 4.0*real(nr_success)/real(nr_tries)
    print '(A, F10.7)', 'real pi = ', PI
end program compute_pi
