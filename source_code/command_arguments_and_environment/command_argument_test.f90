program command_argument_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    character(len=50) :: program_name
    character(len=20) :: buffer
    integer :: nr_args, i

    ! get the name of the command
    call get_command_argument(0, program_name)
    print '(A, "''", A, "''")', 'command: ', program_name

    ! get the number of command line arguments
    nr_args = command_argument_count()
    print '(A, I0)', 'nr. arguments: ', nr_args

    ! get the command line arguments
    do i = 1, nr_args
        call get_command_argument(i, buffer)
        print '(4X, A, I0, ": ''", A, "''")', 'argument ', i, buffer
    end do
end program command_argument_test
