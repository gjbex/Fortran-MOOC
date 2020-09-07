program logistic_map
    implicit none
    integer, parameter :: nr_iters = 10000, nr_x_vals = 100, nr_r_vals = 1000
    real, parameter :: delta_x = 1.0/nr_x_vals, delta_r = 4.0/nr_r_vals
    real :: x, x0, r
    integer :: i, i_r, i_x0

    do i_r = 0, nr_r_vals
        r = i_r*delta_r
        do i_x0 = 0, nr_x_vals
            x0 = i_x0*delta_x
            x = x0
            do i = 1, nr_iters
                x = r*x*(1.0 - x)
            end do
            print '(3F12.7)', r, x0, x
        end do
    end do

end program logistic_map
