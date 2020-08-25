program test_multiple_lists
    use :: integer_list_mod, integer_list_t => list_t
    use :: real_list_mod, real_list_t => list_t
    implicit none
    integer, parameter :: nr_items = 5
    type(integer_list_t) :: int_list
    type(real_list_t) :: real_list
    integer :: i
    real :: x

    x = 1.2
    do i = 1, nr_items
        call int_list%append(2*i - 1)
        call real_list%append(x)
        x = x + 1.1
    end do
    call int_list%show()
    call real_list%show()
end program test_multiple_lists
