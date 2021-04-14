# Code style

## Question 1

Which of the following statements are correct?
1. Variable names should give a hint to the types of the variables, e.g., `istat` for an integer variable. [No, although this is common practice on older code, it is not considered best practice]
1. Fortran keywords such as `PROGRAM`, `INTEGER` and so on should be written in upper case. {No, although this was common practice in older code, it doesn't really add value]
1. It's good practice to use verbs as names for procedures. [Indeed, it helps to tell a story] [x]
1. Names for user defined types and modules have conventional suffixes, `_t` and `_mod` respectively. [Indeed, it is good practice to use those] [x]


@# Question 2

Which of the following statements are correct?

1. In a procedure compilation unit, you have only access to locally defined variables. [No, you have access to definitions in the host  context as well]
1. If a variable named `foobar` is not declared, it will have type `real` unless `implicit none` was declared in the compilation unit. [Indeed] [x]
1. Implicit typing saves you a lot of keystrokes when writing source code. [Indeed, it does, but you'll have significantly more headache] [x]
1. `implicit none` will ensure that variables declared in the host scope are not accessible in the scope of a compilation unit contained therein. [No, it serves a different purpose]


## Question 3

Which of the following statements are correct?

1. Modules can help you to ensure that data or procedures can only be accessed from within that module, not from compilation units that use them. [Indeed, private variables or procedures can be defined] [x]
1. If you don't want to modify an argument in a procedure, you can add the `parameter` keyword to its declaration. [No, although restricting the use of the argument, this is not done with parameter]
1. For complicated control flow, it is good practice to use label to distinguish between the ends of various statements. [Indeed, although it would be better to try to avoid complicated control flows] [x]
1. Using named blocks can help to make your code easier to understand. [Yes, although it might be better to simplify the code by introducing procedures] [x]
