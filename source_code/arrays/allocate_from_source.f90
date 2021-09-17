program allocate_from_source
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, dimension(3, 2) :: A
    integer, dimension(:, :), allocatable :: B
    integer :: i, status

    A = reshape([ (i, i=1, size(A)) ], shape(A))
    allocate(B, source=A, stat=status)
    if (status /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate array'
        stop 1
    end if
    do i = 1, size(A, 1)
        print '(*(I4))', A(i, :)
    end do
    deallocate (B)
end program allocate_from_source
