# Error handling

## Question 1

Which of the following statements is correct?

1. Warnings and error messages should be written to `error_unit`, not `output_unit`. {Indeed, this allows the user o the application to distinguish easily between normal output and error messages] [x]
1. The `exit` statement will terminate the execution of the application immediately. [No, the exit statement serves a different purpose]
1. For arrays accessed out of bounds no error handling is required if the index is supplied by the user of the application. [No, at best the application would crash with an error message that is uninformative to the user, so error handling would be required to provide good feedback]
1. The exit status of a Fortran application can not be controlled by the programmer, it is compiler dependent. [You can perfectly control the exit status of you application as a programmer]


## Question 2

Which of the following statements is correct?

1. You can use the `stop` statement with a string that will be printed when the statement is executed. [Indeed, but it is not good practice] [x]
1. Using distinct values for the exit status depending on the nature of the error can be used in shell scripts. [Indeed] [x]
1. The integer value for a `stop` statement can be any integer. [In theory, yes, but you should restrict yourself to values between 0 and 127 (inclusive)] [x]
1. You can non-locally deal with errors by throwing exceptions, and handling those in the calling context. [Unfortunately, no, Fortran doesn't have exception handling like that]
