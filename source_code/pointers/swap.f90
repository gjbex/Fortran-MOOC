program swap_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_vals = 100000, nr_steps = 10000
    real :: start_time, end_time
    real, dimension(:), allocatable :: orig_vector, vector
    real, dimension(:), allocatable, target ::  old_vector, new_vector
    real, dimension(:), pointer :: old_vector_p, new_vector_p
    integer :: step, istat

    allocate (orig_vector(nr_vals), vector(nr_vals), old_vector(nr_vals), &
              new_vector(nr_vals), stat=istat)

    ! initialize data
    call random_number(orig_vector)
    print '(A, E15.7)', 'original: ', sum(orig_vector)

    call cpu_time(start_time)
    vector = orig_vector
    do step = 1, nr_steps
        call compute_kernel_tmp(vector)
    end do
    call cpu_time(end_time)
    print '(A20, F12.6, E15.7)', 'copy swap: ', end_time - start_time, sum(vector)

    old_vector = orig_vector
    old_vector_p => old_vector
    new_vector_p => new_vector
    call cpu_time(start_time)
    do step = 1, nr_steps
        call compute_kernel_pointers(new_vector_p, old_vector_p)
        call swap_pointers(old_vector_p, new_vector_p)
    end do
    call cpu_time(end_time)
    if (mod(nr_steps, 2) == 0) then
        print '(A20, F12.6, E15.7)', 'pointer swap: ', end_time - start_time, &
            sum(old_vector)
    else
        print '(A20, F12.6, E15.7)', 'pointer swap: ', end_time - start_time, &
            sum(new_vector)
    end if

    ! check results
    if (mod(nr_steps, 2) == 0) then
        if (any(vector /= old_vector)) &
            write (unit=error_unit, fmt='(A)') 'warning: results differ'
    else
        if (any(vector /= new_vector)) &
            write (unit=error_unit, fmt='(A)') 'warning: results differ'
    end if

    old_vector = orig_vector
    call cpu_time(start_time)
    do step = 1, nr_steps
        if (mod(step, 2) == 1) then
            call compute_kernel_pointers(new_vector, old_vector)
        else
            call compute_kernel_pointers(old_vector, new_vector)
        end if
    end do
    call cpu_time(end_time)
    if (mod(nr_steps, 2) == 0) then
        print '(A20, F12.6, E15.7)', 'juggle swap: ', end_time - start_time, &
            sum(old_vector)
    else
        print '(A20, F12.6, E15.7)', 'juggle swap: ', end_time - start_time, &
            sum(new_vector)
    end if

    ! check results
    if (mod(nr_steps, 2) == 0) then
        if (any(vector /= old_vector)) &
            write (unit=error_unit, fmt='(A)') 'warning: results differ'
    else
        if (any(vector /= new_vector)) &
            write (unit=error_unit, fmt='(A)') 'warning: results differ'
    end if

    deallocate (orig_vector, vector, new_vector, old_vector)

contains

    subroutine compute_kernel_tmp(vector)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real, dimension(:), intent(inout) :: vector
        real, dimension(:), allocatable :: tmp_vector
        integer :: i, istat

        allocate (tmp_vector(size(vector)), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate tmp_vector'
            stop 1
        end if
        tmp_vector(1) = vector(1)
        tmp_vector(size(vector)) = vector(size(vector))
        do i = 2, size(vector) - 1
            tmp_vector(i) = 0.25*(vector(i - 1) + vector(i + 1)) + 0.5*vector(i)
        end do
        vector = tmp_vector
        deallocate (tmp_vector)
    end subroutine compute_kernel_tmp

    subroutine compute_kernel_pointers(new_vector, old_vector)
        implicit none
        real, dimension(:), intent(inout) :: new_vector, old_vector
        integer :: i

        new_vector(1) = old_vector(1)
        new_vector(size(old_vector)) = old_vector(size(old_vector))
        do i = 2, size(old_vector) - 1
            new_vector(i) = 0.25*(old_vector(i - 1) + old_vector(i + 1)) + &
                0.5*old_vector(i)
        end do
    end subroutine compute_kernel_pointers

    subroutine swap_pointers(a, b)
        implicit none
        real, dimension(:), pointer, intent(inout) :: a, b
        real, dimension(:), pointer :: tmp

        tmp => a
        a => b
        b => tmp
    end subroutine swap_pointers

end program swap_test
