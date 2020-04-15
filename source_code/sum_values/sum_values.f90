program sum_values
    use, intrinsic :: iso_fortran_env, only : input_unit
    implicit none
    real :: val, total
    integer :: stat

    total = 0.0
    do
        read (unit=input_unit, fmt=*, iostat=stat) val
        if (stat < 0) exit
        if (stat > 0) cycle
        total = total + val
    end do
    print *, total

end program sum_values
