program reshape_test
    implicit none
    integer, parameter :: nr_values = 12
    integer :: i
    integer, dimension(nr_values) :: values = [ (i, i=1, nr_values) ]
    integer, dimension(2, 5) :: too_small
    integer, dimension(3, 5) :: too_large

    too_small = reshape(values, shape(too_small))
    call print_matrix(too_small)

    too_large = reshape(values, shape(too_large), pad=[-1, -2])
    call print_matrix(too_large)

contains

    subroutine print_matrix(A)
        implicit none
        integer, dimension(:, :), intent(in) :: A
        integer :: i

        do i = 1, size(A, 1)
            print *, A(i, :)
        end do
    end subroutine print_matrix

end program reshape_test
