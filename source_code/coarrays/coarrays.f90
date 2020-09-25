program coarray_test
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    implicit none
    integer(kind=I8), parameter :: max_value = 100000000000
    integer(kind=I8), codimension[*] :: total
    integer(kind=I8) :: i, overall_total

    do i = this_image(), max_value, num_images()
        total = total + i
    end do
    sync all
    overall_total = 0
    do i = 1, num_images()
        overall_total = overall_total + total[i]
    end do

    if (this_image() == 1) &
        print '(A, I0)', 'total = ', overall_total

end program coarray_test
