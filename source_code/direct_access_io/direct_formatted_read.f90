program direct_formatted_read
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: format_mod
    implicit none
    integer :: unit_nr, idx, istat, file_size, nr_records
    integer(kind=I4) :: i
    real(kind=DP) :: x
    character(len=1024) :: msg, file_name

    if (command_argument_count() /= 1) then
        write (unit=error_unit, fmt='(A)') 'error: file name expected'
        stop 1
    end if
    call get_command_argument(1, file_name)
    open (newunit=unit_nr, file=trim(file_name), form='formatted', &
          access='direct', recl=rec_width, action='read', status='old', &
          iostat=istat, iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 2
    end if
    inquire (unit=unit_nr, size=file_size)
    nr_records = file_size/rec_width

    do idx = nr_records, 1, -1
        read (unit=unit_nr, fmt=fmt_str, rec=idx, iostat=istat, iomsg=msg) i, x
        print '(A, I4, E15.6)', 'read: ', i, x
    end do
    close (unit=unit_nr)

end program direct_formatted_read
