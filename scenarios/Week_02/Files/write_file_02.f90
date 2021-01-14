program files
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_values = 10, io_error = 1
    character(len=50), parameter :: filename = 'data.txt'
    integer :: unit_nr, stat, i
    character(len=1024) :: msg
    real :: x = 5.1

    open (newunit=unit_nr, file=filename, access='sequential', &
          action='write', status='replace', form='formatted', &
          iostat=stat, iomsg=msg)
    if (stat /= 0) then
        write (unit=error_unit,fmt='(A)') msg
        stop io_error
    end if
    do i = 0, nr_values - 1
        write (unit=unit_nr, fmt='(F8.1)', iostat=stat, iomsg=msg) i*x
        if (stat /= 0) then
            write (unit=error_unit,fmt='(A)') msg
            stop io_error
        end if
    end do
    close (unit_nr, iostat=stat, iomsg=msg)
    if (stat /= 0) then
        write (unit=error_unit,fmt='(A)') msg
        stop io_error
    end if
                                    
end program files
