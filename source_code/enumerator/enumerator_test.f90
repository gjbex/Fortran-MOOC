program enumerator_test
    use, intrinsic :: iso_c_binding
    implicit none
    enum, bind(C)
        enumerator :: red, green, blue
    end enum
    integer(kind=c_int) :: color

    print *, red
    color = blue
    print *, color
end program enumerator_test
