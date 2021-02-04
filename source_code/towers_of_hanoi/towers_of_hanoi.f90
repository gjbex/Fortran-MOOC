program towers_of_hanoi
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: towers_mod, only : init_stacks, get_stack_height, print_stacks
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
