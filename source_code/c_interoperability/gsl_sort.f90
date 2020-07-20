program use_gsl
    use, intrinsic :: iso_c_binding
    implicit none
    interface
        subroutine gsl_sort(data, stride, n) bind(c)
            use, intrinsic :: iso_c_binding
            implicit none
            real(c_double), dimension(n) :: data
            integer(kind=c_size_t), value :: stride, n
        end subroutine gsl_sort
    end interface
    integer(kind=c_size_t), parameter :: nr_values = 10, stride = 1
    real(kind=c_double), dimension(nr_values) :: values

    call random_number(values)
    print '("original:")'
    print '(*(F25.15, /))', values
    call gsl_sort(values, stride, nr_values)
    print '("sorted:")'
    print '(*(F25.15, /))', values
end program use_gsl
