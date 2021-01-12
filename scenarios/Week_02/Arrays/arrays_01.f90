program arrays
    implicit none
    real, dimension(3) :: vector

    vector(2) = 5.7
    vector(1) = 2*vector(2)
    print *, vector
end program arrays
