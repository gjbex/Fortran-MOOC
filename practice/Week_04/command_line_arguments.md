# Command line arguments and environment variables

## Question `1

What happens if you execute the following code:

~~~~fortran
...
character(len=20) :: buffer
call get_command_argument(0, buffer)
...
~~~~

1. The program will crash with a runtime error since the first command argument has number 1. [No, it won't crash]
1. `buffer` will contain an undetermined value. [No, it will have a specific value]
1. `buffer` will contain the name of the application. [Yes, indeed, if supported by the system] [x]
1. buffer will contain 20 spaces. [No, it will not]


## Question 2

Which of the following statements is correct?

1. The `call get_command(buffer)` statements gives the same result as `call get_command_argument(0, buffer)`. [No, it doesn't]
1. After the following statement `call get_command_argument(1, buffer, status=status)` the value of `status` will be -1 if the buffer could not accommodate the entire command line argument. [Indeed] [x]
1. When a command line argument is longer than the character argument's length, your application will crash with a runtime error. [No, it will not crash, but you may not get what you want]


## Question 3

Which of the following statements is correct?

1. You should use the `getenv` subroutine to retrieve the value of an environment variable. [No, although you could, you shouldn't since this is not standard Fortran]
1. The `status` optional argument to `get_environment_variable` will be 1 when that variable is not defined. [Indeed] [x]
1. The optional `trim_name` argument to `get_environment_variable` is useful if the name string passed has non-significant trailing spaces. [Indeed] [x]
1. If the value argument to `get_environment_variable` is too short to store the value of the environment variable, the value will be truncated. [Indeed] [x]
