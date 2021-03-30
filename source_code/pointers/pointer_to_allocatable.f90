program pointer_to_allocatable
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_values = 5
    integer, dimension(:), allocatable, target :: avalues
    integer, dimension(:), pointer :: values, p
    integer :: status

    allocate (values(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate values'
        stop 1
    end if

    allocate (avalues(nr_values), stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate values'
        stop 1
    end if

    ! doesn't compile since value is not allocatable
    ! print '(A, L)', 'values allocated: ', allocated(values)
    print '(A, L)', 'values associated: ', associated(values)

    p => values
    ! doesn't compile since p is not allocatable
    ! print '(A, L)', 'p allocated: ', allocated(p)
    print '(A, L)', 'p associated: ', associated(p)

    deallocate (values)
    print '(A, L)', 'values associated: ', associated(values)
    print '(A, L)', 'p associated: ', associated(p)
    nullify (p)

    p => avalues
    print '(A, L)', 'avalues allocated: ', allocated(avalues)
    ! doesn't compile
    ! print '(A, L)', 'avalues associated: ', associated(avalues)
    ! doesn't compile since p is not allocatable
    ! print '(A, L)', 'p allocated: ', allocated(p)
    print '(A, L)', 'p associated: ', associated(p)

    deallocate (p)
    print '(A, L)', 'avalues allocated: ', allocated(avalues)
    print '(A, L)', 'p associated: ', associated(p)

end program pointer_to_allocatable
