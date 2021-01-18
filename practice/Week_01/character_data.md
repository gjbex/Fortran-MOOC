# Character data

## Question 1

When you declare a variable as `character(len=*) :: str = 'abcde'` in the program unit,
1. the length of `str` will be that of the string assigned to it, so 5. [Not really, check what happens.]
1. your code will not compile [Indeed, we will later see what assumed character lengths are about.] [x]
1. the length of `str` will be set automatically to some value defined by the compiler implementation, so this is not good practice [Not really, check what happens.]


## Question 2

When two variables are declared as `characber(len=5) :: s1 = 'abc', s2 = 'cde'` the concatenation of those string will be
1. `'abccde'`
1. ``abc  cde'`
1. `'abccde    '`
1. `'abc  cde  '`


The declaration `character(len=3) :: str = 'abcde'` will result in
1. a compilation error since the string constant is too long to store in `str` [No, the compiler will happily accept this.]
1. a segmentation fault at runtime since the assignment is using unallocated memory when trying to store the value [No, it will run just fine.]
1. the length of `str` will automatically be modified to 5 by the compiler [That would be cute, but fortunately that doesn't happen.]
1. the variable `str` will simply contain `'abc'`. [Correct, the declaration of the length ensures that only that many characters are stored upon assignment, ignoring the remainder.] [x]
