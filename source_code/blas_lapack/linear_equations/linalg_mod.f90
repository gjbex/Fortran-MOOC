module linalg_mod
    use, intrinsic :: iso_fortran_env, only : output_unit, error_unit, DP => REAL64
    implicit none

    private

    public :: read_array, write_array, generate_random_array

contains

    subroutine read_array(file_name, array, dimensions)
        implicit none
        character(len=*), intent(in) :: file_name
        real(kind=DP), dimension(..), allocatable, intent(out) :: array
        integer, dimension(:), intent(in) :: dimensions

        if (rank(array) /= size(dimensions)) then
            write (unit=error_unit, fmt='(A)') '# error: array rank does not match dimensions'
            stop 3
        end if
        select rank(array)
            rank(1)
                call read_vector(file_name, dimensions(1), array)
            rank(2)
                call read_matrix(file_name, dimensions(1), dimensions(2), array)
            rank default
                write (unit=error_unit, fmt='(A, I0, A)') &
                    '# error: rank ', rank(array), ' not supported'
                stop 4
        end select
    end subroutine read_array

    subroutine write_array(array, file_name)
        implicit none
        real(kind=DP), dimension(..), intent(in) :: array
        character(len=*), intent(in), optional :: file_name

        select rank(array)
            rank(1)
                call write_vector(array, file_name)
            rank(2)
                call write_matrix(array, file_name)
            rank default
                write (unit=error_unit, fmt='(A, I0, A)') &
                    '# error: rank ', rank(array), ' not supported'
                stop 4
        end select
    end subroutine write_array

    subroutine read_vector(file_name, n, vector)
        implicit none
        character(len=*), intent(in) :: file_name
        integer, value :: n
        real(kind=DP), dimension(:), allocatable, intent(out) :: vector
        integer :: i, status, unit_nr
        character(len=1024) :: msg

        open (newunit=unit_nr, file=trim(file_name), access='sequential', &
            action='read', status='old', iostat=status, iomsg=msg)
        if (status /= 0) then
            write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
            stop 1
        end if

        if (.not. allocated(vector)) then
            allocate (vector(n), stat=status)
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
                stop 3
            end if
        end if

        do i = 1, n
            read (unit=unit_nr, fmt=*, iostat= status, iomsg=msg) vector(i)
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
                stop 2
            end if
        end do

        close (unit=unit_nr)

    end subroutine read_vector

    subroutine read_matrix(file_name, nr_rows, nr_cols, matrix)
        implicit none
        character(len=*), intent(in) :: file_name
        integer, value :: nr_rows, nr_cols
        real(kind=DP), dimension(:, :), allocatable, intent(out) :: matrix
        integer :: i, status, unit_nr
        character(len=1024) :: msg

        open (newunit=unit_nr, file=trim(file_name), access='sequential', &
            action='read', status='old', iostat=status, iomsg=msg)
        if (status /= 0) then
            write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
            stop 1
        end if

        if (.not. allocated(matrix)) then
            allocate (matrix(nr_rows, nr_cols), stat=status)
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
                stop 3
            end if
        end if

        do i = 1, nr_rows
            read (unit=unit_nr, fmt=*, iostat= status, iomsg=msg) matrix(i, :)
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
                stop 2
            end if
        end do

        close (unit=unit_nr)

    end subroutine read_matrix

    subroutine write_vector(vector, file_name)
        implicit none
        real(kind=DP), dimension(:), intent(in) :: vector
        character(len=*), intent(in), optional :: file_name
        integer :: unit_nr, i, status
        character(len=1024) :: msg

        if (present(file_name)) then
            open (newunit=unit_nr, file=trim(file_name), access='sequential', &
                action='write', status='replace', iostat=status, iomsg=msg)
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
                stop 1
            end if
        else
            unit_nr = output_unit
        end if

        do i = 1, size(vector)
            write (unit=unit_nr, fmt='(E27.15)') vector(i)
        end do

        if (present(file_name)) close (unit_nr)
    end subroutine write_vector

    subroutine write_matrix(matrix, file_name)
        implicit none
        real(kind=DP), dimension(:, :), intent(in) :: matrix
        character(len=*), intent(in), optional :: file_name
        integer :: unit_nr, i, status
        character(len=1024) :: msg

        if (present(file_name)) then
            open (newunit=unit_nr, file=trim(file_name), access='sequential', &
                action='write', status='replace', iostat=status, iomsg=msg)
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') '# error: ', trim(msg)
                stop 1
            end if
        else
            unit_nr = output_unit
        end if

        do i = 1, size(matrix, 1)
            write (unit=unit_nr, fmt='(*(E27.15))') matrix(i, :)
        end do

        if (present(file_name)) close (unit_nr)
    end subroutine write_matrix

    subroutine generate_random_array(array, dimensions)
        implicit none
        real(kind=DP), dimension(..), allocatable, intent(out) :: array
        integer, dimension(:), intent(in) :: dimensions
        integer :: status

        if (rank(array) /= size(dimensions)) then
            write (unit=error_unit, fmt='(A)') '# error: array rank does not match dimensions'
            stop 3
        end if
        select rank(array)
            rank(1)
                if (.not. allocated(array)) then
                    allocate(array(dimensions(1)), stat=status)
                    if (status /= 0) then
                        write (unit=error_unit, fmt='(A, I0)') &
                            '# error: can not allocate vector of size ', dimensions(1)
                        stop 6
                    end if
                end if
                call random_number(array)
            rank(2)
                if (.not. allocated(array)) then
                    allocate(array(dimensions(1), dimensions(2)), stat=status)
                    if (status /= 0) then
                        write (unit=error_unit, fmt='(A,I0, A, I0)') &
                            '# error: can not allocate matrix of size ', &
                            dimensions(1), ' by ', dimensions(2)
                        stop 6
                    end if
                end if
                call random_number(array)
            rank default
                write (unit=error_unit, fmt='(A, I0, A)') &
                    '# error: rank ', rank(array), ' not supported'
                stop 4
        end select
    end subroutine generate_random_array

end module linalg_mod
