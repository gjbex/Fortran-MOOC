module functions_mod
    implicit none

    private
    public :: f1, f2

contains

    function f1(x) result(y)
        implicit none
        real, value :: x
        real :: y

        y = 2.0*x + 3.0
    end function f1

    function f2(x) result(y)
        implicit none
        real, value :: x
        real :: y

        y = 3.0*x + 1.0
    end function f2

end module functions_mod
