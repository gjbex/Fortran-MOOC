program fibonacci_test
    use, intrinsic :: iso_fortran_env, only : I8 => INT64, DP => REAL64, &
        output_unit
    use :: fib_mod
    implicit none
    integer(kind=I8) :: func_nr
    type :: func_t
        procedure(fib_func_t), nopass, pointer :: func => null()
    end type
    interface
        function fib_func_t(n) result(fib)
            use, intrinsic :: iso_fortran_env, only : I8 => INT64
            implicit none
            integer(kind=I8), value :: n
            integer(kind=I8) :: fib
        end function fib_func_t
    end interface
    real :: timing
    real(kind=DP) :: check_val
    integer, parameter :: nr_functions = 5
    type(func_t), dimension(nr_functions) :: functions
    character(len=15), dimension(nr_functions) :: names = [ &
            '      recursive', &
            '     skip ahead', &
            '       memoized', &
            '      iterative', &
            '    closed form'  &
        ]
    integer(kind=I8), dimension(5000) :: n_values
    real, dimension(5000) :: r

    functions(1)%func => fib_recursive
    functions(2)%func => fib_skip_ahead
    functions(3)%func => fib_memoization
    functions(4)%func => fib_iterative
    functions(5)%func => fib_closed_form

    call random_number(r)
    n_values = nint(r*5000, kind=I8)
    print '(A, I0, A)', 'random benchmark for ', 5000, ':'
    do func_nr = 2, nr_functions - 1
        write (unit=output_unit, fmt='(A15)', advance='no') names(func_nr)
        call run_random_benchmark(functions(func_nr)%func, n_values, &
                                  timing, check_val)
        print '(F15.7, E15.7)', timing, check_val
    end do

contains

    subroutine run_random_benchmark(fib_func, n_values, timing, check_val)
        implicit none
        procedure(fib_func_t) :: fib_func
        integer(kind=I8), dimension(:), intent(in) :: n_values
        real, intent(out) :: timing
        real(kind=DP), intent(out) :: check_val
        real :: start_time, end_time
        integer(kind=I8) :: i

        check_val = 0.0
        call cpu_time(start_time)
        do i = 1, size(n_values)
            check_val = check_val + real(fib_func(n_values(i)), kind=DP)
        end do
        call cpu_time(end_time)
        timing = end_time - start_time
    end subroutine run_random_benchmark

end program fibonacci_test
