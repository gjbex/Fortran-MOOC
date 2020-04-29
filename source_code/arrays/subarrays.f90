program subarrays
    implicit none
    integer :: i
    integer, dimension(10) :: A = [ (i, i = 1, 10) ]
    character(len=10), parameter :: FMT = '(10I3)'

    print FMT, A
    print FMT, A(4:7)
    print FMT, A(:7)
    print FMT, A(4:)
    print FMT, A(4:7:2)
    print FMT, A(4::2)
    print FMT, A(:7:2)
    print FMT, A(7:4:-1)
end program subarrays
