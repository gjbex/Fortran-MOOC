# Error handling in Fortran

Quite a number of bugs are introduced due to incorrect or even no handling of error conditions during the execution of an application.  This type of defect is especially annoying since the symptoms will occur some time after the actual cause, and manifest themselves in functions that seem to have little to do with that cause.  This "lack of locality" makes identifying the issue quite hard.

A defensive style of programming will help to prevent these situations.

Note that proper error handling can be quite complex and increase the size of your code base substantially.


## Dynamic memory allocation

In Fortran, a primary example of non-local issues is the management of dynamic memory, i.e., memory allocated on the heap using the `allocate` statement.

Consider the following code, the subroutine takes arrays as arguments that may have been allocated.

~~~~fortran
subroutine create_array(x, n)
    implicit nonse
    real, dimension(:), allocatable, intent(inout) :: x
    integer, intent(in) :: n
    allocate(x(n))
end subroutine create_array
...
subroutine daxpy(alpha, x, y)
    implicit none
    real, intent(in) :: alpha
    real, dimension(:), intent(inout) :: x
    real, dimension(:), intent(in) :: y
    x = alpha*x + y
end subroutine daxpy
~~~~

The `allocate` statement may fail when there is not enough memory space to accommodate the request.  However, since `create_vector` doesn't check, the application will continue under the assumption that its result is indeed an array with all `n` elements.

At some point, e.g., in a call to the procedure `daxpy`, the array `x`, or `y`, or both may in fact not have been allocated at all, and the application will crash with a segmentation fault. The problem, in this case merely a symptom, will occur in `daxpy`, while the cause is in fact in `create_vector`, or, to be more precise, wherever the size of the array was computed. If this is a complex application, it may take you a while to track down the root cause of this crash.

You want errors to occur as soon as possible since the closer that happens in space and time to the root cause, the easier it will be to identify and fix the issue.

In this particular case, the procedure `create_vector` should check whether `allocate` succeeded, and if not, generate an error.

~~~~fortran
subroutine create_array(x, n)
    use, intrinsic :: iso_fortran_env, only: error_unit
    implicit nonse
    real, dimension(:), allocatable, intent(inoout) :: x
    integer, intent(in) :: n
    integer :: istat
    allocate(x(n), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A, I12)') &
            '### error: can not allocate array of size ', n
        stop 1
    end if
end subroutine create_array
~~~~

Note that it is more informative to

  1. write a message to standard error, and
  1. use a non-zero numerical argument to `stop`.
  
When `stop` is used with an error message, the application's exit code would be 0, and it would be harder to detect an error in your workflow.

It would certainly be a good idea to define constants in a module that account for various error conditions so that they can be used consistently across the application.

~~~~fortran
module error_status
    implicit none
    integer, parameter :: ALLOCATION_ERR = 1, &
                          FILE_OPEN_ERR = 2, &
                          CMD_LINE_NR_ARGS_ERR = 3, &
                          CMD_LINE_ARG_VALUE_ERR = 4, &
                          FILE_VALUE_ERR = 5
end module error_status
~~~~

You can use this in the `create_vector` procedure, i.e.,

~~~~fortran
subroutine create_array(x, n)
    use, intrinsic :: iso_fortran_env, only: error_unit
    use :: error_status, only : ALLOCATION_ERR
    implicit nonse
    real, dimension(:), allocatable, intent(inoout) :: x
    integer, intent(in) :: n
    integer :: istat
    allocate(x(n), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A, I12)') &
            '### error: can not allocate array of size ', n
        stop ALLOCATION_ERR
    end if
end subroutine create_array
~~~~

When this application is run and it fails, this will produce the following output

~~~~
### error: can not allocate array of size 10000000000
STOP 1
~~~~

Although this error message describes the issue, it could be more informative by using the values of a few macros:

 * `__FILE__` contains the name of the source file it occurs in,
 * `__LINE__` contains the line number of the source file it occurs on.

Using these compiler macros, the `create_array` procedure can be implemented as follows:

~~~~fortran
subroutine create_array(x, n)
    use, intrinsic :: iso_fortran_env, only: error_unit
    use :: error_status, only : ALLOCATION_ERR
    implicit nonse
    real, dimension(:), allocatable, intent(inoout) :: x
    integer, intent(in) :: n
    integer :: istat
    allocate(x(n), stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A, I3, A, I10)') &
            '### error in ' // trim(__FILE__) // ',', __LINE__, &
            ': can not allocate array of size ', n
        stop ALLOCATION_ERR
    end if
end subroutine create_array
~~~~

Now the output would be:

~~~~
### error in allocation_error.f90, 18: can not allocate array of size 2000000000
STOP 1
~~~~

The `__LINE__` macro is set to the line number it occurs on in the source file, so it will not actually be the line number on which the error occurs, but at least it points you in the  right direction.

Note that in order to compile Fortran code that relies on the preprocessor you should either specify the `-cpp` option for the compiler, or name the source files with a file name extension in capital letters, e.g., `.F90`.


## String conversion

In Fortran, converting a string to a number is done using a `read` statement with the appropriate format string.

When you try to convert a string value such as `"abc"` to an integer, the application will crash with a meaningful error message and a backtrace.

If you want to handle the error yourself, you can easily do this by providing the optional arguments `iostat` and `iomsg` to the `read` statement.

~~~~fortran
use :: error_status, only : CMD_LINE_NR_ARGS_ERR, &
                            CMD_LINE_ARG_VALUE_ERR
implicit none
real :: x
integer :: ierr
character(len=80) :: buffer, msg
if (command_argument_count() /= 1) then
    write (unit=error_unit, fmt='(A)') &
        '### error: expecting a real as argument'
    stop CMD_LINE_NR_ARGS_ERR
end if
call get_command_argument(1, buffer)
read (buffer, fmt='(F25.16)', iostat=ierr, iomsg=msg) x
if (ierr /= 0) then
    write (unit=error_unit, fmt='(4A)') &
        '### error: can not convert to real: ', trim(buffer), &
        ', ', trim(msg)
    stop CMD_LINE_ARG_VALUE_ERR
end if
~~~~

If the `read` statement fails, the `ierr` variable will be set to a non-zero value, so you can easily test for problems.  The `msg` variable will be set to a relevant error message that can be used to provide feedback to the user.


## File I/O

When reading or writing files quite a number of things can go wrong.

Just like the statements for memory allocation, the I/O related statements `open`, `read`, `write`, ..., have optional arguments `iostat` and `iomsg` that will provide feedback on the success or failure of the operation.  Fail to use them at your own peril.

The code fragment below will open a file, read it line by line, and do some unspecified processing.

~~~~fortran
open (unit=read_unit, file=file_name, access='sequential', &
      action='read', status='old', form='formatted')
do
    read (unit=read_unit, fmt="(A10, E25.16)", &
          iostat=ierr, iomsg=msg) name, value
    if (ierr < 0) exit
end do
close (unit=read_unit)
~~~~

You might hope that when you run the application and `file_name` doesn't contain the name of an existing file, or the file can not be opened, your application may terminate with an error message. However, that will not happen. The `read` statement will set `ierr` to a negative value, indicating the end of the input file, and everyone will live happily ever after, except that it is quite likely your application will produce unexpected results. The user of your application gets no indication that the file she wanted to be read was completely ignored.

~~~~fortran
use :: error_status
...
open (unit=read_unit, file=file_name, access='sequential', &
      action='read', status='old', form='formatted', &
      iostat=ierr, iomsg=msg)
if (ierr /= 0) then
    write (unit=error_unit, fmt='(3A)') &
        '### error: can not open file ', trim(file_name), &
        ', error: ' // trim(msg)
    stop FILE_OPEN_ERR
end if
...
~~~~

The application verifies that the file has been opened successfully, and if not, it writes an appropriate error message to standard error using the message that was set by the `open` statement in its `iomsg` argument. For instance, when called with a file that doesn't exist, you will get the following error message:

~~~~bash
$ ./file_error.exe bla
### error: cannot open file bla, error: Cannot open file 'bla': No such file or directory
STOP 2
~~~~

On the other hand, if it is called with a file that exists, but that you don't have permission to read or write, you would get the following:

~~~~bash
$ ./file_error.exe test.txt
### error: cannot open file test.txt, error: Cannot open file 'test.txt': Permission denied
STOP 2
~~~~

In this case, using the value set in the `iomsg` as part of your own improves the quality of the error message, and helps the user of your application to figure out what the problem might be.

It is also quite useful to check the `iostat` value set by the `read` statement.  This will allow you to improve the quality of the feedback, similar to what was mentioned in the section on string conversion.  When `iostat` has a non-zero value, you can give the user specific information on the expected values.

For instance, when reading a file such as the one below, some appropriate error messages may help the user a lot.

~~~~
alpha     1.1
beta      3.3
~~~~

~~~~fortran
line_nr = 0
do
    read (unit=read_unit, fmt="(A10, E25.16)", &
          iostat=ierr, iomsg=msg) name, value
    line_nr = line_nr + 1
    if (ierr < 0) then
        exit
    else if (ierr > 0) then
        write (unit=error_unit, fmt='(A, I3, A)') &
            '### error during read at line ', line_nr, ': ' // trim(msg)
        stop
    else
        ! do something useful with the name and value
    end if
~~~~

When the input is invalid, such as below, you get an error:

~~~~
alpha     1.1
beta      3.O5
~~~~

~~~~bash
$ ./file_error.exe input_nok.txt
### error during read at line   2: Bad value during floating point read
STOP 5
~~~~

Note that keeping track of the line number in the input file and reporting it in case of an error will again help the user of this application to identify the problem.


## Overly defensive programming

Grace Hopper is credited with the quote
> It's easier to ask forgiveness than it is to get permission.

Before even attempting to open a file with a given name, you could check whether

 * something with that name exists,
 * it is actually a file,
 * you have permission to open it.

Doing those checks is like asking permission in an administrative matter.  It is a lengthy process, it is tedious and boring.  The alternative is to simply attempt to open the file, and if that fails, simply tell the user why.

Thanks to the values assigned to the `iomsg` argument, chances are that your application will write error messages that are as informative as the ones you'd handcraft by checking for all conceivable error conditions manually.  Your code will be more concise, simpler, and hence the probability of having bugs in your error handling code is reduced.


## Error context

At which level do you report an error?  This is a non-trivial question.

Suppose you are developing an application that reads some parameters from a configuration file, it creates data structures, initialises them, and starts to compute.  One of the configuration parameters is the size of the vectors your computation uses, and those are dynamically allocated.

Now you already know that your should check the result of `allocate` to ensure that the allocation succeeded.  Failing to do so will most likely result in a segmentation fault.

However, the user of your application (potentially you) enters a vector size in the configuration file that is too large to be allocated.  No problem though, your application handles error conditions and reports to the user.

You could report the error and terminate execution in the procedure where it actually occurs, the `create_vector` subroutine you defined in one of the previous sections.  This would inform the user that some array can not be allocated.  However, unless she is familiar with the nuts and bolts of the application, that may in fact be completely uninformative.  The subroutine `create_vector` has no clue about the context in which it is called, and can hardly be expected to produce a more meaningful error message.

It would be more useful to the user if this error were reported to the calling procedure, which has more contextual information, and that this procedure would report an error that has better semantics. At the end of the day, the relevant information is that you should reduce the value of a parameter in your configuration file.

Handling errors in the appropriate context is not that easy.  It requires careful planning and formulating error messages from the perspective of the user at each layer in your application.  In a language such as Fortran, this means that procedures should return status information, typically as an `inout` argument.  In the Fortran API for the MPI library for instance, almost all functions take an error argument of type `integer` that can be used to check whether the procedure call was executed successfully.  Note that forgetting this argument in the procedure calls may lead to very interesting bugs.  In the Fortran 2008 API for this library, that argument is optional, so omitting it is no longer a deadly sin when you use this API.

Note that proper error handling will be fairly complex and potentially increase the size of your code base.


## Floating point expectations

There are a number of problems that may arise during numerical computations and that go unnoticed, or are only noticed late, i.e., when a lot of expensive computations have been performed.

The IEEE standard 754 defines five exceptions that can occur as a result of floating point operations:

 1. inexact: accuracy is lost;
 1. divide by zero;
 1. underflow: a value can not be represented and is round to zero;
 1. overflow: a value is too large to be represented; and
 1. invalid: operations is invalid for the given operands.

A divide by zero and an overflow will result in positive or negative infinity, depending on the sign of the operand, while an invalid operation will result in positive or negative NaN (Not a Number).  These values will propagate throughout your computations, making them useless.

Note that an underflow will easily go unnoticed, which makes it even more dangerous.

Modern Fortran compilers implement the `ieee_arithmetic` intrinsic module that defines various functions to check whether a numerical value is normal, e.g.,

 * `ieee_is_finite`,
 * `ieee_is_normal`,
 * `ieee_is_nan`.

The code below shows a trivial example.

~~~~fortran
program overflow_sum
   use, intrinsic :: ieee_arithmetic, only : ieee_is_normal
   use, intrinsic :: iso_fortran_env, only : error_unit
   implicit none
   integer :: n
   character(len=80) :: buffer
   real :: result

   n = 10
   if (command_argument_count() > 0) then
       call get_command_argument(1, buffer)
       read (buffer, '(I10)') n
   end if
   result = compute_sum(n)
   if (.not. ieee_is_normal(result)) then
       write (unit=error_unit, fmt='(A)') 'non-normal number detected'
   end if
   print '(A, E12.5)', 'result = ', result

   contains

       real function compute_sum(n)
           implicit none
           integer, intent(in) :: n
           integer :: i
           compute_sum = 0.0
           do i = 1, n
               compute_sum = compute_sum + 10.0**i
           end do
       end function compute_sum

end program overflow_sum
~~~~
