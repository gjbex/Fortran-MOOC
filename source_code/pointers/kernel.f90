program kernel
    implicit none
    integer, parameter :: nr_vals = 5, nr_steps = 4
    real, dimension(nr_vals), target :: A_vals, A_new_vals
    real, dimension(:), pointer :: A, A_new, tmp
    integer :: t, i

    ! initialize the vectors; since for i = 1 and i = size(A) there are no
    ! assignments in the do-loop, initialize those elements in A_new
    call random_number(A_vals)
    A_new_vals(1) = A_vals(1)
    A_new_vals(size(A_new_vals)) = A_vals(size(A_vals))

    ! associate the pointers
    A => A_vals
    A_new => A_new_vals

    ! perform iterations, print A and A_new each time
    do t = 1, nr_steps
        do i = 2, size(A_new) - 1
            A_new(i) = 0.25*(A(i - 1) + A(i + 1)) + 0.5*A(i)
        end do
        print '(A8, *(F10.5))', 'A: ', A
        print '(A8, *(F10.5))', 'A_new: ', A_new
        tmp => A_new
        A_new => A
        A => tmp
    end do 
end program kernel
