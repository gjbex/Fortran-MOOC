module primes_mod
    implicit none

    private
    public :: is_prime

contains

    function is_prime(n) result(prime)
        implicit none
        integer, value :: n
        logical :: prime
        integer :: i

        if (n > 1) then
            prime = .true.
            do i = 2, nint(sqrt(real(n)))
                if (mod(n, i) == 0) then
                    prime = .false.
                    exit
                end if
            end do
        else
            prime = .false.
        end if
    end function is_prime

end module primes_mod
