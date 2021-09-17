program logistic_map
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none
    integer, parameter :: nr_x_values = 100, nr_r_values = 200, nr_iterations = 10000
    real, parameter :: x_min = 0.0_DP, x_max = 1.0_DP, &
                       r_min = 0.5_DP, r_max = 4.0_DP
    real(kind=DP), dimension(nr_x_values, nr_r_values) :: X, R, result
    real :: delta_x, delta_r
    integer :: i, j

    ! initialize X
    delta_x = (x_max - x_min)/nr_x_values
    X(:, 1) = [ (x_min + i*delta_x, i=1, nr_x_values) ]
    do i = 2, nr_r_values
        X(:, i) = X(:, 1)
    end do

    ! initialize R
    delta_r = (r_max - r_min)/nr_r_values
    R(1, :) = [ (r_min + i*delta_r, i=1, nr_r_values) ]
    do i = 2, nr_x_values
        R(i, :) = R(1, :)
    end do

    ! compute result
    result = iterate_map(X, R, nr_iterations)
    do i = 1, nr_x_values
        do j = 1, nr_r_values
            print *, R(i, j), result(i, j)
        end do
    end do

contains

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

end program logistic_map
