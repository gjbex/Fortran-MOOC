program benchmark
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none

    interface
        function func_impl_t(x) result(res)
            use, intrinsic :: iso_fortran_env, only : DP => REAL64
            implicit none
            real(kind=DP), intent(in) :: x
            real(kind=DP) :: res
        end function func_impl_t
    end interface
    type :: func_t
        character(len=20) :: name
        procedure(func_impl_t), nopass, pointer :: func
    end type
    type(func_t), dimension(4) :: functions
    real :: timing
    real(kind=DP) :: res
    integer :: i

    functions(1)%name = 'sin'
    functions(1)%func => dsin
    functions(2)%name = 'cos'
    functions(2)%func => dcos
    functions(3)%name = 'tan'
    functions(3)%func => dtan
    functions(4)%name = 'sqrt'
    functions(4)%func => dsqrt

    do i = 1, size(functions)
        call run_benchmark(functions(i)%func, timing, res)
        print '(A, F12.7, E15.7)', functions(i)%name, timing, res
    end do

contains

    subroutine run_benchmark(func, timing, res)
        implicit none
        procedure(func_impl_t) :: func
        real, intent(out) :: timing
        real(kind=DP) :: res
        integer, parameter :: nr_runs = 10000000
        real :: start_time, end_time
        real(kind=DP) :: x, delta = 1.0/nr_runs
        integer :: i

        res = 0.0
        x = 0.0
        call cpu_time(start_time)
        do i = 1, nr_runs
            res = res + func(x)
            x = x + delta
        end do
        call cpu_time(end_time)
        timing = end_time - start_time
        res = res/nr_runs
    end subroutine run_benchmark

end program benchmark
