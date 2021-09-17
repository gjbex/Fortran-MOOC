module meshgrid_mod
    implicit none

    public :: meshgrid

contains

    subroutine meshgrid(x_vals, y_vals, X, Y)
        use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
        implicit none
        real(kind=DP), dimension(:), intent(in) :: x_vals, y_vals
        real(kind=DP), dimension(:, :), allocatable, intent(out) :: X, Y
        integer :: status, i

        ! allocate new arrays
        allocate (X(size(y_vals), size(x_vals)), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate array'
            stop 1
        end if
        allocate (Y(size(y_vals), size(x_vals)), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate array'
            stop 1
        end if

        do i = 1, size(y_vals)
            X(i, :) = x_vals
        end do   
        do i = 1, size(x_vals)
            Y(:, i) = y_vals
        end do
    end subroutine meshgrid

end module meshgrid_mod
