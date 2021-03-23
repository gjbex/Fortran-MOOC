# Allocate

## Question 1

Which of the following statements is correct?

1. You can only pass an allocatable array to a procedure when its argument is declared allocatable as well. [No, just as deferred-shape arrays]
1. You can not use an allocatable variable before it is allocated. [Strictly speaking, no, you can, e.g., to test whether it is allocated]
1. You should test whether the allocation succeeded before assigning to an allocatable variable. [Indeed] [x]
1. When you try to allocate an array that is too large to fit in the available memory, the Fortran runtime will display an error message and terminate the application. [Indeed, but is that what you want to happen?] [x]
1. You can allocate multiple variables in a single allocate statement. [Indeed, that is possible] [x]


## Question 2

Assume that the following variables has been declared:

~~~~fortran
integer, dimension(:), allocatable :: values
integer :: status
~~~~

Which of the following statements is correct?

1. The statement `allocate (values(-5:5), stat=status)` would produce a runtime error. [No, this works just fine]
1. The statement `allocate (values(2, 3), stat=status)` would produce a runtime error. [No, it will not compile in the first place, so you can not run it]
1. When memory is successfully allocated by the statement `allocate (values(1500), stat=status)`, the variable `status` will have the value 0. [Indeed, 0 indicates success] [x]
1. If `status` is non-zero after executing the statement `allocate (values(1500), stat=status)` the value returned by a call `allocated(values)` is undetermined. [No, it will definitely return `.False.`]


## Question 3

Consider the following code fragment:

~~~~fortran
integer, dimension(3, 2) :: A
integer, dimension(:, :), allocatable :: B
integer :: i, status

A = reshape([ (i, i=1, size(A)) ], shape(A))
allocate(B, source=A, stat=status)
~~~~

What will be the value of `B(1, 2)`?
1. undetermined [No, B has well-defined values]
1. 2 [Indeed] [x]
1. 3 [No, not quite]
1. 4 [No, try it out]
