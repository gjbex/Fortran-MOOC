program palindromes
    use, intrinsic :: iso_fortran_env, only  : input_unit, iostat_end
    implicit none
    character(len=1024) :: buffer, msg
    integer :: istat

    do
        read(unit=input_unit, fmt=*, iostat=istat, iomsg=msg) buffer
        if (istat == iostat_end) exit
        print '(L1)', is_palindrome(buffer)
    end do

contains

    function is_palindrome(phrase) result(palindrome)
        implicit none
        character(len=*), intent(in) :: phrase
        logical :: palindrome
        integer :: i, n

        n = len_trim(phrase)
        palindrome = .true.
        do i = 1, n/2
            if (phrase(i:i) /= phrase(n-i+1:n-i+1)) then
                palindrome = .false.
                exit
            end if
        end do
    end function is_palindrome

end program palindromes
