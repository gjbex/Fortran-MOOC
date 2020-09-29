program no_blas_probabilities
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, error_unit
    implicit none
    integer :: matrix_size, nr_iters, i
    real(kind=DP), dimension(:, :), allocatable :: prob_matrix, final_matrix
    real(kind=DP) :: max_val
    integer :: istat

    call initialize(matrix_size, nr_iters)
    allocate (prob_matrix(matrix_size, matrix_size), &
              final_matrix(matrix_size, matrix_size), &
              stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') 'error :can allocated matrices'
        stop 8
    end if

    call random_number(prob_matrix)
    call normalize(prob_matrix)
    final_matrix = prob_matrix

    do i = 2, nr_iters
        final_matrix = matmul(final_matrix, prob_matrix)
    end do
    max_val = 0.0_DP
    do i = 1, size(final_matrix, 1)
        if (final_matrix(i, i) > max_val) max_val = final_matrix(i, i)
    end do
    deallocate (prob_matrix, final_matrix)

    print '(A, e25.15)', 'maximum value = ', max_val

contains

    subroutine normalize(matrix)
        implicit none
        real(kind=DP), dimension(:, :), intent(inout) :: matrix
        integer :: row
        real(kind=DP) :: norm

        do row = 1, size(matrix, 1)
            norm = sum(matrix(i, :))
            matrix(i, :) = matrix(i, :)/norm
        end do
    end subroutine normalize

    subroutine initialize(matrix_size, nr_iters)
        use, intrinsic :: iso_fortran_env, only : error_unit
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
            call get_command_argument(2, seed_file)
            call init_random(seed_file)
        else
            call init_random()
        end if
    end subroutine initialize

    subroutine init_random(seed_file)
        use, intrinsic :: iso_fortran_env, only : error_unit
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
        else
            call system_clock(count=clock)
            write (file_name, fmt='(A, I0, A)') 'seed_', clock, '.txt'
        end if
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

end program no_blas_probabilities
