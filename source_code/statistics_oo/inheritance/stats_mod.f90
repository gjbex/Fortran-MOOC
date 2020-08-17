module stats_mod
    implicit none

    private

    type, public :: descriptive_stats_t
        private
        integer :: nr_values = 0
        real :: sum = 0.0, sum2 = 0.0
    contains
        procedure, public, pass :: add_value, get_nr_values, get_mean, get_stddev
    end type descriptive_stats_t

contains

    subroutine add_value(stats, new_value)
        implicit none
        class(descriptive_stats_t), intent(inout) :: stats
        real, value :: new_value

        stats%nr_values = stats%nr_values + 1
        stats%sum = stats%sum + new_value
        stats%sum2 = stats%sum2 + new_value**2
    end subroutine add_value

    function get_nr_values(stats) result(nr_values)
        implicit none
        class(descriptive_stats_t), intent(in) :: stats
        integer :: nr_values

        nr_values = stats%nr_values
    end function get_nr_values

    function get_mean(stats) result(mean_value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        class(descriptive_stats_t), intent(in) :: stats
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
        class(descriptive_stats_t), intent(in) :: stats
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

end module stats_mod
