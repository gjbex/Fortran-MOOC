# User defined types

## Question 1

Consider the following type and variable declaration:
~~~~fortran
type :: employee_t
    character(len=50) :: first_name, last_name
    integer :: age
    real :: wages
end type employee_t
type(employee_t) :: employee
~~~~
Which of the following statements is syntactically correct?
1. `type(employee_t), dimension(5) :: employees` [Indeed, that is correct.] [x]
1. `employee.first_name = 'Jack'` [No, elements are not accessed using a `.`.]
1. `employee(age) = 35` [No, this syntax is not correct.]
1. `employee % wages = 2553.5` [Indeed, this is correct.]


## Question 2

Consider the following type and variable declaration:
~~~~fortran
type :: person_t
    character(len=50) :: first_name, last_name
    integer :: age
end type person_t
type(person_t) :: person
~~~~
Which of the following statements is syntactically correct?
1. `person = ('Bob', 'Dylan', 57)` [No, that will not compile.]
1. `person = (last_name='Dylan',first_name='Bob', age=57)` [No, that will not compile.]
1. `person = ['Bob', 'Dylan', 57]` [No, that will not compile.]
1. `person = person_t('Bob', 'Dylan', 57)` [Indeed.] [x]
1. `person = person_t(last_name='Dylan',first_name='Bob', age=57)` [Indeed.] [x]


## Question 3

Note that the `sizeof` intrinsic function is a GNU extension, so you should use it in production code.

Consider the following program:
~~~~fortran
program udf
    implicit none
    type :: my_type_t
        character(len=2) :: code
        integer :: number
    end type my_type_t
    type(my_type_t) :: my_stuff = my_type_t(code='AB', number=10)

    print '(A, I0)', 'user defined type: ', sizeof(my_stuff)
end program udf
~~~~
What will be printed?
1. 4 [No, look at the type definition again.]
1. 6 [No, although that would seem to be the right value.]
1. 7 [No, try it out.]
1. 8 [Indeed, isn't that surprising?] [x]
