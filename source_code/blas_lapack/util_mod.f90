module util_mod
    implicit none

    private

    public :: print_vector, print_matrix

contains

    subroutine print_vector(vector, label, fmt_str_in)
        implicit none
        real, dimension(:), intent(in) :: vector
        character(len=*), intent(in), optional :: label, fmt_str_in
        character(len=20) :: fmt_str

        if (present(fmt_str_in)) then
            fmt_str = fmt_str_in
        else
            fmt_str = '(*(E18.7))'
        end if
        if (present(label)) print '(A)', label
        print fmt_str, vector
    end subroutine print_vector

    subroutine print_matrix(matrix, label, fmt_str_in)
        implicit none
        real, dimension(:, :), intent(in) :: matrix
        character(len=*), intent(in), optional :: label, fmt_str_in
        character(len=20) :: fmt_str
        integer :: row

        if (present(fmt_str_in)) then
            fmt_str = fmt_str_in
        else
            fmt_str = '(*(E18.7))'
        end if
        if (present(label)) print '(A)', label
        do row = 1, size(matrix, 1)
            print fmt_str, matrix(row, :)
        end do
    end subroutine print_matrix

end module util_mod
