program direct_formaated_write
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: format_mod
    implicit none
    integer(kind=I4), parameter :: nr_recs = 11
    integer :: unit_nr
    integer(kind=I4) :: idx, istat
    real(kind=DP) :: x
    character(len=1024) :: msg, file_name

    if (command_argument_count() /= 1) then
        write (unit=error_unit, fmt='(A)') 'error: file name expected'
        stop 1
    end if
    call get_command_argument(1, file_name)
    open (newunit=unit_nr, file=trim(file_name), form='formatted', &
          access='direct', recl=rec_width, action='write', status='new', &
          iostat=istat, iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 2
    end if
    x = 0.5_DP
    do idx = nr_recs, 1, -1
        write (unit=unit_nr, fmt=fmt_str, rec=idx) idx, x
        x = x + 1.3_DP
    end do
    close (unit=unit_nr)

end program direct_formaated_write
