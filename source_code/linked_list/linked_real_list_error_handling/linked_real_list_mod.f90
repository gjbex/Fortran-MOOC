module linked_real_list_mod
    implicit none

    private

    type, public :: list_item_t
        private
        real :: value
        type(list_item_t), pointer :: next => null()
    end type list_item_t

    type, public :: list_t
        private
        type(list_item_t), pointer :: first => null(), last => null()
        integer :: length
    contains
        procedure, public, pass :: prepend, append, insert, get_value, &
                                   shift, pop, remove, clear, &
                                   is_empty, get_length, find, show
       !  remove
    end type list_t

contains

    function is_empty(list) result(empty)
        implicit none
        class(list_t), intent(in) :: list
        logical :: empty

        empty = list%length == 0
    end function is_empty

    function get_length(list) result(length)
        implicit none
        class(list_t), intent(in) :: list
        integer :: length

        length = list%length
    end function get_length

    subroutine validate_allocation(istat)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, value :: istat

        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate list item'
            stop 1
        end if
    end subroutine validate_allocation

    subroutine prepend(list, val)
        implicit none
        class(list_t), intent(inout) :: list
        real, intent(in) :: val
        class(list_item_t), pointer :: first
        integer :: istat
        
        first => list%first
        allocate (list%first, source=list_item_t(val, first), stat=istat)
        call validate_allocation(istat)
        ! to make this work with the GNU compiler
        list%first%next => first
        if (list%is_empty()) list%last => list%first
        list%length = list%length + 1
    end subroutine prepend

    subroutine append(list, val)
        implicit none
        class(list_t), intent(inout) :: list
        real, intent(in) :: val
        integer :: istat

        if (list%is_empty()) then
            allocate (list%last, source=list_item_t(val, null()), stat=istat)
            call validate_allocation(istat)
            list%first => list%last
        else
            allocate(list%last%next, source=list_item_t(val, null()), stat=istat)
            call validate_allocation(istat)
            list%last => list%last%next
        end if
        list%length = list%length + 1
    end subroutine append

    subroutine validate_index(list, idx)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        class(list_t), intent(in) :: list
        integer, value :: idx

        if (idx < 1 .or. idx > list%get_length()) then
            write (unit=error_unit, fmt='(A, I0, A)') &
                'error: list index ', idx, ' is out of bounds'
            stop 2
        end if
    end subroutine validate_index

    subroutine insert(list, idx, val)
        implicit none
        class(list_t), intent(inout) :: list
        integer, value :: idx
        real, intent(in) :: val
        type(list_item_t), pointer :: tmp, next_item
        integer :: istat

        if (list%get_length() <= 1 .or. idx == 1) then
            call list%prepend(val)
        else
            call validate_index(list, idx)
            tmp => get_item(list, idx - 1)
            next_item => tmp%next
            allocate (tmp%next, source=list_item_t(val, next_item), stat=istat)
            call validate_allocation(istat)
            list%length = list%length + 1
        end if
    end subroutine insert

    function get_item(list, idx) result(item)
        implicit none
        class(list_t), intent(in) :: list
        integer, intent(in) :: idx
        type(list_item_t), pointer :: item
        integer :: i
        
        item => list%first
        do i = 2, idx
            item => item%next
        end do
    end function get_item

    function get_value(list, idx) result(val)
        implicit none
        class(list_t), intent(in) :: list
        integer, intent(in) :: idx
        real :: val
        type(list_item_t), pointer :: tmp
        
        call validate_index(list, idx)
        tmp => get_item(list, idx)
        val = tmp%value
    end function get_value

    subroutine validate_non_empty(list)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        class(list_t), intent(in) :: list

        if (list%is_empty()) then
            write (error_unit, fmt='(A)') &
                'error: items can not be removed from an empty list'
            stop 3
        end if
    end subroutine validate_non_empty

    function shift(list) result(val)
        implicit none
        class(list_t), intent(inout) :: list
        real :: val
        type(list_item_t), pointer :: tmp

        call validate_non_empty(list)
        tmp => list%first%next
        val = list%first%value
        deallocate(list%first)
        list%first => tmp
        list%length = list%length - 1
    end function shift

    function pop(list) result(val)
        implicit none
        class(list_t), intent(inout) :: list
        real :: val
        type(list_item_t), pointer :: tmp

        call validate_non_empty(list)
        val = list%last%value
        if (list%get_length() == 1) then
            deallocate(list%last)
            list%first => null()
            list%last => null()
        else
            tmp => get_item(list, list%length - 1)
            deallocate(list%last)
            tmp%next => null()
            list%last => tmp
        end if
        list%length = list%length - 1
    end function pop

    function remove(list, idx) result(val)
        implicit none
        class(list_t), intent(inout) :: list
        integer, value :: idx
        real :: val
        type(list_item_t), pointer :: tmp, next_item

        if (list%get_length() == 1 .or. idx == 1) then
            val = list%shift()
        else if (idx > 0 .and. idx == list%get_length()) then
            val = list%pop()
        else
            call validate_index(list, idx)
            tmp => get_item(list, idx - 1)
            next_item => tmp%next%next
            val = tmp%next%value
            deallocate(tmp%next)
            tmp%next => next_item 
            list%length = list%length - 1
        end if
    end function remove

    subroutine clear(list)
        implicit none
        class(list_t), intent(inout) :: list
        real :: val

        do while (.not. list%is_empty())
            val = list%shift()
        end do
    end subroutine clear

    function find(list, val) result(idx)
        implicit none
        class(list_t), intent(in) :: list
        real, intent(in) :: val
        integer :: idx, i

        idx = -1
        do i = 1, list%get_length()
            if (val == list%get_value(i)) then
                idx = i
                exit
            end if
        end do
    end function find

    subroutine show(list)
        implicit none
        class(list_t), intent(in) :: list
        integer :: i

        do i = 1, list%get_length()
            print '(I10, E15.7)', i, list%get_value(i)
        end do
        if (list%is_empty()) print '(A)', 'empty list'
    end subroutine show

end module linked_real_list_mod
