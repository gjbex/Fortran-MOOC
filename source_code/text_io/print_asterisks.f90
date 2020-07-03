program print_asterisks
    implicit none
    integer :: i = 123456
    character(len=6) :: c = 'abcdef'

    print '(I8)', i
    print '(I4)', i

    print '(A8)', c
    print '(A4)', c

end program print_asterisks
