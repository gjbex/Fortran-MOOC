# Logical data

## Question 1

When we have the following declaration, `logical :: l1 = .false., l2 = .true., l3 = .false.`, which of the following logical expressions will evaluate to `.true.`?
1. `l1 .and. l2 .or. l3` [This will evaluate to `.false.`, remember the priority of logical operators.]
1. `l1 .or. l2 .and. l3` [This will evaluate to `.false.`, remember the priority of logical operators.]
1. `l1 .or. (l2 .and. l3)` [This will evaluate to `.false.`]
1. .not. l1 .and. l2 .or. l3` [This will evaluate to `.true.` thanks to the priority of the various logical operators.] [x]
