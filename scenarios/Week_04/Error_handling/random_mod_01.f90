module random_mod
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    implicit none

    private

    public :: random_bitvector

contains

    function random_bitvector(n) result(vector)
        implicit none
        integer(kind=I8), value :: n
        logical, dimension(:), allocatable :: vector
        real, dimension(:), allocatable :: real_vector

        allocate (real_vector(n))
        allocate (vector(n))
        call random_number(real_vector)
        vector = real_vector < 0.5
        deallocate (real_vector)
    end function random_bitvector

end module random_mod
