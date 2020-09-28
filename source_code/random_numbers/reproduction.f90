program reproduction
    implicit none
    integer, parameter :: nr_vals = 5
    real, dimension(nr_vals) :: r
    
    call init_random()
    call random_number(r)
    print '(*(F12.7))', r

contains

    subroutine init_random()
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        character(len=1024) :: seed_file, msg
        integer :: seed_size, istat, clock, unit_nr
        integer, dimension(:), allocatable :: seed_vals

        call random_seed(size=seed_size)
        allocate (seed_vals(seed_size), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate seed values'
            stop 1
        end if

        if (command_argument_count() == 1) then
            call get_command_argument(1, seed_file)
            open (newunit=unit_nr, file=seed_file, form='formatted', &
                  access='sequential', action='read', status='old', &
                  iostat=istat, iomsg=msg)
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 2
            end if
            read (unit=unit_nr, fmt=*, iostat=istat, iomsg=msg) seed_vals
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 3
            end if
            close (unit=unit_nr)
            call random_seed(put=seed_vals)
        else
            call system_clock(count=clock)
            write (seed_file, fmt='(A, I0, A)') 'seed_', clock, '.txt'
            open (newunit=unit_nr, file=seed_file, form='formatted', &
                  access='sequential', action='write', status='new', &
                  iostat=istat, iomsg=msg)
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 4
            end if
            call random_seed(get=seed_vals)
            write (unit=unit_nr, fmt='(*(I12))', iostat=istat, iomsg=msg) seed_vals
            close (unit=unit_nr)
        end if

        deallocate (seed_vals)
    end subroutine init_random

end program reproduction
