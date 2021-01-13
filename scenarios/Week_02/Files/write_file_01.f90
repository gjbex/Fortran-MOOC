program files
    implicit none
    integer, parameter :: nr_values = 10
    character(len=50), parameter :: filename = 'data.txt'
    integer :: unit_nr, stat, i
    character(len=1024) :: msg
    real :: x = 5.1

    open (newunit=unit_nr, file=filename, access='sequential', &
          action='write', status='replace', form='formatted', &
          iostat=stat, iomsg=msg)
    do i = 0, nr_values - 1
        write (unit=unit_nr, fmt='(F3.1)') i*x
    end do
    close (unit_nr)
                                    
end program files
