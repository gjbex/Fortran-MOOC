program generate_random_sync
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer :: nr_values, buffer_size, unit_nr, istat, i, remainder
    real, dimension(:), allocatable, asynchronous :: buffer1, buffer2
    character(len=1024) :: file_name, msg

    call get_arguments(nr_values, buffer_size, file_name)

    ! allocate buffers
    allocate (buffer1(buffer_size), buffer2(buffer_size), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate buffers'
        stop 3
    end if

    ! open file
    open (newunit=unit_nr, file=file_name, form='unformatted', &
          action='write', access='stream', status='replace', &
          iostat=istat, iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 4
    end if

    do i = 1, nr_values/(2*size(buffer1))
        call random_number(buffer1)
        write (unit=unit_nr) buffer1
        call random_number(buffer2)
        write (unit=unit_nr) buffer2
    end do

    remainder = mod(nr_values, 2*size(buffer1))
    if (remainder /= 0) then
        call random_number(buffer1(1:remainder))
        write (unit=unit_nr) buffer1(1:remainder)
    end if

    close (unit_nr)
    deallocate (buffer1, buffer2)

contains

    subroutine get_arguments(nr_values, buffer_size, file_name)
        implicit none
        integer, intent(out) :: nr_values, buffer_size
        character(len=*), intent(out) :: file_name
        character(len=128) :: buffer, msg
        integer :: istat

        if (command_argument_count() /= 3) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting number of values, buffer size and file name as arguments'
            stop 1
        end if

        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iomsg=msg, iostat=istat) nr_values
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
        call get_command_argument(2, buffer)
        read (buffer, fmt=*, iomsg=msg, iostat=istat) buffer_size
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
        call get_command_argument(3, file_name)
    end subroutine get_arguments

end program generate_random_sync
