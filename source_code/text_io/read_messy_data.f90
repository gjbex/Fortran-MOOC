program read_messy_data
    use, intrinsic :: iso_fortran_env, only : input_unit, error_unit
    implicit none
    integer, parameter ::  nr_values = 3
    real, dimension(nr_values) :: real_values
    integer, dimension(nr_values) :: int_values
    logical, dimension(nr_values) :: logical_values
    character(len=20), dimension(nr_values) :: char_values
    integer :: i, istat
    character(len=1024) :: msg

    do i = 1, nr_values
        read (unit=input_unit, fmt=*, iostat=istat, iomsg=msg) &
            real_values(i), int_values(i), logical_values(i), char_values(i)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 1
        end if
    end do

    print '(*(E20.7))', real_values
    print '(*(I20))', int_values
    print '(*(L20))', logical_values
    print '(*(A20))', char_values

end program read_messy_data
