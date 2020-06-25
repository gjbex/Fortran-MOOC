# Dynamic memory allocation

## Motivation

Working with arrays is pretty straightforward in general.  However, there is a bit of
an issue when you do not know the size of an array at compile time.  For instance, you
want to compute the median of a list of numbers in a file, and you only know at
runtime how many data points there are.

The median of a sequence of numbers is obtained by sorting the sorting the numbers
first. If there is an odd number of values, the median is the middle value.  If the 
them number of values is even, the median is the average of the two middle values.

You could just create an array that is "large enough" to store all the numbers, but
what does "large enough" mean, a thousand, a million, a billion?  If the size of the
array is too small, you can not handle all data, and the result will be incorrect, if
the size is too large, you waste a lot of memory, a fairly precious commodity for
scientific computing.

This is just one example where dynamic memory allocation will help out.  You can
create arrays at runtime of the appropriate size, i.e., without wasting extra memory.
In order to do that, the application requests memory from the operating system.
As soon as the application doesn't require the array anymore, the memory is released
to the operating system and can be used for other purposes.


## Allocation statements and procedures

The Fortran statement to allocate dynamic memory is, not surprising `allocate`, and
the one to release the memory is `deallocate`.  Variables that will be allocated
should be declared explicitly as such, i.e, using the attribute `allocatable`.

It is possible that the operating system  doesn't have sufficient free memory to meet
the application's request, in which case `allocate` will silently not allocate the
memory.  Hence you should test whether the dynamic memory allocation succeeded using
the `allocated` intrinsic function.  This function will return the logical value
`.true.` if the variable is allocated, `.false.` otherwise.

The following function illustrates the use of `allocate`, `allocated` and
`deallocate`.  The function takes `unit_nr`, a unit number that should be opened for
reading and `nr_values`, the number of values to read.

~~~~fortran
function compute_median(unit_nr, nr_values) result(median_value)
    use, intrinsic :: iso_fortran_env, only : error_unit
    use :: quicksort_mod, only : qsort
    implicit none
    integer, value :: unit_nr, nr_values
    real :: median_value
    real, dimension(:), allocatable :: values
    integer :: i, istat
    character(len=1024) :: msg

    allocate (values(nr_values))
    if (.not. allocated(values)) then
        write (unit=error_unit, fmt='(A, I0)') &
            'error: can not allocate array of size ', nr_values
        stop 1
    end if
    do i = 1, nr_values
        read (unit=unit_nr, fmt=*, iostat=istat, iomsg=msg) values(i)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                'error: I/O error ', trim(msg)
            stop 2
        end if
    end do
    call qsort(values)
    if (mod(nr_values, 2) == 0) then
        median_value = 0.5*(values(nr_values/2) + values(nr_values/2 + 1))
    else
        median_value = values(nr_values/2 + 1)
    end if
    deallocate (values)
end function compute_median
~~~~

The array `values` is declared `allocatable`, the `allocate` statement ensures that
memory is reserved to store `nr_values` real valued elements.  Using the `allocated`
intrinsic function you can check whether the memory allocation succeeded, if not,
the function aborts.  The `values` array is subsequently used as any other
one-dimensional array.  When the median has been computed, the array `values` is no
longer required, and can be deallocated using the `deallocate` statement to free up
the memory.

Strictly speaking, you don't have to use `deallocate` in this particular example.
The scope of the allocatable variable is limited to the function, and the Fortran
runtime will automatically deallocate such a variable when it goes out of scope, i.e.,
when the function returns.

However, it is good practice to explicitly deallocate memory when it is no longer
required.  Forgetting to do so may lead to a type of bug called a memory leak.  The
application will use more and more memory until all available memory is in use.

Besides n-dimensional arrays, scalar values can be allocated as well.  This can be
useful to implement dynamic data structures such as lists or trees.  However, these
implementations are typically using pointers, so you will see examples later.


## Allocatables and procedures

Can you pass an allocated variable to a procedure?  Can you allocated a variable in
a procedure and use it in the calling context?  The answer to all these questions is
"yes" as we will discuss below.

### Passing an allocated variable to a procedure

Allocated variables can be passed as arguments to procedures, indeed, the definition
of the subroutine `qsort` that is called in the function is shown below.  Its
argument is simply a deferred-size one-dimensional array.

~~~~fortran
subroutine qsort(values)
    implicit none
    real, dimension(:), intent(inout) :: values

...
end subroutine qsort
~~~~


### Allocating in a procedure


