program julia_set
    use, intrinsic :: iso_fortran_env, only : dp => REAL64, error_unit
    use julia_set_omp_mod, only : julia_compute
    implicit none
    complex(kind=dp), dimension(:, :), allocatable :: z
    integer, dimension(:, :), allocatable :: n
    integer :: nr_points

    ! handle command line argument, if any
    nr_points = get_size()

    ! allocate and initialize arrays
    call init_z_values(z, nr_points)
    call init_n_values(n, nr_points)

    call julia_compute(z, n)

    call print_n_values(n)

    ! deallocate arrays allocated in initialization
    ! functions
    deallocate(z)
    deallocate(n)

contains

    function get_size() result(n)
        implicit none
        integer :: n
        integer, parameter :: default_n = 100
        character(len=80) :: buffer
        if (command_argument_count() == 0) then
            n = default_n
        else if (command_argument_count() == 1) then
            call get_command_argument(1, buffer)
            read (buffer, '(I8)') n
        else
            write (unit=error_unit, fmt='(A)') &
                'error: expect at most one argument'
            stop 1
        end if
    end function get_size

    subroutine init_z_values(z, nr_points)
        implicit none
        complex(kind=dp), dimension(:, :), allocatable, &
                          intent(inout) :: z
        integer, intent(in) :: nr_points
        real(kind=dp), parameter :: min_re = -1.8_dp, &
                                    max_re =  1.8_dp, &
                                    min_im = -1.8_dp, &
                                    max_im =  1.8_dp
        real(kind=dp) :: delta_re, delta_im
        integer :: i, j

        allocate(z(nr_points, nr_points))
        if (.not. allocated(z)) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not allocate z'
            stop 2
        end if

        delta_re = (max_re - min_re)/nr_points
        delta_im = (max_im - min_im)/nr_points
        do j = 1, size(z, 2)
            do i = 1, size(z, 1)
                z(i, j) = cmplx(min_re + (i - 1)*delta_re, &
                                min_im + (j - 1)*delta_im, &
                                kind=dp)
            end do
        end do
    end subroutine init_z_values

    subroutine init_n_values(n, nr_points)
        implicit none
        integer, dimension(:, :), allocatable, intent(inout) :: n
        integer, intent(in) :: nr_points

        allocate(n(nr_points, nr_points))
        if (.not. allocated(z)) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not allocate z'
            stop 2
        end if

        n = 0

    end subroutine init_n_values

    subroutine print_n_values(n)
        implicit none
        integer, dimension(:, :), intent(in) :: n
        integer :: i
        character(len=80) :: fmt_str

        write (fmt_str, '(A, I0, A)') '(', size(n, 2), 'I4)'

        do i = 1, size(n, 1)
            print fmt_str, n(i, :)
        end do
    end subroutine print_n_values

end program julia_set

