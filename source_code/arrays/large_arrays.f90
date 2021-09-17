program large_arrays
    use, intrinsic :: iso_fortran_env, only : error_unit, I8 => INT64
    implicit none
    integer(kind=I8), parameter :: NR_VALUES = 10000000000000_I8
    integer(kind=I8), dimension(:), allocatable :: A

    allocate(A(NR_VALUES))

end program large_arrays
