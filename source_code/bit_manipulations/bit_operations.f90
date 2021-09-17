program bit_operations
    use, intrinsic :: iso_fortran_env, only : I4 => INT32
    use :: bitmanip_mod, only : bit_repr
    implicit none
    integer(kind=I4) :: a, pos, length, shift

    a = 0
    print '(A, I0)', 'bit size: ', bit_size(a)
    do pos = 0, 10, 2
        a = ibset(a, pos)
        print '(A, I2, 2A)', 'set ', pos, ': ', bit_repr(a)
    end do
    do pos = 10, 0, -2
        a = ibclr(a, pos)
        print '(A, I2, 2A)', 'set ', pos, ': ', bit_repr(a)
    end do
    a = 170
    print '(2A)', 'original: ', bit_repr(a)
    do pos = 0, 4
        do length = 2, 4
            print '(2(A, I0), 2A)', 'pos: : ', pos, ', len: ',  length, &
                ': ', bit_repr(ibits(a, pos, length))
        end do
    end do
    a = 15
    print '(2A)', 'original: ', bit_repr(a)
    do shift = 1, 5
        print '(2A)', 'shift: ', bit_repr(shiftr(a, shift))
    end do
    a = 15
    print '(2A)', 'original: ', bit_repr(a)
    do shift = 1, 5
        print '(2A)', 'shift: ', bit_repr(shiftl(a, shift))
    end do
end program bit_operations
