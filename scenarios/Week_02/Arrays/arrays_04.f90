program arrays
    implicit none
    integer :: i
    real, dimension(3) :: coords1, coords2

    coords1 = [ 3.0, 5.0, 7.0 ]
    coords2 = [ (0.5*i - 1.0, i=1, 3) ]
    print *, coords1
    print *, coords2
    print *, coords1 + coords2
    print *, coords1*coords2
    print *, dot_product(coords1, coords2)
    print *, size(coords1)
    print *, sum(coords1)
end program arrays
