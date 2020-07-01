program swap_test
    use :: swap_mod, only : swap
    implicit none
    real :: a = 3.1, b = 4.5
    integer :: i = 13, j = 11
    character(len=20), parameter :: real_fmt = '(A, 2F7.1)'
    character(len=20), parameter :: int_fmt = '(A, 2I3)'

    ! swap on real values
    print real_fmt, 'before', a, b
    call swap(a, b)
    print real_fmt, 'after', a, b

    ! swap on integer values
    print int_fmt, 'before', i, j
    call swap(i, j)
    print int_fmt, 'after', i, j
end program swap_test
