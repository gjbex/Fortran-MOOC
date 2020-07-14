program quicksort_test
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only : error_unit, INT64
    use :: quicksort_mod, only : qsort, lampsort
    implicit none
    integer, parameter, dimension(12) :: sizes = [ 0, 1, 2, 3, 5, 10, 100, 1000, &
                                                   10000, 100000, 1000000, 10000000 ]
    integer :: i
    real, dimension(:), allocatable :: qsort_values, lampsort_values
    real, dimension(:), allocatable, target :: c_qsort_values
    real :: start_time, end_time, qsort_time, lampsort_time, c_qsort_time
    interface
        subroutine c_qsort(base, nmemb, type_size, cmp) bind(c, name='qsort')
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), value :: base
            integer(kind=c_size_t), value :: nmemb, type_size
            type(c_funptr), value :: cmp
        end subroutine c_qsort
    end interface

    do i = 1, size(sizes)
        allocate (qsort_values(sizes(i)), lampsort_values(sizes(i)), &
                  c_qsort_values(sizes(i)))
        if (.not. allocated(qsort_values) .or. .not. allocated(lampsort_values) .or. &
            .not. allocated(c_qsort_values)) then
            write (unit=error_unit, fmt='(A, I0)') &
                'error: can not allocate array of size ', sizes(i)
            stop 1
        end if
        call random_number(qsort_values)
        lampsort_values = qsort_values
        c_qsort_values = qsort_values
        call cpu_time(start_time)
        call qsort(qsort_values)
        call cpu_time(end_time)
        qsort_time = end_time - start_time
        call cpu_time(start_time)
        call lampsort(lampsort_values)
        call cpu_time(end_time)
        lampsort_time = end_time - start_time
        call cpu_time(start_time)
        call c_qsort(c_loc(c_qsort_values), size(c_qsort_values, kind=INT64), &
                     c_sizeof(c_qsort_values(1)), c_funloc(real_compare))
        call cpu_time(end_time)
        c_qsort_time = end_time - start_time
        print '(I12, 3E15.6)', sizes(i), qsort_time, lampsort_time, c_qsort_time
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
        if (.not. is_sorted(c_qsort_values)) then
            write (unit=error_unit, fmt='(A)') &
                'error: array not sorted correctly by C qsort'
            stop 2
        end if
        deallocate(qsort_values, lampsort_values, c_qsort_values)
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

    function real_compare(c_p1, c_p2) result(cmp)
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr), value :: c_p1, c_p2
        integer :: cmp
        real, pointer :: f_p1, f_p2

        call c_f_pointer(c_p1, f_p1)
        call c_f_pointer(c_p2, f_p2)
        if (f_p1 < f_p2) then
            cmp = -1
        else if (f_p1 > f_p2) then
            cmp = 1
        else
            cmp = 0
        end if
    end function real_compare

end program quicksort_test
