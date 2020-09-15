# Dynamic memory allocation

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


## Allocation statements and related procedures

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


## Allocating character variables

Sometimes you do not now the length of a character variable at compile time, for
instance when dealing with command line arguments or environment variables.  You
can declare an assumed length variable, and allocate it at runtime.

~~~~fortran
...
character(len=:), allocatable :: buffer
integer :: buffer_len
...
allocate (character(len=buffer_len) :: buffer, stat=istat)
...
~~~~

The length of the variable `buffer` is now determined dynamically.  As with any
allocatable variable, `buffer` should be deallocated to avoid memory leaks,
unless it is local to a procedure.


## Cloning

The `allocate` statement has an optional argument `source` that can be used
to "clone" existing data structures.  For instance, you may be working with an
array, and require a temporary helper array of the same shape.  In that case,
the existing array can be passed as a template to the `allcoate` statement
that will allocate the temporary array with the same shape, size and lower and
upper index bound.  Also the elements will have the same values.

~~~~fortran
...
real, dimension(0:10) :: values
real, dimension(:), allocatable :: tmp_values
...
allocate (tmp_values, source=values)
~~~~

The array `tmp_values` will have the same size as `values, i.e., 11 elements
nad the same lower and upper index, i.e., 0 and 10 respectively.

You will see later that the `source` argument can also conveniently be used to
initialize allocatable objects.


## Allocatables and procedures

Can you pass an allocated variable to a procedure?  Can you allocated a variable in
a procedure and use it in the calling context?  The answer to all these questions is
"yes" as we will discuss below.

### Passing an allocated variable to a procedure

Allocated variables can be passed as arguments to procedures, indeed, the definition
of the subroutine `qsort` that is called in the function is shown below.  Its
argument is simply an assumed-shape one-dimensional array.

~~~~fortran
subroutine qsort(values)
    implicit none
    real, dimension(:), intent(inout) :: values

...
end subroutine qsort
~~~~


### Allocating in a procedure

You can also pass an `allocatable` variable as an argument to a procedure
and allocate it in that procedure.  The newly allocated variable can be
used in the calling context.

The following subroutine to initialize an allocatable one-dimensional
array illustrates this.  If the variable passed to the procedure is
already allocated, it first deallocates the variable to avoid a memory
leak.  Next it will allocate the array to the given size and verify that
the allocation succeeded.  If not, it will write an error message to
standard error and halt the application.  Optionally, it will
initialize the elements.

~~~~fortran
subroutine allocate_array(array, array_size, msg, init)
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    real, dimension(:), allocatable, intent(inout) :: array
    integer, value :: array_size
    character(len=*),intent(in) :: msg
    real, value, optional :: init

    ! if the array is allocated, deallocate it first
    if (allocated(array)) &
        deallocate(array)

    ! allocate for specified size and check 
    allocate(array(array_size))
    if (.not. allocated(array)) then
        write (unit=error_unit, fmt='(3A, I0)') &
            'error: can not allocate array ', trim(msg), &
            ' of size ', array_size
        stop 101
    end if

    ! if necessary, initialize array
    if (present(init)) &
        array = init
end subroutine allocate_array
~~~~

This subroutine can be called as follows.

~~~~fortran
...
real, dimension(:), allocable :: array
...
call allocate_array(array, 100, 'data')
...
deallocate(array)
...
~~~~

Note that the variable `array` has to be deallocated when it is no
longer required.

This subroutine illustrates that variables can be allocated and/or
deallocated in procedures, even when they are passed as arguments.


## User defined types and allocatable

An element of a user defined type can be allocatable.  As an example,
consider the following definition of a type to store statistical data.

~~~~fortran
type :: descriptive_stats_t
    integer :: nr_values = 0
    real :: sum = 0.0, sum2 = 0.0
    real, dimension(:), allocatable :: values
end type descriptive_stats_t
~~~~

The element `values is an allocatable array of real values. You can
initialize a variable of type `descriptive_stats_t` easily.

~~~~fortran
type(descriptive_stats_t) :: stats
...
allocate(stats%values(100)
...
~~~~

To create data structures such as lists and graphs, allocating
variables of user defined types is also quite useful, but you will
see example of that in the section on pointers.


## Moving allocations

Although not used very frequently, you should know about `move_alloc`
because it can come in very handy in certain situations.

The following subroutine illustrates this.  It will "resize" an array
that is only partially filled with values to its "true" size.

All the elements of the allocatable array `array` that is passed to the
subroutine as an argument have been initialized to positive infinity.
Values were assigned to elements in order, i.e., from the lowest index
to some index value.  The "true" size of the array is the number of
elements that are not infinity, so the index of first infinity minus
the index lower bound.

The subroutine determines the "true" size of the array, allocates a
temporary array `temp` of that size, copies the elements, and moves the
allocation of the temporary array `temp` to the subroutine argument
`array`.

~~~~fortran
subroutine trim_array(array)
    use, intrinsic :: ieee_arithmetic, only : ieee_is_finite, &
                      ieee_value, ieee_positive_inf
    implicit none
    real, dimension(:), allocatable, intent(inout) :: array
    real, dimension(:), allocatable :: temp
    integer :: idx
    real :: infinity
    infinity = ieee_value(infinity, ieee_positive_inf)

    ! if the array is not allocated, create one with size zero
    if (.not. allocated(array)) then
        allocate(array(0))
        return
    end if

    ! find the location of the first infinity
    idx = findloc(array, infinity, dim=1)
    ! if the array is not full, create a new one of the required size
    if (idx > 0) then
        call allocate_array(temp, idx - 1, 'trimmed')
        if (idx > 1) temp = array(1:idx - 1)
        call move_alloc(temp, array)
    end if
end subroutine trim_array
~~~~

Note the call to `move_alloc`, this will ensure that `array` gets
deallocated, and that the allocation to `temp` is transferred to
`array`.  The array `array` is allocated in the calling context, while
the array `temp` is allocated in the subroutine.  Since `arrays` is
deallocated by `move_alloc` there is no memory leak.
