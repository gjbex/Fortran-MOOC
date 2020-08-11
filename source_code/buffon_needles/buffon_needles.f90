program buffon_needles
    implicit none
    real, parameter :: PI = acos(-1.0)
    integer, parameter :: nr_needles_default = 100
    real, parameter :: line_dist_default = 2.0
    real, parameter :: needle_len = 2.0
    integer :: nr_needles = nr_needles_default
    real :: line_dist = line_dist_default
    !> @brief a needle's position is represented by the x-coordinate of its
    !>        midpoint, and the angle theta
    type :: needle_t
        real :: x, theta
        real :: len = needle_len
    end type
    type(needle_t) :: needle
    integer :: i, nr_hits

    call get_command_line_values(nr_needles, line_dist)
    call check_distance_acceptable(line_dist, needle_len)
    nr_hits = 0
    do i = 1, nr_needles
        needle = drop_needle(line_dist)
        if (is_needle_crossing(needle, line_dist)) then
            nr_hits = nr_hits + 1
        end if
    end do
    print '(A, F15.7)', 'probability          = ', real(nr_hits)/real(nr_needles)
    print '(A, F15.7)', 'expected probability = ', 2.0*needle_len/(PI*line_dist)

contains

    !> @brief handle command line arguments
    !>
    !> @param[inout] nr_needles number of needles to drop
    !> @param[inout] line_dist distance between the lines on the page
    subroutine get_command_line_values(nr_needles, line_dist)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(inout) :: nr_needles
        real, intent(inout) :: line_dist
        character(len=1024) :: buffer, iomsg
        integer :: iostat

        if (command_argument_count() > 0) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iomsg=iomsg, iostat=iostat) nr_needles
            if (iostat /= 0) then
                write (unit=error_unit, fmt='(A)') iomsg
                stop 1
            end if
        end if
        if (command_argument_count() > 1) then
            call get_command_argument(2, buffer)
            read (buffer, fmt=*, iomsg=iomsg, iostat=iostat) line_dist
            if (iostat /= 0) then
                write (unit=error_unit, fmt='(A)') iomsg
                stop 1
            end if
        end if
    end subroutine get_command_line_values

    !> @brief check whether the distance between the lines on paper is
    !>        acceptable
    !>
    !> The subroutine verifies the distance between the lines on the page, if
    !> that is not adequate, it will print an error message and exit the
    !> application.
    !>
    !> @param[in] line_dist distance between lines on the page
    !> @param[in] needle_len length of a needle
    subroutine check_distance_acceptable(line_dist, needle_len)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real, value :: line_dist, needle_len

        if (line_dist < needle_len) then
            write (unit=error_unit, fmt='(A, F4.2)') &
                'error: the distance between the lines must be larger than the needle length', &
                needle_len
           stop 2
       end if 
    end subroutine check_distance_acceptable

    !> @brief drop a needle on the plain
    !>
    !> Due to symmetry arbuments, the midpoint is restricted to fall between
    !> zero and half of the distance between two lines, for similar reasons,
    !> theta will fall between zero and pi/2
    !>
    !> @param[in] line_dist distance between two lines on the paper
    !> @returns a random needle position
    function drop_needle(line_dist) result(needle)
        implicit none
        real, value :: line_dist
        type(needle_t) :: needle
        real :: r

        call random_number(r)
        needle%x = 0.5*r*line_dist
        call random_number(r)
        needle%theta = 0.5*r*PI
    end function drop_needle

    !> @brief check whether a given needle crosses a line
    !>
    !> @param[in] needle needle position to check
    !> @param[in] line_dist distance between lines on the paper
    !> @returns .true. if the needle crosses a line, .false. otherwise
    function is_needle_crossing(needle, line_dist) result(does_cross)
        implicit none
        type(needle_t), intent(in) :: needle
        real, value :: line_dist
        logical :: does_cross

        does_cross = needle%x + 0.5*needle%len*cos(needle%theta) >= 0.5*line_dist
    end function is_needle_crossing

end program buffon_needles
