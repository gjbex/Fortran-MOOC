program prime_test
    use :: primes_mod, only : is_prime
    implicit none
    integer, parameter :: max_value = 100
    integer :: n

    do n = 0, max_value
        if (is_prime(n)) print '(I4)', n
    end do
end program prime_test
