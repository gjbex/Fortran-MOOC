program str_assignment
    implicit none
    character :: c
    character(len=5) :: str

    c = 'h'
    str = 'hello world'
    print '(A, I0)', 'len(c) = ', len(c)
    print '(A, I0)', 'len(str) = ', len(str)
    str = 'abc'
    print '(A, I0)', 'len(str) = ', len(str)
    print '(A, I0)', 'len_trim(str) = ', len_trim(str)
end program str_assignment
