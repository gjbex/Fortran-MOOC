# Bit-wise operations

Although bit-wise operations do not figure prominently in scientific computing
there are definitely applications.  Fortran has a number of intrinsic
procedures that allow to do this.  It is important to note that these
procedures can only be applied to integer data types.

The bit-wise operations you expect are available: `not`, `iand`, `ior`,
`ieor` (exclusive-or).  All these functions are elemental, so they can be
applied to arrays.

The number of bits of a value can be determined using the `bit_size` function.

The function `shiftl` lets you shift the bits in an integer by a given number
of bits to the left.  correspondingly, `shiftr` shifts the bits to the right.
The `cshift` function performs a circular shift.  Note that the shift should
not exceed the number of bits of the value.

Other useful functions allow to set (`ibset`) and clear (`ibclr`) bits at
specific positions.  Note that the positions are 0-based, so the least
significant bit is at position 0.

The `ibits` function can be used to select bits from a given position (0-based)
and with a given length.

For instance, below you find a (naive) function that computes the number of bits
set in an integer.

~~~~fortran
function naive_count_bits(n) result(bit_count)
    implicit none
    integer(kind=I4), value :: n
    integer :: bit_count
    integer :: i
    
    bit_count = 0
    do i = 1, 32
        bit_count = bit_count + and(n, 1_I4)
        n = shiftr(n, 1)
    end do
end function naive_count_bits
~~~~
