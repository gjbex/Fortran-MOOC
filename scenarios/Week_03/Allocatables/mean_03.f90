program mean
    use, intrinsic :: iso_fortran_env, only : error_unit, I8 => INT64
    implicit none
    integer, parameter :: nr_runs = 5
    integer(kind=I8) :: nr_values
    integer :: run
    real, dimension(:), pointer :: values
    
    call get_arguments(nr_values)

    do run = 1, nr_runs
        values => init_values(nr_values)
        print '(F10.3)', sum(values)/size(values)
    end do
    deallocate (values)

contains

    function init_values(nr_values) result(values)
        implicit none
        integer(kind=I8), value :: nr_values
        real, dimension(:), pointer :: values
        integer :: status

        allocate(values(nr_values), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A, I0, A)') &
                'error: can not allocate ', nr_values, ' values'
            stop 2
        end if
        call random_number(values)
    end function init_values

    subroutine get_arguments(nr_values)
        implicit none
        integer(kind=I8), intent(out) :: nr_values
        integer :: status
        character(len=1024) :: buffer, msg
        
        if (command_argument_count() == 1) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) nr_values
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
                stop 1
            end if
        else
            nr_values = 10
        end if
    end subroutine get_arguments

end program mean
