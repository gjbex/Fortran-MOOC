program compute_pi
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    use :: mpi_f08
    implicit none
    real, parameter :: PI = acos(-1.0)
    integer(kind=I8), parameter :: nr_tries = 500000000
    integer(kind=I8) :: nr_success, total_nr_success
    integer(Kind=I8) :: i
    integer :: my_rank, my_size
    type(MPI_Datatype) :: int_t
    real :: x, y

    ! initialize MPI
    call MPI_Init()

    ! get rank in and size of communicator
    call MPI_Comm_rank(MPI_COMM_WORLD, my_rank)
    call MPI_Comm_size(MPI_COMM_WORLD, my_size)

    ! show number of processes, only rank 0
    if (my_rank == 0) &
        print '(A, I0, A)', 'running with ', my_size, ' processes'

    ! do local computation
    nr_success = 0
    do i = 1, nr_tries/my_size
        call random_number(x)
        call random_number(y)
        if (x**2 + y**2 <= 1.0) nr_success = nr_success + 1
    end do

    ! reduce the results, rank 0 will have the sum
    total_nr_success = 0
    call MPI_Type_match_size(MPI_TYPECLASS_INTEGER, I8, int_t)
    call MPI_Reduce(nr_success, total_nr_success, 1, int_t, MPI_SUM, 0, &
                    MPI_COMM_WORLD)

    ! show the result, only rank 0
    if (my_rank == 0) then
        print '(A, F10.7)', 'sampled pi = ', 4.0*real(total_nr_success)/nr_tries
        print '(A, F10.7)', 'real pi = ', PI
    end if

    ! finalize MPI
    call MPI_Finalize()
end program compute_pi
