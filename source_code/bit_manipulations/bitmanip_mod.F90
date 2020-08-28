module bitmanip_mod
    use, intrinsic :: iso_fortran_env, only : INT32
    implicit none


    private

    integer, public, parameter :: I4 = INT32
    integer, dimension(0:255) :: lookup_table = [ &
#include "lookup_table.dat"
        ]
    public :: naive_count_bits, early_stopping_count_bits, bit_repr, &
        lookup_table_count_bits

contains

    function naive_count_bits(n) result(bit_count)
        implicit none
        integer(kind=I4), value :: n
        integer :: bit_count
        integer :: i
        
        bit_count = 0
        do i = 1, 32
            bit_count = bit_count + and(n, 1_I4)
            n = ishft(n, -1)
        end do
    end function naive_count_bits

    function early_stopping_count_bits(n) result(bit_count)
        implicit none
        integer(kind=I4), value :: n
        integer :: bit_count
        integer :: i
        
        bit_count = 0
        do i = 1, 32
            bit_count = bit_count + and(n, 1_I4)
            n = ishft(n, -1)
            if (n == 0) exit
        end do
    end function early_stopping_count_bits

    function lookup_table_count_bits(n) result(bit_count)
        implicit none
        integer(kind=I4), value :: n
        integer :: bit_count

        bit_count = lookup_table(and(n, 255_I4)) + &
            lookup_table(and(ishft(n, -8), 255_I4)) + &
            lookup_table(and(ishft(n, -16), 255_I4)) + &
            lookup_table(and(ishft(n, -24), 255_I4))
    end function lookup_table_count_bits

    function bit_repr(val) result(repr)
        implicit none
        integer(kind=I4), value :: val
        character(len=32) :: repr
        integer :: i

        do i = 32, 1, -1
            if (and(1_I4, val) == 1_I4) then
                repr(i:i) = '1'
            else
                repr(i:i) = '0'
            end if
            val = ishft(val, -1)
        end do

    end function bit_repr

end module bitmanip_mod
