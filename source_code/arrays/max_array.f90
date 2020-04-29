program max_array
    implicit none
    integer, dimension(3, 4) :: A
    integer :: i, j
    character(len=10), parameter :: FMT = '(A, 4I13)'

    A = reshape( [ (((i - 1)*size(A, 2) + j, j=1,size(A, 2)), i=1,size(A, 1)) ], &
                shape(A)) - 8
    do i = 1, size(A, 1)
        print *, A(i, :)
    end do
    print FMT, 'maximum = ', maxval(A)
    print FMT, 'column maximum = ', maxval(A, dim=1)
    print FMT, 'row maximum = ', maxval(A, dim=2)
    print FMT, 'maximum odd elment = ', maxval(A, mask=mod(A, 2) /= 0)
    print FMT, 'row maximum negative elment = ', maxval(A, dim=1, mask=A < 0)
    print FMT, 'maxloc = ', maxloc(A)
    print FMT, 'column maxloc = ', maxloc(A, dim=1)
end program max_array
