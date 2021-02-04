module towers_mod
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    public :: init_stacks, get_stack_height, move_disk, print_stacks

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

    subroutine move_disk(stacks, from, to)
        implicit none
        integer, dimension(:, :), intent(inout) :: stacks
        integer, value :: from, to
        integer :: pos, disk

        pos = get_stack_height(stacks(from, :))
        disk = stacks(from, pos)
        stacks(from, pos) = 0
        pos = get_stack_height(stacks(to, :)) + 1
        stacks(to, pos) = disk
    end subroutine move_disk

    function are_valid_stacks(stacks) result(are_valid)
        implicit none
        integer, dimension(:, :), intent(in) :: stacks
        logical :: are_valid
        integer :: i, j, disk, status
        logical, dimension(:), allocatable :: disk_presence
        
        allocate (disk_presence(size(stacks, 2) - 1), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate array'
            stop 3
        end if
        disk_presence = .false.
        are_valid = .true.
        ! check whether no larger disk is on top of a smaller one on all stacks
        do i = 1, size(stacks, 1)
            do j = 2, size(stacks, 2)
                if (stacks(i, j - 1) < stacks(i, j)) then
                    write (unit=error_unit, fmt='(A, I0, A, I0)') &
                        'error: disks in inappropriate positions on stack ', i, &
                        ' at position ', j
                    are_valid = .false.
                    return
                end if
            end do
        end do
        do i = 1, size(stacks, 1)
            do j = 1, size(stacks, 2)
                disk = stacks(i, j)
                if (disk < 0 .or. disk > size(disk_presence)) then
                    write (unit=error_unit, fmt='(A, I0, A)') &
                        'error: disk ', disk, ' is not legal'
                    are_valid = .false.
                    return
                end if
                if (disk > 0) then
                    if (disk_presence(disk)) then
                        write (unit=error_unit, fmt='(A, I0, A)') &
                            'error: disk ', disk, ' occurs multiple times'
                        are_valid = .false.
                        return
                    end if
                    disk_presence(disk) = .true.
                end if
            end do
        end do
        if (.not. all(disk_presence)) then
            write (unit=error_unit, fmt='(A)') &
                'error: not all disks are present'
            are_valid = .false.
            return
        end if
        deallocate (disk_presence)

    end function are_valid_stacks

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
