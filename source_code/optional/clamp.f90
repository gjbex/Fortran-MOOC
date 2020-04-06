program clamp_program
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none
    integer, parameter :: NR_VALUES = 5
    real(kind=DP), dimension(NR_VALUES) :: values = [ -7.3, -3.3, 0.0, 1.5, 7.9 ]
    real(kind=DP) :: value, value_opt
    integer :: i

    do i = 1, NR_VALUES
        value = values(i)
        value_opt = values(i)
        call clamp(val=value, max_val=5.0_DP)
        call clamp(val=value_opt, min_val=-5.0_DP, max_val=5.0_DP)
        print *, value, value_opt
    end do

contains

    subroutine clamp(val, min_val, max_val)
        implicit none
        real(kind=DP), intent(inout) :: val
        real(kind=DP), value, optional :: min_val
        real(kind=DP), value :: max_val

        if (.not. present(min_val)) min_val = -max_val
        if (val < min_val) then
            val = min_val
        else if (max_val < val) then
            val = max_val
        end if
    end subroutine clamp

end program clamp_program
