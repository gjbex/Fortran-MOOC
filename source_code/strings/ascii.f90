program ascii
    implicit none
    integer :: i

    do i = iachar('A'), iachar('Z')
        print '(A, ": ", I0)', achar(i), i
    end do
end program ascii
