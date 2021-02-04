program towers_of_hanoi
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer :: nr_disks, nr_moves = 0
    integer, dimension(:, :), allocatable :: stacks

    call get_parameters(nr_disks)
    stacks = init_stacks(nr_disks)
    call print_stacks(stacks)
    call move_disks(stacks, nr_disks, 1, 2, nr_moves)
    print '(A, I0)', 'number of moves: ', nr_moves
    deallocate (stacks)

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

    function get_aux_stack(from, to) result(aux)
        implicit none
        integer, value :: from, to
        integer :: aux

        aux = 6 - from - to
    end function get_aux_stack

    recursive subroutine move_disks(stacks, nr_disks, from, to, nr_moves)
        implicit none
        integer, dimension(:, :), intent(inout) :: stacks
        integer, value :: nr_disks, from, to
        integer, intent(inout) :: nr_moves
        integer :: aux, disk, pos

        if (nr_disks == 1) then
            pos = get_stack_height(stacks(from, :))
            disk = stacks(from, pos)
            stacks(from, pos) = 0
            pos = get_stack_height(stacks(to, :)) + 1
            stacks(to, pos) = disk
            call print_stacks(stacks)
            nr_moves = nr_moves + 1
        else
            aux = get_aux_stack(from, to)
            call move_disks(stacks, nr_disks - 1, from, aux, nr_moves)
            call move_disks(stacks, 1, from, to, nr_moves)
            call move_disks(stacks, nr_disks - 1, aux, to, nr_moves)
        end if
    end subroutine move_disks

    subroutine print_stacks(stacks)
        implicit none
        integer, dimension(:, :), intent(in) :: stacks
        integer :: i

        do i = 1, size(stacks, 1)
            print '(*(I3))', stacks(i, :)
        end do
        print '(A)', '-----------------------'
    end subroutine print_stacks

    subroutine get_parameters(nr_disks)
        implicit none
        integer, intent(out) :: nr_disks
        character(len=1024) :: buffer, msg
        integer :: status

        if (command_argument_count() == 1) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) nr_disks
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 2
            end if
        else
            nr_disks = 4
        end if
    end subroutine get_parameters

end program towers_of_hanoi
