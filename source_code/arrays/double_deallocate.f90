program double_deallocate
    implicit none
    integer, parameter :: nr_values = 5
    integer, dimension(:), allocatable :: values
    integer :: i

    allocate(values(nr_values), source=[ (i, i=1, nr_values) ])
    print *, values
    deallocate (values)
    deallocate (values)
end program double_deallocate
