program print_logicals
    implicit none
    logical :: l = .false.
    integer :: width
    character(len=10) :: fmt

    do width = 1, 6
        write (fmt, "('(L', I0, ')')") width
        print fmt, l
    end do
end program print_logicals
