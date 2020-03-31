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
        character(len=1), intent(out) :: op
        real(kind=dp), intent(out) :: x, y
        character(len=128) :: buffer
        
        if (command_argument_count() /= 3) then
            write (unit=error_unit, fmt='(A)') &
                'error: expecting real operand real on command line'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, '(E25.16)') x
        call get_command_argument(2, buffer)
        read (buffer, '(A1)') op
        call get_command_argument(3, buffer)
        read (buffer, '(E25.16)') y
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
            case ('/')
                calculate = x/y
            case default
                write (unit=error_unit, fmt='(3A)') &
                    'error: ', op, ' is not a valid operator'
                stop 1
        end select
    end function calculate

end program calculator
