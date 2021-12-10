program elemental_subroutine
    implicit none
    real, dimension(3, 4) :: A, B, C
    integer :: i

    A = reshape([ (i, i=1, 12) ], shape(A))
    call compute(A, B, C)
    print '(A)', 'A'
    do i = 1, 3
        print '(*(F7.2))', A(i, :)
    end do

    print '(A)', 'B'
    do i = 1, 3
        print '(*(F7.2))', B(i, :)
    end do

    print '(A)', 'C'
    do i = 1, 3
        print '(*(F7.2))', C(i, :)
    end do

contains

    elemental subroutine compute(A, B, C)
        implicit none
        real, intent(in) :: A
        real, intent(out) :: B
        real, intent(out) :: C

        B = 2*A
        C = 3*A
    end subroutine compute

end program elemental_subroutine
