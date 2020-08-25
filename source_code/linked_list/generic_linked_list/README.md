# Generic linked list

This is a generic implementation of a single linked list that uses cpp to
generate type-specific code.

## What is it?

1. `linked_list_mod.F90`: generic linked list implementation, to be included
   into type-specific modules for implementations.
1. `integer_list.F90`: module for a list with integer elements.
1. `real_list.F90`: module for a list with real elements.
1. `test_list.f90`: program to test the real implementation.
1. `test_multiple_lists.f90`: program to test the usage of multiple lists
   of distinct types in a single program.
