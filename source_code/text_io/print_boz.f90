program print_boz
    implicit none
    integer :: i = 13
    real :: x = 1.25e+3

    print '(I10, B32)', i, i
    print '(I10, O32)', i, i
    print '(I10, Z32)', i, i
    print '(E10.3, B32)', x, x
end program print_boz
