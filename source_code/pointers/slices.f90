program slices
    implicit none
    integer :: i
    integer, dimension(3, 2), target :: A = reshape( [(i, i=1, 6)], [3, 2])
    integer, dimension(:), pointer :: p => null()

    print '(A)', 'original:'
    call print_2d_array(A)

    p => A(2, :)
    call times2(p)
    print '(A)', 'second row x 2:'
    call print_2d_array(A)

    p => A(:, 1)
    call times2(p)
    print '(A)', 'first column x 2:'
    call print_2d_array(A)

    p => A(1:3:2, 2)
    call times2(p)
    print '(A)', 'first and third element of second column x 2:'
    call print_2d_array(A)

contains

    subroutine times2(vector)
        implicit none
        integer, dimension(:), intent(inout) :: vector

        vector = 2*vector
    end subroutine times2

    subroutine print_2d_array(A)
        implicit none
        integer, dimension(:, :), intent(in) :: A
        integer :: row

        do row = 1, size(A, 1)
            print '(*(I4))', A(row, :)
        end do
    end subroutine print_2d_array

end program slices
