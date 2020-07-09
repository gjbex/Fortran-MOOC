program append_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer :: unit_nr, istat
    character(len=1024) :: msg, file_name = 'text.txt'
    logical :: file_exists

    inquire (file=file_name, exist=file_exists)
    if (file_exists) then
        open (newunit=unit_nr, file=file_name, access='sequential', action='write', &
              status='old', form='formatted', position='append', &
              iostat=istat, iomsg=msg)
    else
        open (newunit=unit_nr, file=file_name, access='sequential', action='write', &
              status='new', form='formatted', iostat=istat, iomsg=msg)
    end if
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', msg
        stop 1
    end if
    write (unit=unit_nr, fmt='(A)') 'hello world!'
    close (unit=unit_nr)
end program append_test
