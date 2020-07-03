program print_test
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
    implicit none
    integer, parameter :: n = 15
    real(kind=SP), parameter :: x = 3.14_SP
    real(kind=DP), parameter :: y = 2.69_DP
    character(len=10), parameter :: c = 'abc'
    logical, parameter :: l = .true.
    type udf
        real :: x
        integer :: n
    end type udf
    type(udf) :: u
    real, dimension(3) :: v = [ 3.5, 5.7, 7.3 ]
    integer, dimension(2, 3) :: A = reshape( [ 3, 7, 5, 9, 2, 4 ], [ 2, 3 ])
    u = udf(x = 3.5, n = 7)

    print *, '|', n, '|'
    print *, '|', x, '|'
    print *, '|', y, '|'
    print *, '|', c, '|'
    print *, '|', l, '|'
    print *, '|', u, '|'
    print *, '|', v, '|'
    print *, '|', A, '|'
end program print_test
