program median_statistics
    use, intrinsic :: iso_fortran_env, only : error_unit, input_unit
    implicit none
    integer :: nr_values

    nr_values = get_command_llne_values()
    print '(A, E12.5)', 'median = ', compute_median(input_unit, nr_values)

contains

    function compute_median(unit_nr, nr_values) result(median_value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        use :: quicksort_mod, only : qsort
        implicit none
        integer, value :: unit_nr, nr_values
        real :: median_value
        real, dimension(:), allocatable :: values
        integer :: i, istat
        character(len=1024) :: msg

        allocate (values(nr_values))
        if (.not. allocated(values)) then
            write (unit=error_unit, fmt='(A, I0)') &
                'error: can not allocate array of size ', nr_values
            stop 1
        end if
        do i = 1, nr_values
            read (unit=unit_nr, fmt=*, iostat=istat, iomsg=msg) values(i)
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') &
                    'error: I/O error ', trim(msg)
                stop 2
            end if
        end do
        call qsort(values)
        if (mod(nr_values, 2) == 0) then
            median_value = 0.5*(values(nr_values/2) + values(nr_values/2 + 1))
        else
            median_value = values(nr_values/2 + 1)
        end if
        deallocate (values)
    end function compute_median

    function get_command_llne_values() result(nr_values)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer :: nr_values
        character(len=1024) :: buffer

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                'error: number of values required as argument'
            stop 5
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*) nr_values
    end function get_command_llne_values

end program median_statistics
