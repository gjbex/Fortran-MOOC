program main_stats
    implicit none
    integer, parameter :: nr_data = 21
    integer :: i
    real :: mean, stddev
    integer :: n
    real, dimension(nr_data) :: data

    data = [ (100.0 + 0.3*i, i=-size(data)/2, size(data)/2) ]
    call compute_stats(data, mean, stddev, n)
    print *, mean, stddev, n

contains

    subroutine compute_stats(data, mean, stddev, n)
        implicit none
        real, dimension(:), intent(in) :: data
        real, intent(out) :: mean, stddev
        integer, intent(out) :: n
        real :: data_sum, data_sum2

        n = size(data)
        data_sum = sum(data)
        data_sum2 = sum(data**2)
        associate(n => stats%n)
            stats%mean = data_sum/n
            stats%stddev = sqrt((data_sum2 - data_sum**2/n)/(n - 1))
        end associate
    end subroutine compute_stats

end program main_stats
