module dynamic_library_mod
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    public :: open_libary, get_library_symbol, close_library

contains

    function compile_library(file_name) result(lib_name)
        implicit none
        character(len=*), intent(in) :: file_name
        character(len=1024) :: lib_name
        integer :: status, pos
        character(len=1024) :: cmd, msg

        pos = index(file_name, '.', back=.true.)
        lib_name = file_name(1:pos - 1) // '.so'
        write (cmd, fmt='("gfortran -O2 -shared -g -o ", A, " ", A)') &
            trim(lib_name), trim(file_name)
        write (unit=error_unit, fmt='(2A)') 'executing: ', trim(cmd)
        call execute_command_line(trim(cmd), exitstat=status, &
                                  cmdmsg=msg)
        if (status /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', msg
            stop 3
        end if
    end function compile_library

    function open_libary(file_name) result(handle)
        implicit none
        character(len=*), intent(in) :: file_name
        type(c_ptr) :: handle
        ! value extracted from the C header file
        integer(c_int), parameter :: RTLD_LAZY = 1
        interface
            function dlopen(filename, mode) bind(c, name="dlopen")
                ! void *dlopen(const char *filename, int mode);
                use iso_c_binding
                implicit none
                type(c_ptr) :: dlopen
                character(c_char), intent(in) :: filename(*)
                integer(c_int), value :: mode
            end function
        end interface

        handle = dlopen(trim(file_name) // c_null_char, RTLD_LAZY)
        if (.not. c_associated(handle)) then
            write (unit=error_unit, fmt='(2A)') &
                'error: unable to load shared object ', file_name
            stop 1
        end if
    end function open_libary

    function get_library_symbol(handle, function_name) result(proc_addr)
        implicit none
        type(c_ptr), intent(inout) :: handle
        character(len=*), intent(in) :: function_name
        type(c_funptr) :: proc_addr
        interface
            function dlsym(handle, name) bind(c, name="dlsym")
                ! void *dlsym(void *handle, const char *name);
                use iso_c_binding
                implicit none
                type(c_funptr) :: dlsym
                type(c_ptr), value :: handle
                character(c_char), intent(in) :: name(*)
            end function
        end interface

        proc_addr = dlsym(handle, trim(function_name) // c_null_char)
        if (.not. c_associated(proc_addr)) then
            write (unit=error_unit, fmt='(2A)') &
                'error: unable to load the procedure ', &
                trim(function_name)
            stop 2
        end if
    end function get_library_symbol

    subroutine close_library(handle)
        implicit none
        type(c_ptr), intent(inout) :: handle
        integer :: status
        interface
            function dlclose(handle) bind(c,name="dlclose")
                ! int dlclose(void *handle);
                use iso_c_binding
                implicit none
                integer(c_int) :: dlclose
                type(c_ptr), value :: handle
            end function
        end interface

        status = dlclose(handle)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') &
                'error: closing shared object failed'
        end if
    end subroutine close_library

end module dynamic_library_mod
