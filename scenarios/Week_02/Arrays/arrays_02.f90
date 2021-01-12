program arrays
    implicit none
    real, dimension(3) :: vector

    vector = 1.0
    print *, vector
    vector(2) = 5.7
    vector(1) = 2*vector(2)
    print *, vector
    print *, 3.0 + vector
    print *, 2.5*vector
end program arrays
