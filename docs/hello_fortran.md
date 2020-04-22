# Hello Fortran

In this article you'll get a brief overview of what a simple Fortran program
looks like.

Fortran programs consist of compilation units, and must have one and only one
`program` unit.  The code you see below is the "hello world" application in
Fortran

~~~~fortran
program hello_fortran
    print *, 'hello Fortran!'
end program hello_fortran
~~~~

The `program` unit's statements are bracketed by `program <name>` and
`end program <name>`.  In this case, the unit has just a single statement,
the `print` statement that will write the string `'hello Fortran~'` to
standard output.  The `*` denotes the default format, but you will learn
more about that later.

On the command line, you can compile the source code in 'hello_world.f90`
into an executable application using a compiler.  Here, we will use the GCC
Fortran compiler.

~~~~bash
$ gfortran hello_fortran.f90
~~~~

The resulting executable is `a.out` and when you run it, it will print the
expected output.

~~~~bash
$ ./a.out
 hello Fortran!
~~~~
