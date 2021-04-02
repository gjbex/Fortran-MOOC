# Type-bound procedures

## Question 1

Which of the following statements are correct?
1. To call a type-bound procedure, the '%' notation is used. [Indeed] [x]
1. The first argument of a type-bound procedure is always the variable on which the procedure is call. [No, the procedure can be declared `nopass`]
1. If a type-bound procedure requires access to elements in the variable, the procedure has to have a `pass` attribute. [Indeed] [x]
1. Type-bound procedures can only be functions, not subroutines. [No, subroutines can be type-bound procedures]


## Question 2

Consider the following user defined type:
~~~~fortran
type, public :: stats_t
    real :: sum
    integer :: n
contains
    procedure, public, pass :: add_value, get_mean
end type stats_t
~~~~

Which of the following statements is correct?
1. You can have many variables of type `stats_t` but they will all share the same values for `sum` and `n`. [No, if they are distinct variables they will have their own values for `sum` and `n` as well]
1. The only way to change `sum` or `n` is trough the type-bound procedures. [No, note that the elements are not private]
1. If `stats` is a variable of type `stats_t`, then you can call the type-bound procedure `get_mean` using `stats%get_mean()`. [Indeed] [x]
1. Since `get_mean` is declared with the `pass` attribute, it can also be called as `get_mean(stats)` if `stats` is a variable of type `stats_t`. [No, the linker will give an error]
1. The `pass` attribute could have been left out since it is the default. [Indeed] [x]
