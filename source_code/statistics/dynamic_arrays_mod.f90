module dynamic_arrays_mod
    implicit none
    private
    integer, public :: delta_size = 1000
    public :: add_array_value, trim_array

contains

    subroutine add_array_value(array, new_value, has_succeeded)
        use, intrinsic :: ieee_arithmetic, only : ieee_is_finite, ieee_value, &
            ieee_positive_inf
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real, dimension(:), allocatable, intent(inout) :: array
        real, value :: new_value
        logical, optional, intent(out) :: has_succeeded
        integer :: idx
        real, dimension(:), allocatable :: temp
        real :: infinity
        infinity = ieee_value(infinity, ieee_positive_inf)

        if (present(has_succeeded)) &
            has_succeeded = .true.

        ! initial array is not allocated, allocate and initialize all element to
        ! infinity
        if (.not. allocated(array)) &
            call allocate_array(array, delta_size, 'initial', init=infinity)
        
        ! array can not store an infinite values, check warn and return if necessary
        if (.not. ieee_is_finite(new_value)) then
            write (unit=error_unit, fmt='(A)') 'warning: can not store NaN value'
            if (present(has_succeeded)) &
                has_succeeded = .false.
            return
        end if

        ! find location of first empty element
        idx = findloc(array, infinity, dim=1)
        ! if the array is full, enlarge it by delta_size
        if (idx == 0) then
            call allocate_array(temp, size(array) + delta_size, 'extented')
            temp(1:size(array)) = array
            temp(size(array) + 1:size(temp)) = infinity
            idx = size(array) + 1
            call move_alloc(temp, array)
        end if
        ! store new element
        array(idx) = new_value
    end subroutine add_array_value

    subroutine trim_array(array)
        use, intrinsic :: ieee_arithmetic, only : ieee_is_finite, ieee_value, &
            ieee_positive_inf
        implicit none
        real, dimension(:), allocatable, intent(inout) :: array
        real, dimension(:), allocatable :: temp
        integer :: idx
        real :: infinity
        infinity = ieee_value(infinity, ieee_positive_inf)

        if (.not. allocated(array)) then
            allocate(array(0))
            return
        end if
        idx = findloc(array, infinity, dim=1)
        ! if the array is not full, create a new one of the required size
        if (idx > 0) then
            call allocate_array(temp, idx - 1, 'trimmed')
            if (idx > 1) temp = array(1:idx - 1)
            call move_alloc(temp, array)
        end if
    end subroutine trim_array

    subroutine allocate_array(array, array_size, msg, init)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real, dimension(:), allocatable, intent(inout) :: array
        integer, value :: array_size
        character(len=*),intent(in) :: msg
        real, value, optional :: init
        integer :: status

        ! if the array is allocated, deallocate it first
        if (allocated(array)) &
            deallocate(array)

        ! allocate for specified size and check 
        allocate(array(array_size), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(3A, I0)') &
                'error: can not allocate array ', trim(msg), &
                ' of size ', array_size
            stop 101
        end if

        ! if necessary, initialize array
        if (present(init)) &
            array = init
    end subroutine allocate_array

end module dynamic_arrays_mod
