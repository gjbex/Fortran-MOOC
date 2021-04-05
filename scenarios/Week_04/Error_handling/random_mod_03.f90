module random_mod
    use, intrinsic :: iso_fortran_env, only : I8 => INT64, error_unit
    implicit none

    private

    public :: random_bitvector

contains

    function random_bitvector(n, ierr) result(vector)
        implicit none
        integer(kind=I8), value :: n
        integer, optional, intent(out) :: ierr
        logical, dimension(:), allocatable :: vector
        real, dimension(:), allocatable :: real_vector
        integer :: status

        if (present(ierr)) ierr = 0
        allocate (real_vector(n), stat=status)
        if (status /= 0) then
            if (present(ierr)) then
                ierr = 1
                return
            else
                write (unit=error_unit, fmt='(A)') 'warning: can not allocated temporary vector'
                stop 10
            end if
        end if
        allocate (vector(n), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'warning: can not allocated bitvector'
            if (present(ierr)) then
                ierr = 1
                return
            else
                write (unit=error_unit, fmt='(A)') 'warning: can not allocated bitvector'
                stop 10
            end if
        end if
        call random_number(real_vector)
        vector = real_vector < 0.5
        deallocate (real_vector)
    end function random_bitvector

end module random_mod
