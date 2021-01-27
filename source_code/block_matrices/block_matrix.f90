program block_matrix
    implicit none
    integer :: matrix_size, block_size
    integer, dimension(:, :), allocatable :: data
    integer :: i

    call get_parameters(matrix_size, block_size)
    data = create_block_matrix(matrix_size, block_size) 
    call print_matrix(data)
    deallocate (data)

contains

    subroutine get_parameters(matrix_size, block_size)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: matrix_size, block_size
        character(len=1024) :: buffer, msg
        integer :: status

        if (command_argument_count() == 2) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) matrix_size
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
            end if
            call get_command_argument(2, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) block_size
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
            end if
        else
            matrix_size = 9
            block_size = 3
        end if
    end subroutine get_parameters

    function create_block_matrix(matrix_size, block_size) result(B)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, value :: matrix_size, block_size
        integer, dimension(:, :), allocatable :: B
        integer :: i, j, k, block_min, block_max, block_mid, status

        allocate (B(matrix_size, matrix_size), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                'error: can not allocate matrix'
            stop 2
        end if
        B = 0
        block_min = -block_size/2
        block_max = block_min + block_size - 1
        block_mid = block_size/2 + 1
        forall (i = block_mid:size(B, 1):block_size, &
                j = block_min:block_max, k = block_min:block_max)
            B(i + j, i + k) = 1
        end forall
    end function create_block_matrix

    subroutine print_matrix(A)
        implicit none
        integer, dimension(:, :), intent(in) :: A
        integer :: i

        do i = 1, size(A, 1)
            print '(*(I3))', A(i, :)
        end do
    end subroutine print_matrix

end program block_matrix
