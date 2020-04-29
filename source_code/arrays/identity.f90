program identity
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer :: n, i, istat
    real, dimension(:, :), allocatable :: A

    n = get_size()
    allocate(A(n, n), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') &
            'error: can not allocate array'
        stop 3
    end if
    A = eye(n)
    do i = 1, size(A, 1)
        print *, A(i, :)
    end do
    deallocate(A)

contains

    function get_size() result(n)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer :: n
        integer :: istat
        character(len=1024) :: buffer, msg

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting an integer argument, size of array'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) n
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                'error: ', msg
            stop 2
        end if
    end function get_size

    function eye(n) result(matrix)
        implicit none
        integer, value :: n
        real, dimension(n, n) :: matrix
        integer :: i

        matrix = 0.0
        do i = 1, size(A, 1)
            matrix(i, i) = 1.0
        end do
    end function eye

end program identity
