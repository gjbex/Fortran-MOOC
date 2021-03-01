# select and where statements

## Question 1

Consider the following code fragment:

~~~~fortran
select case (x)
    case (x > 0.0)
        print *, 'positive'
    case (x < 0.0)
        print *, 'negative'
    case default
        print *, 'zero'
end select
~~~~
If this fragment is executed for `x` equal to 0.5, it
1. will not compile. [Indeed, cases should be character or integer values.] [x]
1. will print `positive`. [No, try it out.]
1. will print `zero`. [No, try it out.]
1. will print `negative`. [No, try it out.]


## Question 2

Consider the following code fragment:

~~~~fortran
select case (op)
    case ('+')
        print *, 'positive'
    case ('-')
        print *, 'negative'
    case default
        print *, 'default'
end select
~~~~
If this fragment is executed for `op` equal to `'+'`, it
1. will not compile. [No, it will compile.]
1. will print `positive`. [Indeed.] [x]
1. will print both `positive`  and `default`. [No, this is not C/C++.]
1. will print `default`. [No, try it out.]


## Question 3

Can the following statement be replace by a select statement for `i` declared as an integer?

~~~~fortran
if (i < 0 .or. i > 0) then
    print *, 'yes'
else
    print *, 'no'
end if
~~~~
1. yes [Indeed.] [x]
1. no [No, it can, check the semantics of the logical value.]


## Question 4

Consider the following program:

~~~~fortran
program where_test
    implicit none
    integer :: i
    integer, dimension(9) :: data = [ (i, i=1, size(data)) ]
    integer, dimension(size(data)) :: value = 0

    where (mod(data, 2) == 0)
        value = 2
    elsewhere (mod(data, 3) == 0)
        value = 3
    elsewhere
        value = 1
    end where
    print *, value
end program where_test
~~~~
Which of the following values will be printed?
1. 0 2 3 2 0 3 0 2 3 [No, try it out.]
1. 0 2 3 2 0 2 0 2 3 [No, try it out.]
1. 1 2 3 2 1 3 1 2 3 [No, try it out.]
1. 1 2 3 2 1 2 1 2 3 [Indeed.] [x]
