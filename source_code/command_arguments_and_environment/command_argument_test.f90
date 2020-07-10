program command_argument_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    character(len=20) :: buffer
    integer :: nr_args, i

    nr_args = command_argument_count()
    print '(A, I0)', 'nr. arguments: ', nr_args

    do i = 1, nr_args
        call get_command_argument(i, buffer)
        print '(4X, A, I0, ": ''", A, "''")', 'argument ', i, buffer
    end do
end program command_argument_test
