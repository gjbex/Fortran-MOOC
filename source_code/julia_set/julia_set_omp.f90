program julia_set
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, error_unit
    use julia_set_omp_mod, only : julia_compute
    implicit none
    complex(kind=DP), dimension(:, :), allocatable :: z
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
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer :: n
        integer, parameter :: DEFAULT_N = 100
        character(len=1024) :: buffer, msg
        integer :: istat

        if (command_argument_count() == 0) then
            n = DEFAULT_N
        else if (command_argument_count() == 1) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=istat, iomsg=msg) n
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') &
                    'error: ', msg
                stop 2
            end if
        else
            write (unit=error_unit, fmt='(A)') &
                'error: expect at most one argument'
            stop 1
        end if
    end function get_size

    subroutine init_z_values(z, nr_points)
        implicit none
        complex(kind=DP), dimension(:, :), allocatable, &
                          intent(inout) :: z
        integer, intent(in) :: nr_points
        real(kind=DP), parameter :: MIN_RE = -1.8_DP, &
                                    MAX_RE =  1.8_DP, &
                                    MIN_IM = -1.8_DP, &
                                    MAX_IM =  1.8_DP
        real(kind=DP) :: delta_re, delta_im
        integer :: i, j

        allocate(z(nr_points, nr_points))
        if (.not. allocated(z)) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not allocate z'
            stop 2
        end if

        delta_re = (MAX_RE - MIN_RE)/nr_points
        delta_im = (MAX_IM - MIN_IM)/nr_points
        do j = 1, size(z, 2)
            do i = 1, size(z, 1)
                z(i, j) = cmplx(MIN_RE + (i - 1)*delta_re, &
                                MIN_IM + (j - 1)*delta_im, &
                                kind=DP)
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

