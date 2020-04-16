program limits_test
    use, intrinsic :: iso_fortran_env, only : INT8, INT16, INT32, INT64, &
                                              REAL32, REAL64, REAL128 
    implicit none
    integer(kind=INT8) :: i8
    integer(kind=INT16) :: i16
    integer(kind=INT32) :: i32
    integer(kind=INT64) :: i64
    real(kind=REAL32) :: x32
    real(kind=REAL64) :: x64
    real(kind=REAL128) :: x128
    
    print '(A)', 'integer:'

    print '(2X, A)', 'huge'
    print *, kind(i8), huge(i8)
    print *, kind(i16), huge(i16)
    print *, kind(i32), huge(i32)
    print *, kind(i64), huge(i64)

    print '(2X, A)', '(binary) digits'
    print *, kind(i8), digits(i8)
    print *, kind(i16), digits(i16)
    print *, kind(i32), digits(i32)
    print *, kind(i64), digits(i64)

    print '(2X, A)', 'range'
    print *, kind(i8), range(i8)
    print *, kind(i16), range(i16)
    print *, kind(i32), range(i32)
    print *, kind(i64), range(i64)

    print '(A)', 'real:'

    print '(2X, A)', 'huge:'
    print *, kind(x32), huge(x32)
    print *, kind(x64), huge(x64)
    print *, kind(x128), huge(x128)

    print '(2X, A)', 'tiny:'
    print *, kind(x32), tiny(x32)
    print *, kind(x64), tiny(x64)
    print *, kind(x128), tiny(x128)

    print '(2X, A)', 'epsilon:'
    print *, kind(x32), epsilon(x32)
    print *, kind(x64), epsilon(x64)
    print *, kind(x128), epsilon(x128)

    print '(2X, A)', 'range:'
    print *, kind(x32), range(x32)
    print *, kind(x64), range(x64)
    print *, kind(x128), range(x128)

    print '(2X, A)', 'minexponent:'
    print *, kind(x32), minexponent(x32)
    print *, kind(x64), minexponent(x64)
    print *, kind(x128), minexponent(x128)

    print '(2X, A)', 'maxexponent:'
    print *, kind(x32), maxexponent(x32)
    print *, kind(x64), maxexponent(x64)
    print *, kind(x128), maxexponent(x128)

    print '(2X, A)', 'precision:'
    print *, kind(x32), precision(x32)
    print *, kind(x64), precision(x64)
    print *, kind(x128), precision(x128)

    print '(2X, A)', '(binary) digits:'
    print *, kind(x32), digits(x32)
    print *, kind(x64), digits(x64)
    print *, kind(x128), digits(x128)

end program limits_test
