program print_integers
    implicit none
    integer, dimension(12) :: values = [ 1,  12,  123,  1234,  12345,  123456, &
                                        -1, -12, -123, -1234, -12345, -123456 ]
    integer :: i, fmt_nr
    character(len=20), dimension(5) :: fmts = [ '(I5)  ', '(I5.3)', &
                                                '(I0)  ', '(I0.3)', '(I0.0)' ]
    
    do fmt_nr = 1, size(fmts)
        print '(2A)', 'format ', fmts(fmt_nr)
        do i = 1, size(values)
            print fmts(fmt_nr), values(i)
        end do
    end do

end program print_integers
