program arrays
    implicit none
    integer :: i
    real, dimension(3) :: vector1, vector2

    vector1 = [ 3.0, 5.0, 7.0 ]
    vector2 = [ (0.5*i - 1.0, i=1, 3) ]
    print *, vector1
    print *, vector2
    print *, vector1 + vector2
    print *, vector1*vector2
    print *, dot_product(vector1, vector2)
    print *, size(vector1)
    print *, sum(vector1)
end program arrays
