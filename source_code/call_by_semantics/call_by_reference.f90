program call_by_reference
    implicit none
    integer :: m
    m = 5
    print *, m
    call increment(m)
    print *, m

contains

    subroutine increment(n)
        implicit none
        integer, intent(inout) :: n

        n = n + 1
    end subroutine increment

end program call_by_reference
