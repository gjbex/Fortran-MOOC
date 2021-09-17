program generate_array
    use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
    use :: linalg_mod, only : write_array, generate_random_array
    implicit none
    integer, dimension(:), allocatable :: dimensions
    real(kind=DP), dimension(:), allocatable :: vector
    real(Kind=DP), dimension(:, :), allocatable :: matrix

    call get_arguments(dimensions)
    if (size(dimensions) == 1) then
        call generate_random_array(vector, dimensions)
        call write_array(vector)
        deallocate (vector)
    else if (size(dimensions) == 2) then
        call generate_random_array(matrix, dimensions)
        call write_array(matrix)
        deallocate (matrix)
    else
        write (unit=error_unit, fmt='(A)') '# error: only rank 1 and 2 are supported'
    end if

contains

   subroutine get_arguments(dimensions)
        implicit none
        integer, dimension(:), allocatable, intent(out) :: dimensions
        integer :: rank, status, i
        character(len=1024) :: buffer, msg
        
        rank = command_argument_count()
        if (rank < 1) then
            write (unit=error_unit, fmt='(A)') '# error: rank should be at least 1'
            stop 10
        end if
        allocate (dimensions(rank), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') '# error: can not allocate dimensions'
            stop 11
        end if

        do i = 1, rank
            call get_command_argument(i, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) dimensions(i)
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
                stop 11
            end if
        end do
    end subroutine get_arguments

end program generate_array
