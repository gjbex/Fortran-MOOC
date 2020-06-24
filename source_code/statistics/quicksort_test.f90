program quicksort_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: quicksort_mod, only : qsort, lampsort
    implicit none
    integer, parameter, dimension(12) :: sizes = [ 0, 1, 2, 3, 5, 10, 100, 1000, &
                                                   10000, 100000, 1000000, 10000000 ]
    integer :: i
    real, dimension(:), allocatable :: qsort_values, lampsort_values
    real :: start_time, end_time, qsort_time, lampsort_time

    do i = 1, size(sizes)
        allocate(qsort_values(sizes(i)))
        if (.not. allocated(qsort_values)) then
            write (unit=error_unit, fmt='(A, I0)') &
                'error: can not allocate array of size ', sizes(i)
            stop 1
        end if
        allocate(lampsort_values(sizes(i)))
        if (.not. allocated(lampsort_values)) then
            write (unit=error_unit, fmt='(A, I0)') &
                'error: can not allocate array of size ', sizes(i)
            stop 1
        end if
        call random_number(qsort_values)
        lampsort_values = qsort_values
        call cpu_time(start_time)
        call qsort(qsort_values)
        call cpu_time(end_time)
        qsort_time = end_time - start_time
        call cpu_time(start_time)
        call lampsort(lampsort_values)
        call cpu_time(end_time)
        lampsort_time = end_time - start_time
        print '(I12, 2E15.6)', sizes(i), qsort_time, lampsort_time
        if (.not. is_sorted(qsort_values)) then
            write (unit=error_unit, fmt='(A)') &
                'error: array not sorted correctly by qsort'
            stop 2
        end if
        if (.not. is_sorted(lampsort_values)) then
            write (unit=error_unit, fmt='(A)') &
                'error: array not sorted correctly by lampsort'
            stop 2
        end if
        deallocate(qsort_values)
        deallocate(lampsort_values)
    end do

contains

    function is_sorted(values) result(sorted_value)
        implicit none
        real, dimension(:), intent(in) :: values
        logical :: sorted_value
        integer :: i

        sorted_value = .true.
        do i = 2, size(values)
            if (values(i) < values(i - 1)) then
                sorted_value = .false.
                exit
            end if
        end do
    end function is_sorted

end program quicksort_test
