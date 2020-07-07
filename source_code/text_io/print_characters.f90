program print_characters
    implicit none
    character(len=6) :: c = 'abcdef'
    integer :: width
    character(len=10) :: fmt

    do width = 2, 8
        write (fmt, "('(A', I0, ')')") width
        print fmt, c
    end do
end program print_characters
