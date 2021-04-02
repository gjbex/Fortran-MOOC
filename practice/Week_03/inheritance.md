# Inheritance

## Question 1

Consider the following code fragment.

~~~~fortran
type :: base_t
    private
    integer :: n
contains
    procedure :: get_n, set_n
end type base_t
type, extends(base_t) :: derived_t
    private
    integer :: p
contains
    procedure :: get_p, set_p
end type derived_t
...
type(base_t) :: base
type(derived_t) :: derived
~~~~

Which of the following statements is correct?
1. The variable `base` has a single element named `n`. [Indeed] [x]
1. The variable `derived` has a single element named `p`. [No, it is a derived type]
1. The method `get_n` can be called on `derived`. [Indeed] [x]
1. The method `get_p` can be called on `base`. [No, that method is not defined for `base`]


## Question 2

Consider the following code fragment.

~~~~fortran
type :: base_t
    private
    integer :: n
contains
    procedure :: get_n, set_n
end type base_t
type, extends(base_t) :: derived_t
    private
    integer :: p
contains
    procedure :: get_p, set_p
end type derived_t
...
type(base_t), target :: base
type(derived_t), target :: derived
class(base_t), pointer :: base_p
class(derived_t), pointerjjjjjjjjjjjjjjjjjjkjjjjjjkkkjjkkk :: derived_p
~~~~

Which of the following statements is correct?
1. You can assign `derived` to `base`. {No, you can't]
1. You can assign `base` to `dervied`. {No, you can't]
1. `base_p` can point to `derived`. [Indeed] [x]
1. `derived_p` can point to `base`. [No, it can't]
1. `base_p` can point to `derived_p`. [Indeed] [x]
1. `derived_p` can point to  `base_p`. [No, it can't]
