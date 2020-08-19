program test_permutations
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: utilities_mod
    implicit none
    integer, parameter :: nr_values = 15, nr_permutations = 20
    integer, dimension(nr_values) :: values
    integer :: i

    do i = 1, nr_values
        values(i) = i
    end do
    print '(*(I3))', values

    do i = 1, nr_permutations
        call fisher_yates_shuffle(values)
        print '(*(I3))', values
        call permutation_is_okay(values)
    end do

contains

    subroutine permutation_is_okay(values)
        implicit none
        integer, dimension(:), intent(inout) :: values
        logical, dimension(:), allocatable :: is_present
        integer :: i, idx

        allocate (is_present(size(values)))
        if (.not. allocated(is_present)) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate logical array'
            stop 1
        end if
        is_present = .false.
        do i = 1, size(values)
            idx = values(i)
            if (is_present(idx)) then
                write (unit=error_unit, fmt='(A, *(I3))') 'double entry in ', values
                exit
            else
                is_present(idx) = .true.
            end if
        end do
        if (.not. all(is_present)) then
            write (unit=error_unit, fmt='(A, *(I3))') 'not all entries in ', values
        end if
        deallocate(is_present)
    end subroutine permutation_is_okay

end program test_permutations
