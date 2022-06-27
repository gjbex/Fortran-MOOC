program format_str
    implicit none
    integer :: nr_digits
    character(len=20) :: fmt_str
    real :: value

    nr_digits = 3
    value = acos(-1.0)
    write (fmt_str, fmt="('(E', I0, '.', I0, ')')") nr_digits + 7, nr_digits
    print fmt_str, value
end program format_str
