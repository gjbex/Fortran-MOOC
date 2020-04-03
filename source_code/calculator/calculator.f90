program calculator
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none
    real(kind=DP) :: x, y
    character(len=1) :: op

    call get_expression(op, x, y)
    print '(E15.7)', calculate(op, x, y)

contains

    subroutine get_expression(op, x, y)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real(kind=DP), intent(out) :: x, y
        character, intent(out) :: op
        character(len=1024) :: string
        integer :: status
        character(len=1024) :: msg

        if (command_argument_count() /= 1) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting real operand real on command line'
            stop 1
        end if
        call get_command_argument(1, string)
        print *, trim(string)
        read(string, fmt=*, iostat=status, iomsg=msg) x, op, y
        if (status /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                'parse error: ', msg
            stop 2
        end if
    end subroutine get_expression

    real(kind=DP) function calculate(op, x, y)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        character(len=1), intent(in) :: op
        real(kind=DP), intent(in) :: x, y

        select case (op)
            case ('+')
                calculate = x + y
            case ('-')
                calculate = x - y
            case ('*')
                calculate = x*y
            case default
                write (unit=error_unit, fmt='(3A)') &
                    'error: ', op, ' is not a valid operator'
                stop 3
        end select
    end function calculate

end program calculator
