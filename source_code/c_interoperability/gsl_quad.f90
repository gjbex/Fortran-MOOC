program gsl_quad
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: functions_mod, only : func
    implicit none
    type, bind(C) :: gsl_function_t
        type(c_funptr) :: function
        type(c_ptr) :: params
    end type gsl_function_t
    interface
        function gsl_integration_workspace_alloc(ws_size) result(ws_ptr) bind(C)
            use, intrinsic :: iso_c_binding
            implicit none
            integer(kind=c_size_t), value :: ws_size
            type(c_ptr) :: ws_ptr
        end function gsl_integration_workspace_alloc
    end interface
    interface
        subroutine gsl_integration_workspace_free(ws_ptr) bind(C)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), value :: ws_ptr
        end subroutine gsl_integration_workspace_free
    end interface
    interface
        function gsl_integration_qag(f, a, b, epsabs, epsrel, limit, key, &
                                     workspace, result, abserr) result(istat) bind(C)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), value :: f
            real(kind=c_double), value :: a, b, epsabs, epsrel
            integer(kind=c_size_t), value :: limit
            integer(kind=c_int) :: key
            type(c_ptr), value :: workspace
            type(c_ptr), value :: result, abserr
            integer(kind=c_int) :: istat
        end function gsl_integration_qag
    end interface
    real(kind=c_double), dimension(3), target :: params
    type(gsl_function_t), target :: gsl_function
    integer(kind=c_size_t), parameter :: ws_size = 1000
    type(c_ptr) :: ws_ptr
    real(kind=c_double), parameter :: a = -2.0, b = 2.0, epsabs = 0.0, epsrel = 1.0e-7
    integer(kind=c_size_t), parameter :: limit = ws_size
    integer(Kind=c_int), parameter :: key = 5
    real(kind=c_double), target :: result, abserr
    integer(kind=c_int) :: istat

    ! initialize GSL function
    gsl_function%function = c_funloc(func)
    gsl_function%params = c_loc(params)

    ! initialize function parameters
    params = [ 1.0, -2.0, 3.0 ]

    ! create integration workspace
    ws_ptr = gsl_integration_workspace_alloc(ws_size)
    if (.not. c_associated(ws_ptr)) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate workspace'
        stop 1
    end if

    ! perform integration
    istat = gsl_integration_qag(c_loc(gsl_function), a, b, epsabs, epsrel, limit, key, &
                                ws_ptr, c_loc(result), c_loc(abserr))

    ! print result and error
    print '(2(A, E16.7))', 'result = ', result, ', abserr = ', abserr

    ! free integration workspace
    call gsl_integration_workspace_free(ws_ptr)

end program gsl_quad
