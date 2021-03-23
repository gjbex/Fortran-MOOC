program enlarge_array
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: initial_size = 3, size_incr = 2
    integer, dimension(:), allocatable :: values
    integer :: i
    
    allocate (values(initial_size))
    do i = 1, size(values)
        values(i) = i
    end do
    print *, values
    do i = 1, 3
        call grow_array(values, size_incr)
        print *, values
    end do

    deallocate (values)

    do i = 1, 3
        call grow_array(values, size_incr)
        print *, values
    end do

    deallocate (values)

contains

    subroutine grow_array(values, size_incr)
        implicit none
        integer, dimension(:), allocatable, intent(inout) :: values
        integer, value ::size_incr
        integer, dimension(:), allocatable :: new_values
        integer :: i

        if (allocated(values)) then
            allocate (new_values(size(values) + size_incr), source=values)
            do i = size(values) + 1, size(new_values)
                new_values(i) = i
            end do
            ! deallocate (values)
            values = new_values
        else
            allocate (values(size_incr))
            do i = 1, size(values)
                values(i) = i
            end do
        end if
    end subroutine grow_array

end program enlarge_array
