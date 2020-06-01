program kaprekar
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_digits = 4
    integer, dimension(:), allocatable :: digits
    integer :: number, prev_number, small, large, istat

    number = get_argument()
    allocate(digits(nr_digits), stat=istat)
    if (istat /= 0) then
        write (error_unit, '(A)') 'Error: can not allocate array'
        stop 5
    end if
    prev_number = 0
    do while (number /= prev_number)
        call number2digits(number, digits)
        call sort_digits(digits)
        small = digits2number(digits)
        large = reverse_digits2number(digits)
        prev_number = number
        number = large - small
    end do
    print '(I0)', number

contains

    integer function get_argument() result(number)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        character(len=80) :: buffer
        integer :: istat, first_digit, n, i
        logical :: okay

        if (command_argument_count() /= 1) then
            write (error_unit, '(A)') &
                'Error: expecting a single number as argument'
            stop 1
        end if
        call get_command_argument(1, buffer)
        read (buffer, '(I10)', iostat=istat) number
        if (istat /= 0) then
            write (error_unit, '(A)') &
                'Error: expecting as integer as argument'
            stop 2
        end if
        if (number < 1 .or.  number > 9999) then
            write (error_unit, '(A)') &
                'Error: argument should be between 1 and 9999'
            stop 3
        endif
        okay = .false.
        first_digit = mod(number, 10)
        n = number/10
        do i = 2, 4
            if (first_digit /= mod(n, 10)) then
                okay = .true.
            exit
            end if
            n = n/10
        end do
        if (.not.  okay) then
            write (error_unit, '(A)') &
                'Error: number must have at least two distinct digits'
            stop 4
        end if

    end function get_argument

    subroutine number2digits(number, digits)
        implicit none
        integer, value :: number
        integer, dimension(:), intent(inout) :: digits
        integer :: i

        do i = 1, size(digits)
            digits(i) = mod(number, 10)
            number = number/10
        end do

    end subroutine number2digits

    integer function digits2number(digits) result(number)
        implicit none
        integer, dimension(:), intent(in) :: digits
        integer :: factor, i

        number = 0
        factor = 1
        do i = 1, size(digits)
            number = number + factor*digits(i)
            factor = factor*10
        end do

    end function digits2number

    integer function reverse_digits2number(digits) result(number)
        implicit none
        integer, dimension(:), intent(in) :: digits
        integer :: factor, i

        number = 0
        factor = 1
        do i = size(digits), 1, -1
            number = number + factor*digits(i)
            factor = factor*10
        end do

    end function reverse_digits2number

    subroutine sort_digits(digits)
        implicit none
        integer, dimension(:), intent(inout) :: digits
        integer :: i, j, index, tmp

        do i = 1, size(digits)
            index = i
            do j = i + 1, size(digits)
                if (digits(index) < digits(j)) &
                    index = j
            end do
            tmp = digits(index)
            digits(index) = digits(i)
            digits(i) = tmp
        end do

    end subroutine sort_digits

end program kaprekar
