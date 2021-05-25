# Linked list implementations

Implementations of linked lists to show various Fortran features.

## What is it?

1. `linked_real_list`: single linked list implementation without error handling
   to illustrate the use of pointers as transparantly as possible.
1. `linked_real_list_error_handling`: implementation with error handling.
1. 'generic_linked_list`: generic snigle linked list implementation using the
   C preprocessor.
1. 'CMakeLists.txt`: CMake file to build the applications.

Note: the compiler generates a warning about comparing real numbers for lists
that have real numbers as values.  Can this warning be ignored, and if not,
how would you remedy the underlying issue?
