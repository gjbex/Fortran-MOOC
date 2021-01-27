# Reading and writing files

## Question 1

In an open statement, which of the following combinations make sense?
1. `action='read'` and `status='replace'` [Not really, no.]
1. `action='write'` and `status='new'` [Indeed.] [x]
1. `action='read'` and `status='old'` [Indeed.] [x]
1. `action='write'` and `status='old'` [Indeed.] [x]
1. `action='read'` and `status='scratch'` [Not really, no.]


## Question 2

If you open a file `my_text.txt` for reading, it can be closed using the following statement `close (file='my_text.txt')`, is this
1. true? [No, you would use the unit number.]
1. false? [Indeed, the close statement has no file argument.] [x]


## Question 3

You can have the Fortran runtime pick a free unit number when opening it by
1. using the value -1 as the unit number. [No, that wouldn't work.]
1. using the `free_unit` intrinsic function. [No, that doesn't exit.]
1. using the `newunit` argument. [Indeed.] [x]
1. using the `newunit` logical argument and the `unit` argument. [No, they can not be combined.]
