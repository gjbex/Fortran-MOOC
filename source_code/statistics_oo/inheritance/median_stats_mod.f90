module median_stats_mod
    use :: stats_mod
    use :: quicksort_mod
    implicit none

    private

    type, extends(descriptive_stats_t), public :: median_stats_t
        private
        real, dimension(:), allocatable :: values
    contains
        procedure, public, pass :: add_value, get_median
        final :: finalize_stats
    end type median_stats_t
    interface median_stats_t
        module procedure init_stats
    end interface

contains

    function init_stats(nr_values) result(stats)
        use, intrinsic :: iso_fortran_env, only : error_unit
        integer, value :: nr_values
        type(median_stats_t) :: stats

        allocate(stats%values(nr_values))
        if (.not. allocated(stats%values)) then
            write (unit=error_unit, fmt='(A, I0, A)') &
                'error: can not allocated memory for ', nr_values, ' values'
            stop 3
        end if
    end function init_stats

    subroutine add_value(stats, new_value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        class(median_stats_t), intent(inout) :: stats
        real, value :: new_value

        if (stats%get_nr_values() + 1 > size(stats%values)) then
            write (unit=error_unit, fmt='(A, I0, A)') &
                'error: capacity exceeded, maximum ', size(stats%values), &
                ' can be processed'
            stop 4
        end if
        call stats%descriptive_stats_t%add_value(new_value)
        stats%values(stats%get_nr_values()) = new_value
    end subroutine add_value

    function get_median(stats) result(median_value)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        class(median_stats_t), intent(inout) :: stats
        real :: median_value

        if (stats%get_nr_values() == 0) then
            write (unit=error_unit, fmt='(A)') &
                'error: too few data value to compute median'
            stop 1
        end if
        associate(n => stats%get_nr_values(), values => stats%values)
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
        type(median_stats_t), intent(inout) :: stats
        integer :: istat

        deallocate(stats%values, stat=istat)
    end subroutine finalize_stats

end module median_stats_mod
