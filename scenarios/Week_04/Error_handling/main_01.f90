program main
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    use :: random_mod, only : random_bitvector
    implicit none
    integer(Kind=I8) :: nr_values
    logical, dimension(:), allocatable :: bitvector

    call get_arguments(nr_values)
    bitvector = random_bitvector(nr_values)
    print '(A, I0)', 'nr. true: ', count(bitvector)

contains

    subroutine get_arguments(nr_values)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer(kind=I8), intent(out) :: nr_values
        character(len=1024) :: buffer, msg
        integer :: status

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') 'error: expecting number of values as argument'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, fmt=*, iomsg=msg, iostat=status) nr_values
        if (status /= 0) then
            write (unit=error_unit, fmt='(A, A)') 'error: ', trim(msg)
            stop 2
        end if
    end subroutine get_arguments

end program main
