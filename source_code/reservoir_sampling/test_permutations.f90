module m_hash_counter
#define FFH_KEY_TYPE character(len=10)
#define FFH_KEY_IS_STRING
#define FFH_VAL_TYPE integer
#include "ffhash_inc.f90"
end module m_hash_counter

program test_permutations
    use, intrinsic :: iso_fortran_env, only : error_unit
    use m_hash_counter, only : ffhcounter_t => ffh_t
    use :: utilities_mod
    implicit none
    integer, parameter :: nr_values = 15, nr_permutations = 20, &
                          nr_stats_values = 5, nr_stats_permutations = 1000000
    integer, dimension(nr_values) :: values
    integer, dimension(nr_stats_values) :: stats_values
    integer :: i, old_count, idx, nr_keys, total
    type(ffhcounter_t) :: counter
    character(len=10) :: key
    character(len=10), dimension(120) :: keys

    do i = 1, nr_values
        values(i) = i
    end do
    print '(*(I3))', values

    do i = 1, nr_permutations
        call fisher_yates_shuffle(values)
        print '(*(I3))', values
        call permutation_is_okay(values)
    end do

    do i = 1, nr_stats_values
        stats_values(i) = i
    end do

    nr_keys = 0
    do i = 1, nr_stats_permutations
        call fisher_yates_shuffle(stats_values)
        write (key, fmt='(*(I2))') stats_values
        idx = counter%get_index(key)
        if (idx == -1) then
            nr_keys = nr_keys + 1
            keys(nr_keys) = key
        end if
        old_count = counter%fget_value_or(key, 0)
        call counter%ustore_value(key, old_count + 1)
    end do

    total = 0
    do i = 1, nr_keys
        total = total + counter%fget_value(keys(i))
        print '(A10, I10)', keys(i), counter%fget_value(keys(i))
    end do
    print '(A, I0)', 'keys = ', nr_keys
    print '(A, I0)', 'total = ', total
    print '(A, I0)', 'buckets = ', counter%n_buckets

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
