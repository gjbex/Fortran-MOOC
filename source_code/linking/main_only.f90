program main_only
    use :: functions_mod, only : f1
    implicit none
    real :: x = 13.0

    print *, f1(x)

end program main_only

