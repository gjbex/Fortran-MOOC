# Coding best practices: reading material

A number of very simple things go a long way towards improving your code substantially. For good programmers, they are second nature, and you should strive to make them a habit.


## Format your code nicely

To quote Robert C. Martin, "Code formatting is about communication, and communication is the professional developer’s first order of business".

All programming languages have one or possibly multiple conventions about how to format source code. For example, consistent indentation of code helps considerably to assess the structure of a compilation unit at a glance. For multi-level indentation, always use the same width, e.g., multiples of four spaces.

The convention you have to use is often determined by the community you are working with, for instance your co-workers.  It is best to stick to that convention, since coding is communicating. If no convention is established, consider introducing one.  The one which is prevalent in the programming language community is most likely to be your best choice.

Whichever convention you follow, be consistent!


## Use language idioms

Linguists use the term "idiom" for an expression that is very specific to a certain language and that cannot be translated literally to another. For instance, the English idiom "it is raining cats and dogs" would translate to "il pleut des cordes" in French.  The corresponding idiom in French is completely unrelated to its counterpart in English. Mastering idioms is one of the requirements for C1 certification, i.e., to be considered to have a proficiency close to that of native speakers.

We observe a similar phenomenon for programming languages. Some syntactic constructs are typical for a specific programming language but, when translated one-to-one into another language, lead to code constructs that are unfamiliar to programmers who are proficient in that language.  The code fragments below illustrate this.

~~~~fortran
real, dimension(10) :: a
...
a = value
~~~~

rather than

~~~~fortran
integer :: i
real, dimension(10) :: a
...
do i = 1, 10
    a(i) = value
end do
~~~~

Using idioms, i.e., expressions that are particular to a (programming) language, will make your code much easier to interpret correctly by programmers that are fluent in that language.


## Choose descriptive names

In a way, programming is storytelling. The data are the protagonist in the story, and the procedures are the actions they take, or what happens to them. Hence variable names should be nouns and procedures names should be verbs. If a procedure returns a property, it should be phrased as a question.

Any editor worth its salt provides completion, so you can't argue in favor of short but less descriptive names to save typing. A long but descriptive name is just a tab character away.

Choosing descriptive names for variables and procedures is another aspect that can make reading your code much easier. Consider the following code fragment, and although I'll grant that it is something of a caricature, I've seen some in the wild that are not significantly better.

~~~~fortran
open (fn, 'data.txt')
do i = 1, n
    x = get(i, fn)
    if (condition(x)) then
        a = compute(x)
        if (a < 3.14) &
            call do_something(a)
    end if
end if
close (fn)
~~~~

A key principle of good software design is that of the least surprise. Choosing appropriate names for our variables and procedures helps a lot in this respect.


## Keep it *simple*

Ideally, code is simple.  A procedure should have two levels of indentation at most.  This is advice you'll find in the literature on general purpose programming. Although this is good advice, there are some caveats in the context of scientific computing.

However, the gist is clear: code is as simple as possible, but not simpler.

Even for scientific code, a procedure has no more lines of code than fit comfortably on your screen. It is all too easy to lose track of the semantics if you can't get an overview of the code. Remember, not everyone has the budget for a 5K monitor.

If you find yourself writing a very long code fragment, ask yourself whether that is atomic, or whether the task it represents can be broken up into sub-tasks. If so, and that is very likely, introduce new procedures for those sub-tasks with descriptive names. This will make the narrative all the easier to understand.

A procedure should have a single purpose, i.e., you should design it to do one thing, and one thing only.

For procedure signatures, simplicity matters as well.  Procedures that take many arguments may lead to confusion.  In Fortran you can use keyword arguments in procedure calls.  Since accidentally swapping argument values with the same type in a procedure call can lead to interesting debugging sessions, you are strongly advised to use that syntax feature.  Consider the following procedure signature:

~~~fortran
real function random_gaussian(mu, sigma)
    implicit none
    real, intent(in) :: mu, sigma
    ...
end function random_gaussian
~~~

You would have to check the documentation to know the order of the function arguments.  Consider the following four function calls:

  1. `random_gaussian(0.0, 1.0)`: okay;
  1. `random_gaussian(1.0, 0.0)`: not okay;
  1. `random_gaussian(mu=0.0, sigma=1.0)`: okay;
  1. `random_gaussian(sigma=1.0, mu=0.0)`: okay.

The two last versions of this call are easier to understand, since the meaning of the numbers is clear.  Moreover, since you can use any order, it eliminates a source of bugs.


## Limit scope

Many programmers will declare all variables at the start of a compilation unit. This is a syntax requirement in Fortran.

Limiting the scope of declarations to a minimum reduces the probability of inadvertently using the variable, but it also improves code quality: the declaration of the variable is at the same location where the variable is first used, so the narrative is easier to follow.

Fortran requires that variables are declared at the start of a compilation unit, i.e., `program`, `function`, `subroutine`, `module`, but Fortran 2008 introduced the `block` statement in which local variables can be declared. Their scope doesn't extend beyond the `block`. Modern compilers support this Fortran 2008 feature.

Note that Fortran still allows variables to be implicitly typed, i.e., if you don't declare a variable explicitly, its type will be `integer` if its starts with the characters `i` to `n`, otherwise its type will be `real`.

Consider the code fragment below. Since the variables were not declared explicitly, `i` is interpreted as `integer` and `total` as `REAL`. However, the misspelled `totl` is also implicitly typed as `real`, initialized to `0.0`, and hence the value of `total` will be `10.0` when the iterations ends, rather than `100.0` as was intended.

~~~~fortran
integer :: i
real :: total
do i = 1, 10
    total = totl + 10.0
end do
~~~~

To avoid these problems caused by simple typos, use the `implicit none` statement before variable declarations in `program`, `module`, `function`, `subroutine`, and `block`, e.g,

~~~~fortran
implicit none
integer :: i
real :: total
do i = 1, 10
    total = totl + 10.0
end do
~~~~

The compiler would give an error for the code fragment above since all variables have to be declared explicitly, and `totl` was not.

In Fortran it is possible to restrict what to use from modules, e.g.,

~~~~fortran
use, intrinsic :: iso_fortran_env, only : REAL64, INT32
~~~~

The `only` keyword ensures that only the parameters `REAL64` and `INT32` are imported from the `iso_fortran_env` module.

Note that the `intrinsic` keyword is used to ensure that the compiler supplied module is used, and not a module with the same name defined by you.

When developing multi-threaded C/C++ programs using OpenMP, limiting the scope of variables to parallel regions makes those variables thread-private, hence reducing the risk of data races. We will discuss this in more detail in a later section.  Unfortunately, the semantics for the Fortran `block` statement in an OpenMP do loop is not defined, at least up to the OpenMP 4.5 specification.  Although `gfortran` accepts such code constructs, and seems to generate code with the expected behavior, it should be avoided since Intel Fortran compiler will report an error for such code.


## Be explicit about constants

If a variable's value is not supposed to change during the run time of a program, declare it as a constant, so that the compiler will warn you if you inadvertently modify its value. You can use `parameter` to that effect.

If arguments passed to procedures should be read-only, use `intent(in)` (or `value`) . Although the Fortran standard doesn't require that you state the intent of arguments passed to procedures, it is nevertheless wise to do so. The compiler will catch at least some programming mistakes if you do.


## Control access

When defining classes in Fortran, some attention should be paid to accessibility of elements of the user defined types. An object's state is determined by the value of these elements , so allowing unrestricted access to them may leave the object in an inconsistent state.

Elements in user defined types and procedures defined in modules are public by default. Regardless of the defaults, it is useful to specify the access restrictions explicitly. It is good practice to specify private access as the default, and public as the exception to that rule.

Interestingly, both Fortran and C++ have the keyword `protected`, albeit with very different semantics.  In Fortran, `protected` means that a variable defined in a module can be read by the compilation unit that uses it, but not modified.  In the module where it is defined, it can be modified though.  In C++, an attribute or a method that is declared `protected` can be accessed from derived classes as well as the class that defines it.  However, like attributes and methods declared `private`, it can not be accessed elsewhere.

This is another example where getting confused about the semantics can lead to interesting bugs.

In summary:

| access modifier | C++                                           | Fortran |
|-----------------|-----------------------------------------------|---------|
| private         | access restricted to class/struct             | access restricted to module |
| protected       | access restricted to class/struct and derived | variables: modify access restricted to module, read everywhere |
| public          | attributes and methods can be accessed from everywhere | variables, types and procedures can be accessed from everywhere |
| none            | class: private, struct: public                | public |


## Variable initialization

The specifications for Fortran does not define the value an uninitialized variable will have. So you should always initialize variables explicitly, otherwise your code will have undefined, and potentially non-deterministic behavior. When you forget to initialize a variable, the compilers will typically let you get away with it. However, most compilers have optional flags that catch expressions involving uninitialized variables. We will discuss these and other compiler flags in a later section.

When initializing or, more generally, assigning a value to a variable that involves constants, your code will be easier to understand when those values indicate the intended type. For example, using `1.0` rather than `1` for floating point is more explicit. This may also avoid needless conversions. This also prevents arithmetic bugs since `1/2` will evaluate to `0`.  Perhaps even more subtly, `1.25 + 1/2` will also evaluate to `1.25`, since the division will be computed using integer values, evaluating to `0`, which is subsequently converted to the floating point value `0.0`, and added to `1.25`.


## To comment or not to comment?

Comments should never be a substitute for code that is easy to understand. In almost all circumstances, if your code requires a comment without which it can not be understood, it can be rewritten to be more clear.

Obviously, there are exceptions to this rule. Sometimes we have no alternative but to sacrifice a clean coding style for performance, or we have to add an obscure line of code to prevent a problem caused by over-eager compilers.

If you need to add a comment, remember that it should be kept up-to-date with the code. All too often, we come across comments that are no longer accurate because the code has evolved, but the corresponding comment didn't. In such situations, the comment is harmful, since it can confuse us about the intentions of the developer, and at the least, it will cost us time to disambiguate.

The best strategy is to make sure that the code tells its own story, and requires no comments.

A common abuse of comments is to disable code fragments that are no longer required, but that you still want to preserve. This is bad practice. Such comments make reading the code more difficult, and take up valuable screen real estate.
Moreover, when you use a version control system such as git or subversion in your development process, you can delete with impunity, in the sure knowledge that you can easily retrieve previous versions of your files. If you don't use a version control system routinely, you really should. See the additional material section for some pointers to information and  tutorials.


## Stick to the standard

The official syntax and semantics of a programming language like Fortran is defined in official specifications. All compilers that claim compliance with these standards have to implement these specifications.

However, over the years, compiler developers have added extensions to the specifications. The Intel Fortran compiler for instance can trace its ancestry back to the DEC compiler, and implements quite a number of Fortran extensions. Similarly, the GCC `gfortran` compiler supports some non-standard features as well.

It goes without saying that your code should not rely on such compiler specific extensions, even if that compiler is mainstream and widely available. There is no guarantee that future releases of that same compiler will still support the extension, and the only official information about that extension would be available in the compiler documentation, not always the most convenient source.

Moreover, that implies that even if your code compiles with a specific compiler, that doesn't mean it complies with the official language specification. An other compiler would simply generate error message for the same code, and would fail to compile it.

Using language extensions makes code harder to read. As a proficient programmer, you're still not necessarily familiar with language extensions, so you may interpret those constructs incorrectly.

Hence I'd encourage you strongly to strictly adhere to a specific language specification.  The relevant specification for Fortran are those of 2003 (ISO/IEC 1539-1:2004), 2008 (ISO/IEC 1539-1:2010) and 2018 (ISO/IEC 1539-1:2018). References to those specifications can be found in the section on additional material.


## Copy/paste is evil

If you find yourself copying and pasting a fragment of code from one file location to another, or from one file to another, you should consider turning it into a function.  Apart from making your code easier to understand, it makes it also easier to maintain.

Suppose there is a bug in the fragment.  If you copy/pasted it, you would have to remember to fix the bug in each instance of that code fragment.  If it was encapsulated in a function, you would have to fix the problem in a single spot only.
