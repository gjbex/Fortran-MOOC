program fibonacci_test
    use, intrinsic :: iso_fortran_env, only : I8 => INT64, output_unit
    use :: fib_mod
    implicit none
    integer(kind=I8), parameter :: n_max = 15
    integer(kind=I8) :: n, func_nr
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
    integer, parameter :: nr_functions = 5
    type(func_t), dimension(nr_functions) :: functions
    character(len=15), dimension(nr_functions) :: names = [ &
            '      recursive', &
            '     skip ahead', &
            '       memoized', &
            '      iterative', &
            '    closed form'  &
        ]

    functions(1)%func => fib_recursive
    functions(2)%func => fib_skip_ahead
    functions(3)%func => fib_memoization
    functions(4)%func => fib_iterative
    functions(5)%func => fib_closed_form

    print '(A)', 'sanity check:'
    print '(6A15)', 'n', names
    do n = 0, n_max
        write (unit=output_unit, fmt='(I15)', advance='no') n
        do func_nr = 1, nr_functions
            write (unit=output_unit, fmt='(I15)', advance='no') &
                functions(func_nr)%func(n)
        end do
        print '(A)', ''
    end do

    print '(A)', 'check for closed form:'
    n = 0
    do while (fib_memoization(n) == fib_closed_form(n))
        n = n + 1
    end do
    print '(A, I0)', 'closed form breaks for ', n

end program fibonacci_test
