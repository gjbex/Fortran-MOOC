program test
    use, intrinsic :: iso_fortran_env
    use :: test_mod
    implicit none
    type(my_t) :: var

    var = my_t(3.5, 5.7)
    print '(dt)', var
    print *, var
    print '(dt(5, 2))', var
end program test
