# Passing arrays as arguments to procedures

## Question 1

consider the following subroutine:

~~~~fortran
subroutine print_array(data)
    implicit none
    real, dimension(3) :: data

    print *, data
end subroutine print_array
~~~~
When you call this subroutine with an array declared as `real, dimension(4) :: x`,
1. you get a compilation error since the sizes don't match. [No, try it out.]
1. the subroutine will print the first three elements of `x` [Indeed, the first three elements of `x` are passed to the subroutine.] [x]
1. the subroutine will print all four elements of `x` [No, check what happens.]
1. you get a segmentation fault when you run it. [No, check what happens.]


## Question 2

consider the following subroutine:

~~~~fortran
subroutine print_array(data)
    implicit none
    real, dimension(4) :: data

    print *, data
end subroutine print_array
~~~~
When you call this subroutine with an array declared as `real, dimension(3) :: x`,
1. you get a compilation error since the sizes don't match. [Indeed, `print_array` expects an array of size 4.] [x]
1. the subroutine will print the first three elements of `x` [No, check what happens.]
1. the subroutine will print all four elements of `x` [No, check what happens.]
1. you get a segmentation fault when you run it. [No, check what happens.]


## Question 3

consider the following subroutine

~~~~fortran
subroutine fill_array(A)
    implicit none
    integer, dimension(:, :) :: A
    integer :: i, j

    do j = 1, size(A, 1)
        do i = 1, size(A, 2)
            A(i, j) = (i - 1)*size(A, 2) + j
        end do
    end do
end subroutine fill_array
~~~~
When you call it with an array declared and initialized as `integer, dimension(2, 3) :: data = 0`, element `data(2, 3)` will have the value:
1. 0 [Indeed, why?]
1. 2 [No, check what happens.]
1. 3 [No, check what happens.]
1. 6 [No, check what happens.]
