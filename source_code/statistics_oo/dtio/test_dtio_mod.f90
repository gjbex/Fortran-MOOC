module test_mod
    implicit none

    private

    type, public :: my_t
        private
        real :: x, y
    contains
        procedure, private :: write_my_t
        generic :: write(formatted) => write_my_t
    end type my_t

    interface my_t
        module procedure init_my_t
    end interface

contains

    function init_my_t(x, y) result(my_val)
        implicit none
        real, value :: x, y
        type(my_t) :: my_val

        my_val%x = x
        my_val%y = y
    end function init_my_t

    subroutine write_my_t(this, unit_nr, iotype, v_list, iostat, iomsg)
        implicit none
        class(my_t), intent(in) :: this
        integer, intent(in) :: unit_nr
        character(*), intent(in) :: iotype
        integer, dimension(:), intent(in) :: v_list
        integer, intent(out) :: iostat
        character(*), intent(inout) :: iomsg
        character(len=128) :: fmt_str

        if (size(v_list) == 2) then
            write (fmt_str, fmt='("(", """", A, " = "", F", I0, ".", I0, ", ", """, ", A, " = "", F", I0, ".", I0, ")")') &
                'x', v_list(1), v_list(2), &
                'y', v_list(1), v_list(2)
        else
            fmt_str = '("x = ", F0.5, ", y = ", F0.5)'
        end if
        write (unit=unit_nr, fmt=fmt_str, iostat=iostat, iomsg=iomsg) this%x, this%y
    end subroutine write_my_t

end module test_mod
