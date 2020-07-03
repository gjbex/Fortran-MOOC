program print_real_e
    implicit none
    real, dimension(10) :: values = [  1.23,  1.23e1,  1.23e5,  1.23e18, 1.23e-1, 1.23e-5, &
                                      -1.23, -1.23e1, -1.23e5, -1.23e18 ]
    integer :: i, fmt_nr
    character(len=10), dimension(5) :: fmts = [ &
        '(E10.3)', &
        '(E10.4)', &
        '(E4.3) ', &
        '(E0)   ', &
        '(E0.4) ' ]

    do fmt_nr = 1, size(fmts)
        print '(2A)', 'format ', fmts(fmt_nr)
        do i = 1, size(values)
            print fmts(fmt_nr), values(i)
        end do
    end do
end program print_real_e
