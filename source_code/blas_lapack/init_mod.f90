module init_mod
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, error_unit
    implicit none

    private

    public :: initialize, create_matrix

contains

    function create_matrix(matrix_size) result(matrix)
        implicit none
        integer, value :: matrix_size
        real(kind=DP), dimension(:, :), allocatable  :: matrix
        integer :: istat

        allocate (matrix(matrix_size, matrix_size), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error :can allocated matrix'
            stop 8
        end if
    end function create_matrix

    subroutine initialize(matrix_size, nr_iters)
        implicit none
        integer, intent(out) :: matrix_size, nr_iters
        integer :: istat
        character(len=1024) :: msg, buffer, seed_file

        if (command_argument_count() < 2) then
            write (unit=error_unit, fmt='(A)') 'error: expect matrix size and &
                                               &number of iterations as arugment'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) matrix_size
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
        call get_command_argument(2, buffer)
        read (buffer, fmt=*, iostat=istat, iomsg=msg) nr_iters
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 2
        end if
        if (command_argument_count() > 2) then
            call get_command_argument(3, seed_file)
            call init_random(seed_file)
        else
            call init_random()
        end if
    end subroutine initialize

    subroutine init_random(seed_file)
        implicit none
        character(len=*), intent(in), optional :: seed_file
        character(len=1024) :: msg, file_name
        integer :: seed_size, istat, clock, unit_nr
        integer, dimension(:), allocatable :: seed_vals

        call random_seed(size=seed_size)
        allocate (seed_vals(seed_size), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate seed values'
            stop 3
        end if

        if (present(seed_file)) then
            open (newunit=unit_nr, file=seed_file, form='formatted', &
                  access='sequential', action='read', status='old', &
                  iostat=istat, iomsg=msg)
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 4
            end if
            read (unit=unit_nr, fmt=*, iostat=istat, iomsg=msg) seed_vals
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
                stop 5
            end if
            close (unit=unit_nr)
            call random_seed(put=seed_vals)
            file_name = seed_file
        end if
        call system_clock(count=clock)
        write (file_name, fmt='(A, I0, A)') 'seed_', clock, '.txt'
        open (newunit=unit_nr, file=file_name, form='formatted', &
              access='sequential', action='write', status='new', &
              iostat=istat, iomsg=msg)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 7
        end if
        call random_seed(get=seed_vals)
        write (unit=unit_nr, fmt='(*(I12))', iostat=istat, iomsg=msg) seed_vals
        close (unit=unit_nr)

        deallocate (seed_vals)
    end subroutine init_random

end module init_mod
