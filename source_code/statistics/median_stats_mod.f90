module median_stats_mod
    use :: quicksort_mod
    implicit none

    private

    type, public :: descriptive_stats_t
        private
        integer :: nr_values = 0
        real :: sum = 0.0, sum2 = 0.0
        real, dimension(:), allocatable :: values
    end type descriptive_stats_t

    public :: init_stats, add_value, get_nr_values, get_mean, get_stddev, &
        get_median, finalize_stats

contains

    subroutine init_stats(stats, nr_values)
        use, intrinsic :: iso_fortran_env, only : error_unit
        type(descriptive_stats_t), intent(inout) :: stats
        integer, value :: nr_values

        allocate(stats%values(nr_values))
        if (.not. allocated(stats%values)) then
            write (unit=error_unit, fmt='(A, I0, A)') &
                'error: can not allocated memory for ', nr_values, ' values'
            stop 3
        end if
    end subroutine init_stats

    subroutine add_value(stats, new_value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        type(descriptive_stats_t), intent(inout) :: stats
        real, value :: new_value

        stats%nr_values = stats%nr_values + 1
        if (stats%nr_values > size(stats%values)) then
            write (unit=error_unit, fmt='(A, I0, A)') &
                'error: capacity exceeded, maximum ', size(stats%values), &
                ' can be processed'
            stop 4
        end if
        stats%sum = stats%sum + new_value
        stats%sum2 = stats%sum2 + new_value**2
        stats%values(stats%nr_values) = new_value
    end subroutine add_value

    function get_nr_values(stats) result(nr_values)
        implicit none
        type(descriptive_stats_t), intent(in) :: stats
        integer :: nr_values

        nr_values = stats%nr_values
    end function get_nr_values

    function get_mean(stats) result(mean_value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        type(descriptive_stats_t), intent(inout) :: stats
        real :: mean_value

        if (stats%nr_values == 0) then
            write (unit=error_unit, fmt='(A)') &
                'error: too few data value to compute mean'
            stop 1
        end if
        associate (n => stats%nr_values, sum => stats%sum)
            mean_value = sum/n
        end associate
    end function get_mean

    function get_stddev(stats) result(stddev_value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        type(descriptive_stats_t), intent(inout) :: stats
        real :: stddev_value

        if (stats%nr_values < 2) then
            write (unit=error_unit, fmt='(A)') &
                'error: too few data values to compute stddev'
            stop 2
        end if
        associate (n => stats%nr_values, sum => stats%sum, sum2 => stats%sum2)
            stddev_value = sqrt((sum2 - sum**2/n)/(n - 1.0))
        end associate
    end function get_stddev

    function get_median(stats) result(median_value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        type(descriptive_stats_t), intent(inout) :: stats
        real :: median_value

        if (stats%nr_values == 0) then
            write (unit=error_unit, fmt='(A)') &
                'error: too few data value to compute median'
            stop 1
        end if
        associate(n => stats%nr_values, values => stats%values)
            call qsort(values)
            if (mod(n, 2) == 0) then
                median_value = (values(n/2) + values(n/2 + 1))/2.0
            else
                median_value = values(n/2 + 1)
            end if
        end associate
    end function get_median

    subroutine finalize_stats(stats)
        use, intrinsic :: iso_fortran_env, only : error_unit
        type(descriptive_stats_t), intent(inout) :: stats

        deallocate(stats%values)
    end subroutine finalize_stats

end module median_stats_mod
