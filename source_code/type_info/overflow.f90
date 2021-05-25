program overflow
    use, intrinsic :: iso_fortran_env, only : INT8
    implicit none
    integer(kind=INT8) :: val
    integer :: i

    val = 125
    do i = 1, 6
        print *, val
        val = val + 1_INT8
    end do
end program overflow
