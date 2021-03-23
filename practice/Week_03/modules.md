# Modules

## Question 1

Which of the following statements are correct?
1. Each module has to be stored in its own file. [No, although this may be useful, it is not required.]
1. Modules can be used in other modules. [Indeed] [x]
1. If you want to use a variable or procedure defined in a module, it has to be declared public. [No, variables and procedures are public by default]
1. It is possible to restrict access to variables and procedures defined in modules. [Indeed] [x]


## Question 2

Which of the following statements are correct?
1. A variable or procedure declared private can be used in the module itself. {indeed] [x]
1. A variable or procedure declared private can be used in another compilation unit if it is explicitly mentioned in the `only` clause of the use statement. [No, private is private]
1. If a procedure is declared `protected`, it can not be used in other compilation units, except in types that inherit from them. [No, protected means something different in Fortran than in, e.g., Java or C++]
