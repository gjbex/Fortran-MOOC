program dynamic_array_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    use dynamic_arrays_mod, only : delta_size, trim_array, add_array_value
    implicit none
    integer :: i
    real :: x
    real, dimension(:), allocatable :: array

    ! for testing purposes, set delta_size to a low value
    delta_size = 10

    ! check for size zero array
    call trim_array(array)
    print '("size = ", I0)', size(array)

    ! add 15 values, check size
    x = 0.0
    do i = 1, 15
        x = x + 1.0
        call add_array_value(array, x)
    end do
    print '("size = ", I0)', size(array)

    ! trim, check size and show values
    call trim_array(array)
    print '("size = ", I0)', size(array)
    print *, array

    deallocate(array)
end program dynamic_array_test
