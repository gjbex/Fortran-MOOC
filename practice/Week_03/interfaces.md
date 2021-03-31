# Interfaces

## Question 1

Which of the following statements is correct?
1. An interface for a function declares the latter's return type. [Indeed!] [x]
1. An interface can define a procedure's default implementation. [Interfaces do not define the implementation of a procedure.]
1. An interface for a procedure can specificity the intent of its arguments. [Indeed, although it doesn't have to.] [x]
1. If you want to pass a procedure as an argument to another procedure, you have to specify an interface. [No, strictly speaking you don't need an interface, although using one will save you some headache.]
1. An interface can describe both recursive and  non-recursive procedures. [Indeed!] [x]


## Question 2

Consider the following interface:

~~~~fortran
interface
    function fib_func_t(n) result(fib)
        use, intrinsic :: iso_fortran_env, only : I8 => INT64
        implicit none
        integer(kind=I8), value :: n
        integer(kind=I8) :: fib
    end function fib_func_t
end interface
~~~~

Which of the following statements is correct?
1. The name of the function must be `fib_func_t`. [No, that is the name of the interface, not of a function.]
1. The use statement is not required if it was already present in the compilation unit this interface is defined in. [Indeed, host binding would do the job as well.] [x]
1. A procedure argument that is a function implementing this interface can be declared using `type(fib_func_t) :: func`. [No, this declaration is not correct.]
1. This interface can be implemented by a function that would declare the argument `intent(in)` rather than `value`. [No, this has a different semantics, so the implementation would not match the interface.]
