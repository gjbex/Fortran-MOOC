# File I/O

Up to this point we only discussed a very limited subset of Fortran's file I/O
capabilities.  You read about formatted sequential I/O to read and write text
files.  However, Fortran can also read and write binary files.

It also has two more access modes for I/O, direct and stream, which each have
their specific use cases.

Finally, you will also learn about eh `inquire`statement that can be used to
obtain information on files.


## Formatted versus unformatted I/O

Using formatted I/O has the advantage that files are human readable. You can
open them in a text editor or inspect them using tools such as `cat` or
`less`.

However, there are some disadvantages as well.
1. text files are typically larger than binary files that contain the same
   information.
1. Formatted I/O is requires converting data to a textual representation,
   or vice versa.  This has a performance impact, increasing the time
   required for I/O.
1. When you convert a floating point value to a text representation when you
   write to a file, and subsequently convert that text representation back to
   a floating point value when you read the file, these two floating point
   values may not be identical.
1. It is very hard to do parallel I/O using text files.

Programming languages support binary I/O, i.e., writing the actual bit
representation of data to a file.  Fortran is no exception to this, and the
term used for this is unformatted I/O.

When comparing the performance of writing 200 million floating point values
to a file, the difference between formatted and unformatted I/O is quite
interesting.  The table below shows relative numbers.

| `form`          | file size | walltime |
|-----------------|-----------|----------|
| `'unformatted'` | 1.0       |  1.0     |
| `'formatted'`   | 2.3       | 33.0     |

The relative walltime difference depends of course on the file system that
is used, as well as the underlying hardware.  The file size of the formatted
file depends on the format specifier that is used.  This means that
in practice, your mileage may vary.

Using sequential unformatted I/O is straightforward.  The open statement is
nearly identical to that of formatted I/O, i.e.,

~~~~fortran
open (newunit=unit_nr, file=file_name, form='unformatted', &
      access='sequential', action='write', status='new', iostat=istat, &
      iomsg=msg)
~~~~

The only difference is `form='unformatted'`.  For the write statement, the
`fmt` argument is omitted, e.g.,

~~~~fortran
write (unit=unit_nr, iostat=istat, iomsg=msg) r, theta
~~~~

Similar for a read statement, e.g.,

~~~~fortran
read (unit=unit_nr, iostat=istat, iomsg=msg) r, theta
~~~~

You can write any combination of types to an unformatted file, but of course,
you would have to read it using the exact same data types.  This implies that
the documentation of your binary file format is crucial.  Another potential
disadvantage is that the binary representation of data may differ from one
hardware platform to the other.

As an alternative to unformatted I/O you may consider HDF5, a file format we
will discuss later that has many advantages.


## Direct access I/O

As the name implies, sequential I/O is, well, sequential.  When you read or
write a file, you start at the beginning, and proceed towards the end.  This
approach is quite suited to many use cases, but not all.  Consider for
instance storing the results of computationally expensive calculations in a
file for future reference, either during the same run of the application, or
for later runs.  If you can map compute the position of the required result
in the file, it would be if you could simply read only that particular result,
rather than starting at the beginning of the file and having to read until
the desired position was reached.

Fortran supports direct access I/O, which is record-oriented. The file can be
considered as a sequence of records of identical type.  A read or write
operation addresses a specific record in that file.  The records can be written
or read in any order.

The following code fragment illustrates opening a file for direct access
formatted writing.

~~~~fortran
open (newunit=unit_nr, file=trim(file_name), form='formatted', &
      access='direct', recl=rec_width, action='write', status='new', &
      iostat=istat, iomsg=msg)
~~~~

Note that access is `'direct'`, and that you have to specify a fixed
record length `recl` when you open the file.

When a record is written, you have to specify its record ID.

~~~~fortran
write (unit=unit_nr, fmt=fmt_str, rec=idx) idx, x
~~~~

The record ID is specified via the `rec` argument, and in this example, each 
record consists of an integer and a real value.

As for sequential I/O, direct access I/O can be formatted or unformatted.

You should realize that I/O subsystems, especially those on HPC systems, are
optimized for reading or writing data is is stored consecutively on disk, so
accessing data in some random order via direct I/O will have a large impact
on I/O performance.  Only use direct access I/O when it really fits your use
case.


## Stream I/O

Besides sequential and direct access I/O, Fortran supports a third I/O options.
Both of these I/O type are essentially record-based, and not compatible with
files that have been created by non-Fortran applications.  Stream I/O is
suitable for this use case.

For stream I/O, the unit of I/O is a byte, and this ensures that files written
by a Fortran application can be read by other applications, or that a Fortran
application can read binary data produced by other applications.

Using stream I/O is straightforward as illustrated by the open statement
below and write statements below.

~~~~fortran
open (newunit=unit_nr, file=file_name, form='unformatted', &
      access='stream', action='write', status='new', iostat=istat, &
      iomsg=msg)
~~~~

The access mode is `'stream'`.

~~~~fortran
write (unit=unit_nr, iostat=istat, iomsg=msg) r, golden_spiral(r)
~~~~

The write statement as well as the read statement are identical to those for
sequential access.

The performance of stream I/O is better than that of sequential I/O, and the
file size is also smaller due to the lack of record terminators in the
resulting files.

| `access`       | file size | walltime |
|----------------|-----------|----------|
| `'sequential'` | 1.5       |  1.8     |
| `'stream'`     | 1.0       |  1.0     |

As for all benchmarks, you mileage may vary depending on relative record
size and the characteristics of your file storage.

As for the other access types, stream I/O can be either formatted or
unformatted.  However, formatted stream I/O is rarely used in practice.


## How to get information on files?

The inquire statement can be used to retrieve information on files and units.

For instance, you can use it to check whether a file named 'data.txt' exists.

~~~~fortran
logical :: file_exists
...
inquire ('data.txt', exist=file_exists)

The following statement would retrieve the size in bytes of the file `data.txt`.

~~~~fortran
integer :: file_size
...
inquire ('data.txt', size=file_size)
~~~~

Based on the unit number, you can retrieve the file name.  This can be
convenient to generated meaningful error message in procedures that only get a
unit number passed as argument.

~~~~fortran
character(len=1024) :: file_name
...
inquire(unit=unit_nr, name=file_name)
~~~~

When doing stream I/O, the inquire statement can be used to determine the
current position in a file.

~~~~fortran
integer :: position
...
inquire (unit=unit_nr, pos=position)
~~~~

This position can subsequently be used to reposition the read or the
write statement using the `pos` argument.

## I/O performance

In conclusion, for formatted I/O, sequential access is the most convenient,
while for unformatted I/O stream access yields the best performance and
interoperability.  Still, sequential unformatted I/O may be required if
compatibility with other Fortran applications that use it is required.
Direct access I/O is only used when you require random access to a file.

In general, it is best to read or write as much  information as possible in a
single statement, so rather than iterating over the elements of an array to
write them to a file, write the entire array at once.

~~~~fortran
real, dimension(1000) :: x
integer :: stat
character(len=1024) :: msg
...
write (unit=unit_nr, iostat=stat, iomsg=msg) x
~~~~

Since the latency for file I/O are fairly high, the CPU is typically not fully
used while files are read or written.  Fortran has features that allow to
overlap I/O operations and computations, i.e., while I/O operations are in
progress, the CPU can perform computations, using asynchronous I/O.


## Asynchronous I/O

To achieve overlap between I/O operations and computation variables can
be declared `asynchronous`, `buffer` in the code fragment below.  When opening
a file, you have to specify that you want to do asynchronous I/O.  For instance,
when an array `buffer` is written to a file, the write statement should have
the `asynchronous` attribute.  While the I/O operation progresses, computations
that do not modify the data that is currently written, i.e., the array `bufer`.

Before changing the data in `buffer`, you would have to check whether the
I/O operation is still pending, and if so, you have to wait until undone it
is done.  The inquire statement can be used to check this, and the wait
statement that will halt the execution until the asynchronous I/O operation is
completed.

~~~~fortran
real, dimension(:), allocatable, asynchronous :: buffer
...
open (newunit=unit_nr, file=file_name, form='unformatted', &
      asynchronous='yes', action='write', access='stream', status='replace', &
      iostat=istat, iomsg=msg)
...
write (unit=unit_nr, asynchronous='yes', id=id1) buffer1
! computation that doesn't modify buffer
call do_some_heavy_computing(...)
inquire (unit=unit_nr, id=id2, pending=pending)
if (pending) wait(unit=unit_nr)
! computation that can modify buffer
call do_other_computations(...)
...
~~~~

The example above is for a write operation, but this applies equally well to
asynchronous read operations.  The important point is that while data is
involved in an asynchronous I/O operation, that data should not be modified
for write operations, or used during read operations.  The inquire and wait
statements are used to ensure this.

The performance improvement that you can achieve using asynchronous I/O depends
very strongly on the level of overlap that can be achieved, and that depends in
turn on the granularity of the I/O operations versus the computations.  Of
course it makes no sense to invest time in asynchronous I/O unless the I/O
operations account for a considerable fraction of the total walltime.  You
should profile your application to determine this.
