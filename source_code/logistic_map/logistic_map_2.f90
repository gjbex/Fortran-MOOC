program logistic_map_2
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, error_unit
    use meshgrid_mod, only : meshgrid
    implicit none
    integer :: nr_x_values = 100, nr_r_values = 100, nr_iterations = 100
    real, parameter :: x_min = 0.0_DP, x_max = 1.0_DP, &
                       r_min = 0.5_DP, r_max = 4.0_DP
    real(kind=DP), dimension(:), allocatable :: x_vals, r_vals
    real(kind=DP), dimension(:, :), allocatable :: X, R, result
    real :: delta_x, delta_r
    integer :: i, j, status

    call get_parameters(nr_x_values, nr_r_values, nr_iterations)

    ! initialize X
    allocate (x_vals(nr_x_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate array'
        stop 1
    end if
    delta_x = (x_max - x_min)/nr_x_values
    x_vals = [ (x_min + i*delta_x, i=1, nr_x_values) ]

    ! initialize R
    allocate (r_vals(nr_r_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate array'
        stop 1
    end if
    delta_r = (r_max - r_min)/nr_r_values
    r_vals = [ (r_min + i*delta_r, i=1, nr_r_values) ]

    ! compute meshgrid
    call meshgrid(x_vals, r_vals, X, R)

    ! allocate result matrix
    allocate (result, source=X, stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate array'
        stop 1
    end if

    ! compute result
    result = iterate_map(X, R, nr_iterations)
    do j = 1, nr_x_values
        do i = 1, nr_r_values
            print *, R(i, j), result(i, j)
        end do
    end do

    ! deallocate the lot
    deallocate(X, R, result, x_vals, r_vals)

contains

    subroutine get_parameters(nr_x_values, nr_r_values, nr_iterations)
        implicit none
        integer, intent(out) :: nr_x_values, nr_r_values, nr_iterations
        integer, parameter :: default_nr_x_vals = 100, default_nr_r_vals = 100, &
                              default_nr_iterations = 100
        character(len=1024) :: buffer, msg
        integer :: status

        if (command_argument_count() == 3) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) nr_x_values
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
                stop 2
            end if
            call get_command_argument(2, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) nr_r_values
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
                stop 2
            end if
            call get_command_argument(3, buffer)
            read (buffer, fmt=*, iostat=status, iomsg=msg) nr_iterations
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
                stop 2
            end if
        else
            nr_x_values = default_nr_x_vals
            nr_r_values = default_nr_r_vals
            nr_iterations = default_nr_iterations
        end if
    end subroutine get_parameters


    elemental function iterate_map(x0, r, nr_steps) result(xn)
        implicit none
        real(kind=DP), value :: x0, r
        integer, value :: nr_steps
        real(kind=DP) :: xn
        integer :: i

        xn = x0
        do i = 1, nr_steps
            xn = r*xn*(1.0_DP - xn)
        end do
    end function iterate_map

end program logistic_map_2
