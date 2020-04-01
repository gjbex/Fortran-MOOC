program compute_distances
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, &
                                              input_unit, error_unit
    implicit none
    real(kind=DP) :: x1, y1, x2, y2
    integer :: status
    character(len=1024) :: msg
    
    do while (.true.)
        read (unit=input_unit, fmt=*, iostat=status, iomsg=msg) &
            x1, y1, x2, y2
        if (status < 0) exit
        if (status > 0) then
            write (unit=error_unit, fmt='(2A)') &
                'I/O error: ', msg
            stop 1
        end if
        print *, distance(x1, y1, x2, y2)
    end do

contains

    function distance(x1, y1, x2, y2) result(d)
        implicit none
        real(kind=DP), intent(in) :: x1, y1, x2, y2
        real(kind=DP) :: d

        d = sqrt((x1 - x2)**2 + (y1 - y2)**2)
    end function distance

end program compute_distances
