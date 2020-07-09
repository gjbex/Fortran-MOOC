program newunit_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer :: unit_nr, istat
    character(len=1024) :: msg

    open (newunit=unit_nr, file='text.txt', access='sequential', action='write', &
          status='new', form='formatted', iostat=istat, iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 1
     end if
     write (unit=unit_nr, fmt='(A)') 'hello world!'
     close (unit=unit_nr)
end program newunit_test
