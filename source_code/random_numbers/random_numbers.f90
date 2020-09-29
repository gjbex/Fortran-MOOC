program random_numbers
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_vals = 3
    integer :: seed_size, istat, i
    integer, dimension(:), allocatable :: seed_vals, new_seed_vals
    real :: r

    ! check how many integers are required to seed the RNG
    call random_seed(size=seed_size)
    print '(A, I0)', 'number of seeds: ', seed_size

    ! allocate the array to hold the seeds
    allocate (seed_vals(seed_size), new_seed_vals(seed_size), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate seed'
        stop 1
    end if

    ! get the current seed values
    call random_seed(get=seed_vals)
    print '(A, *(I12))', 'seeds: ', seed_vals

    ! print some random numbers
    print '(A)', 'values:'
    do i = 1, nr_vals
        call random_number(r)
        print '(F10.7)', r
    end do

    ! get current seed
    call random_seed(get=new_seed_vals)
    print '(A, *(I12))', 'current seeds: ', new_seed_vals

    ! reseed
    call random_seed(put=seed_vals)
    print '(A)', 'values after reseed:'
    do i = 1, nr_vals
        call random_number(r)
        print '(F10.7)', r
    end do

    ! clean up
    deallocate(seed_vals)
end program random_numbers
