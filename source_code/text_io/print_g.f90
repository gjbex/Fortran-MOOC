program print_g
    implicit none
    real, dimension(10) :: values = [  1.23,  1.23e1,  1.23e5,  1.23e18, 1.23e-1, 1.23e-5, &
                                      -1.23, -1.23e1, -1.23e5, -1.23e18 ]
    integer :: i, fmt_nr
    character(len=10), dimension(5) :: fmts = [ &
        '(G10.3)', &
        '(G10.4)', &
        '(G4.3) ', &
        '(G0)   ', &
        '(G0.4) ' ]

    print '(G10.0)', 1234

    do fmt_nr = 1, size(fmts)
        print '(2A)', 'format ', fmts(fmt_nr)
        do i = 1, size(values)
            print fmts(fmt_nr), values(i)
        end do
    end do

    print '(2G0)', 3.5, 5.7

    print '(G0)', .true.

    print '(G0)', 'abcdef'

end program print_g
