program build_load
    use :: dynamic_library_mod
    implicit none
    character(len=1024) :: file_name, lib_name, proc_name
    type(c_ptr) :: handle
    type(c_funptr) :: c_func
    ! Define interface of call-back routine.
    abstract interface
        subroutine called_proc (i, i2) bind(c)
            use, intrinsic :: iso_c_binding
            integer(c_int), intent(in) :: i
            integer(c_int), intent(out) :: i2
        end subroutine called_proc
    end interface
    procedure(called_proc), bind(c), pointer :: proc
    integer :: input, output


    if (command_argument_count() == 2) then
        call get_command_argument(1, file_name)
        call get_command_argument(2, proc_name)
    else
        write (unit=error_unit, fmt='(A)') &
            'error: file and/or function name missing'
        stop 10
    end if
    lib_name = compile_library(trim(file_name))
    handle = open_libary(lib_name)
    c_func = get_library_symbol(handle, proc_name)
    call c_f_procpointer(c_func, proc)
    do input = 0, 10
        call proc(input, output)
        print '(A, "(", I0, ") = ", I0)', trim(proc_name), input, output
    end do
    call close_library(handle)

end program build_load
