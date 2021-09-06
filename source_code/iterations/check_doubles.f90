program check_doublees
    implicit none
    integer, dimension(5) :: data1 = [1, 2, 3, 4, 5], &
                             data2 = [1, 2, 1, 4, 5], &
                             data3 = [1, 2, 3, 4, 4]

    print *, data1, has_duplicates(data1)
    print *, data2, has_duplicates(data2)
    print *, data3, has_duplicates(data3)


contains

    function has_duplicates(data) result(result)
        integer, dimension(:), intent(in) :: data
        logical :: result
        integer :: i, j

        result = .false.
        outer: do i = 1, size(data) - 1
            do j = i + 1, size(data)
                if (data(i) == data(j)) then
                    result = .true.
                    exit outer
                end if
            end do
        end do outer
    end function has_duplicates

end program check_doublees
