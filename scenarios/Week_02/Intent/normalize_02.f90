program normalize
    implicit none
    real, dimension(5) :: data = [ 3.1, -1.4, 2.8, 3.1, 9.2]

    print *, data
    call norm(data)
    print *, data
    print *, sum(data)

contains

    subroutine norm(array)
        implicit none
        real, dimension(:), intent(inout) :: array

        array = array/sum(array)
    end subroutine norm

end program normalize
