program arrays
    implicit none
    real, dimension(3) :: coords

    coords = 1.0
    print *, coords
    coords(2) = 5.7
    coords(1) = 2*coords(2)
    print *, coords
    print *, 3.0 + coords
    print *, 2.5*coords
    print *, coords**2
    print *, dot_product(coords, coords)
end program arrays
