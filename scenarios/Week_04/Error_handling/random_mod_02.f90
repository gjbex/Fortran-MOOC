module random_mod
    use, intrinsic :: iso_fortran_env, only : I8 => INT64, error_unit
    implicit none

    private

    public :: random_bitvector

contains

    function random_bitvector(n) result(vector)
        implicit none
        integer(kind=I8), value :: n
        logical, dimension(:), allocatable :: vector
        real, dimension(:), allocatable :: real_vector
        integer :: status

        allocate (real_vector(n), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocated temporary vector'
            stop 10
        end if
        allocate (vector(n), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocated bitvector'
            stop 10
        end if
        call random_number(real_vector)
        vector = real_vector < 0.5
        deallocate (real_vector)
    end function random_bitvector

end module random_mod
