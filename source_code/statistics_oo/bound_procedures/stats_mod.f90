module stats_mod
    implicit none

    private

    type, public :: descriptive_stats_t
        private
        integer :: nr_values = 0
        real :: sum = 0.0, sum2 = 0.0
    contains
        procedure, public, pass :: add_value, get_nr_values, get_mean, get_stddev
        procedure, private :: write_stats
        generic :: write(formatted) => write_stats
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

    subroutine write_stats(stats, unit_nr, iotype, v_list, iostat, iomsg)
        implicit none
        class(descriptive_stats_t), intent(in) :: stats
        integer, intent(in) :: unit_nr
        character(len=*), intent(in) :: iotype
        integer, dimension(:), intent(in) :: v_list
        integer, intent(out) :: iostat
        character(len=*), intent(inout) :: iomsg
        character(len=1024) :: fmt_str

        if (size(v_list) == 4) then
            write (fmt_str, '(A, 2(A, I0, A, I0), A)') &
                '("n = ", I0', &
                ', ", mean = ", F', v_list(1), '.', v_list(2), &
                ', ", stddev = ", F', v_list(3), '.', v_list(4), &
                ')'
            write (unit=unit_nr, fmt=fmt_str, iostat=iostat, iomsg=iomsg) &
                stats%get_nr_values(), stats%get_mean(), stats%get_stddev()
        else
            write (unit=unit_nr, fmt=*, iostat=iostat, iomsg=iomsg) &
                stats%get_nr_values(), stats%get_mean(), stats%get_stddev()
        end if
    end subroutine write_stats

end module stats_mod
