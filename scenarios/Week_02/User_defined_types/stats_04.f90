program main_stats
    implicit none
    integer, parameter :: nr_data = 21
    type :: statistics
        real :: mean, stddev
        integer :: n
    end type statistics
    integer :: i
    type(statistics) :: stats
    real, dimension(nr_data) :: data

    data = [ (100.0 + 0.3*i, i=-size(data)/2, size(data)/2) ]
    stats = compute_stats(data)
    print *, stats%mean, stats%stddev, stats%n

contains

    function compute_stats(data) result(stats)
        implicit none
        real, dimension(:), intent(in) :: data
        type(statistics) :: stats
        real :: data_sum, data_sum2

        stats%n = size(data)
        data_sum = sum(data)
        data_sum2 = sum(data**2)
        associate(n => stats%n)
            stats%mean = data_sum/n
            stats%stddev = sqrt((data_sum2 - data_sum**2/n)/(n - 1))
        end associate
    end function compute_stats

end program main_stats
