# Pointers

## question 1

Which of the following statements is correct?
1. When you use a pointer, you always have to deallocate it.  [No, in many cases that would destroy your data structure]
1. No two pointers can be associated to the same data. [No, pointers can point to any data, regardless of other pointers]
1. You can have pointers to procedures. [Indeed, pointers can be associated to procedures] [x]
1. You can use the `associated` function to verify whether a pointer is associated with a specific object. [Indeed, `associated` has an optional argument that lets you do that.] [x]


## Question 2

Which of the following statements is correct?
1. Before using the `nulligy` statement, you should always do a `deallcoate` first. [No, you may end up destroying your data in many cases.]
1. Using the `nullify` statement you can break the association a pointer has. [Indeed, that is the purpose of `nullity`] [x]
1. In the association `a => p` the variable `a` should be a pointer. {indeed, that is the semantics of the association operator] [x]
1. You can associate a pointer variable to a variable of any type. [No, the types of the pointer and what it points to should match]


## Question 3

When you run the following application, what will be the output generated?

~~~~fortran
program pointer_to_allocatable
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_values = 5
    integer, dimension(:), pointer :: values, p
    integer :: status

    allocate (values(nr_values), stat=status)
    print '(L)', associated(values)

    p => values
    print '(L)', associated(p)

    deallocate (values)
    print '(L)', associated(values)
    print '(L)', associated(p)

end program pointer_to_allocatable
~~~~

1. `T T T T` [No, reconsider or try it out]
1. `T T F T` [Indeed, `p` is still associated] [x]
1. `T T F F` [No, you wish, reconsider or try it out]


## Question 4

When you run the following application, what will be the output generated?

~~~~fortran
program pointer_to_allocatable
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer, parameter :: nr_values = 5
    integer, dimension(:), allocatable, target :: values
    integer, dimension(:), pointer :: p
    integer :: status

    allocate (values(nr_values), stat=status)

    p => values
    print '(L)', allocated(values)
    print '(L)', associated(p)

    deallocate (p)
    print '(L)', allocated(values)
    print '(L)', associated(p)

end program pointer_to_allocatable
~~~~

1. `T T F F` [No, but you'd hope so]
1. `T T F T` [No, reconsider or try it out]
1. `T T T F` [Indeed, although this may be unexpected] [x]
