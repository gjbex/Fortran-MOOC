module julia_set_omp_mod
    use, intrinsic :: iso_fortran_env, only : dp => REAL64
    use julia_set_mod, only : julia_iterate
    implicit none

    public :: julia_compute

contains

    subroutine julia_compute(z, n)
        implicit none
        complex(kind=dp), dimension(:, :), intent(in) :: z
        integer, dimension(:, :), intent(inout) :: n
        integer :: i, j

        !$omp parallel do default(none) private(i) shared(z, n)
        do j = 1, size(z, 2)
            do i = 1, size(z, 1)
                n(i, j) = julia_iterate(z(i, j))
            end do
        end do
        !$omp end parallel do
    end subroutine julia_compute

end module julia_set_omp_mod
