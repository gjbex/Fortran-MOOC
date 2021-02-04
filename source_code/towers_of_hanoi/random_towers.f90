program random_towers
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: towers_mod, only : init_stacks, get_stack_height, move_disk, print_stacks
    implicit none
    integer, parameter :: dest_stack = 2
    integer :: nr_disks, max_nr_moves, nr_moves = 0, from, to, i
    integer, dimension(:, :), allocatable :: stacks

    call get_parameters(nr_disks, max_nr_moves)
    stacks = init_stacks(nr_disks)
    do while (nr_moves <= max_nr_moves)
        call new_move(from, to)
        if (is_legal_move(stacks, from, to)) then
            call move_disk(stacks, from, to)
            nr_moves = nr_moves + 1
            if (mod(nr_moves, 1000) == 0) &
                write (unit=error_unit, fmt='(A, I0)') 'move ', nr_moves
            if (all(stacks(dest_stack, :) == [ (i, i=nr_disks, 0, -1) ])) exit
        end if
    end do
    print '(A, I0, A)', 'executed ', nr_moves, ' moves'
    call print_stacks(stacks)
    deallocate (stacks)
    
contains

    function is_legal_move(stacks, from, to) result(is_legal)
        implicit none
        integer, dimension(:, :), intent(in) :: stacks
        integer, value :: from, to
        logical :: is_legal
        integer :: from_disk, to_disk, from_pos, to_pos

        is_legal = .false.
        ! moving a disk to the same stack makes no sense
        if (from == to) return
        from_pos = get_stack_height(stacks(from, :))
        ! a disk can not be moved from an empty stack
        if (from_pos == 0) return
        from_disk = stacks(from, from_pos)
        to_pos = get_stack_height(stacks(to, :))
        ! if the destination stack is empty, we can move unconditionally
        if (to_pos == 0) then
            is_legal = .true.
            return
        else
            to_disk = stacks(to, to_pos)
            ! if the disk to be moved is smaller than the one on top of the stack, move
            if (from_disk < to_disk) then
                is_legal = .true.
                return
            end if
        end if
    end function is_legal_move

    subroutine new_move(from, to)
        implicit none
        integer, intent(out) :: from, to
        real :: r

        call random_number(r)
        from = 1 + int(3*r)
        call random_number(r)
        to = 1 + int(3*r)
    end subroutine new_move

    subroutine get_parameters(nr_disks, max_nr_moves)
        implicit none
        integer, intent(out) :: nr_disks, max_nr_moves
        character(len=1024) :: buffer, msg
        integer :: status

        if (command_argument_count() == 2) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) nr_disks
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 2
            end if
            call get_command_argument(2, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) max_nr_moves
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 2
            end if
        else
            nr_disks = 4
            max_nr_moves = 10000
        end if
    end subroutine get_parameters

end program random_towers
