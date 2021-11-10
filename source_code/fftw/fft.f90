program fft
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    include 'fftw3.f03'
    real(kind=C_DOUBLE), dimension(:), allocatable :: time, data
    complex(kind=C_DOUBLE_COMPLEX), dimension(:), allocatable :: fft_result
    character(len=1024) :: file_name

    call get_arguments(file_name)
    call read_data(file_name, time, data)
    print *, time
    print *, data

contains

    subroutine get_arguments(file_name)
        implicit none
        character(len=*), intent(out) :: file_name

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                '# error: expecting data file name'
            stop 1
        end if
        call get_command_argument(1, file_name)
    end subroutine get_arguments

    subroutine read_data(file_name, time, data)
        use, intrinsic :: iso_fortran_env, only : iostat_end
        implicit none
        character(len=*), intent(in) :: file_name
        real(kind=C_DOUBLE), dimension(:), allocatable, intent(out) :: time, data
        integer :: unit_nr, istat, i, nr_data
        character(len=1024) :: msg, buffer

        open (newunit=unit_nr, file=trim(file_name), access='sequential', &
              action='read', status='old', form='formatted', &
              iomsg=msg, iostat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                '# error: ', trim(msg)
            stop 2
        end if
        nr_data = 0
        do
            read (unit=unit_nr, fmt='(A)', iostat=istat) buffer
            if (istat == iostat_end) then
                exit
            else
                nr_data = nr_data + 1
            end if
        end do
        allocate (time(nr_data), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A, I0)') &
                '# error: can not allocate time array of size ', nr_data
            stop 3
        end if
        allocate (data(nr_data), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A, I0)') &
                '# error: can not allocate data array of size ', nr_data
            stop 3
        end if

        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                '# error: ', trim(msg)
            stop 2
        end if
        rewind (unit=unit_nr)
        do i = 1, nr_data
            read (unit=unit_nr, fmt=*, iomsg=msg, iostat=istat) time(i), data(i)
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') &
                    '# error: ', trim(msg)
                stop 4
            end if
        end do
        end subroutine read_data

end program fft
