module towers_mod
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    public :: init_stacks, get_stack_height, print_stacks

contains

    ! The stacks are represented as integer arrays, disks are numbered from
    ! 1 to the number of disks, the number representing the size of the disk.
    ! Array elements that do not represent disks have the value 0.
    ! An extra element is added to the array that will always be 0, this simplifies
    ! the implementation of the get_stack_height function.
    ! There are always 3 stacks, so the dimension of stacks will be
    ! stacks(3, nr_disks + 1)
    ! Extra exercise: would using stacks(nr_disks + 1, 3) be more efficient?
    !  Why (not)?
    function init_stacks(nr_disks) result(stacks)
        implicit none
        integer, value :: nr_disks
        integer, dimension(:, :), allocatable :: stacks
        integer, parameter :: nr_stacks = 3
        integer :: status, i

        allocate (stacks(nr_stacks, nr_disks + 1), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate stacks'
            stop 1
        end if
        stacks(1, :) = [ (i, i=size(stacks, 2) - 1, 0, -1) ]
        stacks(2:3, :) = 0
    end function init_stacks

    function get_stack_height(stack) result(height)
        implicit none
        integer, dimension(:), intent(in) :: stack
        integer :: height

        height = findloc(stack, 0, dim=1) - 1
    end function get_stack_height

    subroutine print_stacks(stacks)
        implicit none
        integer, dimension(:, :), intent(in) :: stacks
        integer :: i

        do i = 1, size(stacks, 1)
            print '(*(I3))', stacks(i, :)
        end do
        print '(A)', '-----------------------'
    end subroutine print_stacks

end module towers_mod
