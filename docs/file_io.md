# File I/O

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

| I/O mode    | file size | walltime |
|-------------|-----------|----------|
| unformatted | 1.0       |  1.0     |
| formatted   | 2.3       | 33.0     |

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
the documentation of your binary file format is crucial.
