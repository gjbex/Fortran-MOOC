program use_c_funcs
    use, intrinsic :: iso_c_binding
    implicit none
    integer, parameter :: degree = 3
    integer, parameter :: vector_len = 5
    real(kind=c_double) :: x, a, b
    real(kind=c_double), dimension(degree + 1) :: coeff
    integer(kind=c_int), dimension(:), pointer :: random_values
    type(c_ptr) :: vector_ptr
    integer :: i
    interface
        function linear(x, a, b) result(res) bind(c)
            use, intrinsic :: iso_c_binding
            implicit none
            real(kind=c_double), value :: x, a, b
            real(kind=c_double) :: res
        end function linear
    end interface
    interface
        function polynomial(x, coeff, degree) result(res) bind(c)
            use, intrinsic :: iso_c_binding
            implicit none
            real(kind=c_double), value :: x
            real(kind=c_double), dimension(degree) :: coeff
            integer(kind=c_int), value :: degree
            real(kind=c_double) :: res
        end function polynomial
    end interface
    interface
        function random_vector(nr_values) result(vector) bind(c)
            use, intrinsic :: iso_c_binding
            implicit none
            integer(kind=c_int), value :: nr_values
            type(c_ptr) :: vector
        end function random_vector
    end interface

    x = real(3.0, kind=c_double)
    a = real(0.5, kind=c_double)
    b = real(1.3, kind=c_double)
    print '(F7.2)', linear(x, a, b)

    coeff = [ 1.2, 2.3, 3.4, 4.5 ]
    print '(F10.5)', polynomial(x, coeff, degree)

    vector_ptr = random_vector(vector_len)
    call c_f_pointer(vector_ptr, random_values, shape=[vector_len])
    do i = 1, vector_len
        print '(A, I0)', 'Fortran: ', random_values(i)
    end do
    deallocate(random_values)
end program use_c_funcs
