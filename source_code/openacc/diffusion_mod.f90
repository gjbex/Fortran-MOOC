module diffusion_mod
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, error_unit
    implicit none

    public :: diffusion_step

contains

    subroutine init_system(n, temp, new_temp)
        implicit none
        integer, value :: n
        real(kind=SP), dimension(:, :), allocatable, intent(out) :: temp
        real(kind=SP), dimension(:, :), allocatable, intent(out) :: new_temp
        integer :: istat

        allocate (temp(n, n), new_temp(n, n), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not allocate arrays'
            stop 1
        end if
        temp(1, :) = 1.0_SP
        temp(2:, :) = 0.0_SP
        new_temp = temp
        !$acc enter data copyin(temp, new_temp)
    end subroutine init_system

    subroutine diffusion_step(temp, new_temp, error)
        implicit none
        real(kind=SP), dimension(:, :), intent(in) :: temp
        real(kind=SP), dimension(:, :), intent(out) :: new_temp
        real(kind=SP) :: error
        integer :: i, j

        error = 0.0_SP
        !$acc kernels present(temp, new_temp)
        do j = 2, size(temp, 2) - 1
            do i = 2, size(temp, 1) - 1
                new_temp(i, j) = 0.25_SP*(temp(i - 1, j) + temp(i, j - 1) + &
                                          temp(i + 1, j) + temp(i, j + 1))
                error = max(error, abs(new_temp(i, j) - temp(i, j)))
            end do
        end do
        !$acc end kernels
    end subroutine diffusion_step

    subroutine swap(temp, new_temp)
        implicit none
        real(kind=SP), dimension(:, :), intent(in) :: temp
        real(kind=SP), dimension(:, :), intent(out) :: new_temp
        integer :: i, j

        !$acc kernels present(temp, new_temp)
        do j = 1, size(temp, 2)
            do i = 1, size(temp, 1)
                new_temp(i, j) = temp(i, j)
            end do
        end do
        !$acc end kernels
    end subroutine swap

    subroutine dealloc_system(temp, new_temp)
        real(kind=SP), dimension(:, :), allocatable, intent(inout) :: temp, new_temp

        !$acc exit data delete(temp, new_temp)
        deallocate (temp, new_temp)
    end subroutine dealloc_system

    subroutine print_system(temp)
        implicit none
        real(kind=SP), dimension(:, :), intent(in) :: temp
        integer :: i

        do i = 1, size(temp, 1)
             print '(*(E10.3))', temp(i, :)
         end do
    end subroutine print_system

end module diffusion_mod
