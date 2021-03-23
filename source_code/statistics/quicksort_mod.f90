module quicksort_mod
    implicit none

    private
    public :: qsort, lampsort

contains

    subroutine qsort(values)
        implicit none
        real, dimension(:), intent(inout) :: values

        call qsort_r(values, 1, size(values))
    end subroutine qsort

    recursive subroutine qsort_r(values, low, high)
        implicit none
        real, dimension(:), intent(inout) :: values
        integer, intent(in) :: low, high
        integer :: pivot

        if (low < high) then
            pivot = find_pivot(values, low, high)
            call qsort_r(values, low, pivot - 1)
            call qsort_r(values, pivot + 1, high)
        end if
    end subroutine qsort_r

    subroutine lampsort(values)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real, dimension(:), intent(inout) :: values
        integer, dimension(:, :), allocatable :: indices
        integer :: current_indices, low, high, pivot, status

        allocate(indices(2, 1 + size(values)), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not allocate indices array'
            stop 51
        end if
        current_indices = 1
        indices(1, current_indices) = 1
        indices(2, current_indices) = size(values)
        do while (current_indices > 0)
            low = indices(1, current_indices)
            high = indices(2, current_indices)
            current_indices = current_indices - 1
            if (low < high) then
                pivot = find_pivot(values, low, high)
                ! print *, low, pivot, high, values(low), values(high)
                if ((pivot - 1) - low > 0) then
                    current_indices = current_indices + 1
                    indices(1, current_indices) = low
                    indices(2, current_indices) = pivot - 1
                end if
                if (high - (pivot + 1) > 0) then
                    current_indices = current_indices + 1
                    indices(1, current_indices) = pivot + 1
                    indices(2, current_indices) = high
                end if
            end if
        end do
    end subroutine lampsort

    subroutine swap_values(values, i, j)
        implicit none
        real, dimension(:), intent(inout) :: values
        integer, intent(in) :: i, j
        real :: tmp

        tmp = values(i)
        values(i) = values(j)
        values(j) = tmp
    end subroutine swap_values

    function find_pivot(values, low, high) result(pivot)
        implicit none
        real, dimension(:), intent(inout) :: values
        integer, intent(in) :: low, high
        integer :: pivot
        real :: pivot_value
        integer :: i

        pivot_value = values(high)
        pivot = low
        do i = low, high - 1
            if (values(i) < pivot_value) then
                call swap_values(values, i, pivot)
                pivot = pivot + 1
            end if
        end do
        call swap_values(values, pivot, high)
    end function find_pivot

end module quicksort_mod
