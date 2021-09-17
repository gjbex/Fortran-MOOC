# Input and output

## Question 1

Which of the following statements is correct?

1. Formatted I/O is always sequential. [No, e.g., direct I/O can also be formatted]
1. Unformatted I/O is faster than formatted I/O for numerical data. [Indeed] [x]
1. Direct I/O is faster than sequential I/O. [No, sequential I/O is faster]
1. Unformatted I/O is a good choice for checkpointing. [Indeed, it very often is] [x]


## Question 2

Which of the following statements is correct?

1. Sequential and direct unformatted I/O are record-based. [Indeed] [x]
1. Binary files written by a C program can easily be read using direct I/O in Fortran. [No, not at all]
1. When you read or write using direct I/O, you have to specify a record ID. [Indeed] [x]
1. Direct I/O allows random access to a file. [Indeed] [x]


## Question 3

Which of the following statements is correct?

1. Streaming I/O was introduced to allow the creation of binary files that can be read using application developed in other programming languages. [Indeed] [x]
1. Asynchronous I/O is required when you want to write to multiple files in your application. [No, check what asynchronous I/O is for]
1. In Fortran, you can overlap computation and I/O operations. [Indeed] [x]
1. The I/O mode (sequential, direct or streaming) is set using the mode argument in the open statement. [No, check that again]
