program create_lookup_table
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, dimension(256) :: lookup_table
    character(len=1024) :: file_name, msg
    integer :: i, unit_nr, istat

    lookup_table = init_lookup_table()
    if (command_argument_count() /= 1) then
        write (unit=error_unit, fmt='(A)') 'error: expacting file name as argument'
        stop 1
    end if
    call get_command_argument(1, file_name)
    open (newunit=unit_nr, file=trim(file_name), status='replace', &
        access='sequential', form='formatted', iostat=istat, iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 1
    end if
    do i = 1, 15
        write (unit=unit_nr, fmt='("        ", 16(I3, ","), " &")') &
            lookup_table((i - 1)*16 + 1:i*16) 
    end do
    write (unit=unit_nr, fmt='("        ", 15(I3, ","))', advance='no') &
                lookup_table(15*16 + 1:16*16 - 1) 
    write (unit=unit_nr, fmt='(I3, " &")') lookup_table(256)
    close (unit=unit_nr)

contains

    function init_lookup_table() result(lookup_table)
        implicit none
        integer, dimension(0:255) :: lookup_table
        integer :: i

        lookup_table(0) = 0
        do i = 1, 255
            lookup_table(i) = and(i, 1) + lookup_table(i/2)
        end do
    end function init_lookup_table

end program create_lookup_table
