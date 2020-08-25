program test_list
    use :: real_list_mod, real_list_t => list_t
    implicit none
    integer, parameter :: nr_items = 5
    type(real_list_t) :: list
    integer :: i
    real :: x

    print '(A)', 'fill list with append'
    x = 1.2
    do i = 1, nr_items
        call list%append(x)
        x = x + 1.1
    end do
    call list%show()

    print '(A)', 'add to list with prepend'
    x = -1.2
    do i = 1, nr_items
        call list%prepend(x)
        x = x - 1.1
    end do
    call list%show()

    print '(A)', 'clear list with shift'
    do while (.not. list%is_empty())
        x = list%shift()
        print '(A, E15.7)', 'removed ', x
    end do

    print '(A)', 'fill list with append'
    x = 1.2
    do i = 1, nr_items
        call list%append(x)
        x = x + 1.1
    end do
    call list%show()

    print '(A)', 'clear list with pop'
    do while (.not. list%is_empty())
        x = list%pop()
        print '(A, E15.7)', 'removed ', x
    end do

    print '(A)', 'fill list with append'
    x = 1.2
    do i = 1, nr_items
        call list%append(x)
        x = x + 1.1
    end do
    call list%show()

    print '(A)', 'insert items'
    do i = 1, nr_items
        x = list%get_value(2*i - 1)
        call list%insert(2*i - 1, -x)
    end do
    call list%show()

    print '(A, E15.7)', 'remove first: ', list%remove(1)
    call list%show()
    print '(A, E15.7)', 'remove second: ', list%remove(2)
    call list%show()
    print '(A, E15.7)', 'remove last: ', list%remove(list%get_length())
    call list%show()
    print '(A, E15.7)', 'remove one but last: ', list%remove(list%get_length() - 1)
    call list%show()

    print '(E15.7, A, I0)', 3.14, ' at ', list%find(3.14)
    print '(E15.7, A, I0)', 3.4, ' at ', list%find(3.4)

    print '(A)', 'clean list'
    call list%clear()

end program test_list
