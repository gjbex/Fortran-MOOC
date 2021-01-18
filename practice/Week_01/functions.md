# Functions

## Question 1

What will be returned by the function defined below when it is called with 5 as an argument?
~~~~fortran
integer function f(n)
    integer :: n, i, fac
    
    fac = 1
    do i = 2, n
        fac = fac*i
    end
    return fac
end function f
~~~~
1. The function will return 120. [No, try it out.]
1. There is a compile error. [Indeed, the return statement is not legal here.] [x]
1. The function will return 24. [No, try it out.]


## Question 2

What will be returned by the function defined below when it is called with 4.9 as an argument?
~~~~fortran
integer function fac(n)
    integer :: n, i
    
    fac = 1
    do i = 2, n
        fac = fac*i
    end
end function fac
~~~~
1. The function will return 120. [No, try it out.]
1. The function will return 24. [No, try it out.]
1. There is a compile error. [Indeed, the function expects an integer as an argument.] [x]
1. You get a runtime error. [No, try it out.]


## Question 3

When you call the function below with an argument declared as `integer :: p = 5`, what will the value of `p` be after that function call?
~~~~fortran
integer function fac(n)
    integer :: n, i
    
    fac = 1
    do while (n > 1)
        fac = fac*n
        n = n - 1
    end
end function fac
~~~~
1. 5 [No, try it out.]
1. There is a compile error since you can't change the value of a function argument. [No, try it out.]
1. 1 [Indeed, variables are passed by reference in Fortran.] [x]
1. 120 [No, try it out.]
