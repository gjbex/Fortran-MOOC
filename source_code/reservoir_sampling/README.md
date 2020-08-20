# Resesrvoir sampling

Reservoir sampling is a useful randomized algorithm to get a representative
of a population of unknown size that is presented as a data stream.

See the [Wikipedia entry](https://en.wikipedia.org/wiki/Reservoir_sampling)
for details.

## What is it?

1. `utilities_mod.f90`: implementation of Fisher-Yates shuffle algorithm
   on an array.
1. `test_permutations.f90`: program to test the Fisher-Yates algorithm.
1. ``create_data.f90`: program to create a data file using direct access I/O.
1. `shuffle_data.f90`: program that shuffles the values in a data file,
   illustrating read/write access and direct access I/O.
1. `reservoir_sampling.f90`: program that does reservoir sampling on a file.
1. `optimal_reservoir_sampling.f90`: optimal implementation of reservoir
   sampling.
1. `show_distrubution.sh`: Bash script to display the distribution in
   the sample.
1. `CMakeLists.txt`: CMake file to build the applications.


## How does it work?

The application `create_data.exe` is used to generate a data file that
contains the numbers 1, 2 and 3.  There will be 10 times as many 2 entries
as 1 enries, and 100 times as many 3 entries as 1 entries.
The total number of entries is controlled by the second command line
argument.

```bash
$ ./create_data.exe  data.txt  1000
```

The file `data.txt` will contain 1000 values of 1, 10000 values of 2,
and 100000 values of 3 in that order.

The application `shuffle_data.exe` can be used to shuffle the original
data file so that the entries will be in random order.

```bash
$ ./shuffle_data.exe  data.txt
```

Note that the shuffle happens in-place.

The applications `reservoir_sampling.exe` and `optimal_reservoir_sampling.exe`
can now be used for sampling the shuffled data.  The first argument is the
data file and the second is the size of the reservoir, i.e., the sample size.

```bash
$ ./reservoir_sampling.exe  data.txt  100  >  sample.txt
```

To check the distribution of the sample, the `show_distribution.sh` can be
used.

```bash
$ ./show_distrubution.sh  sample.txt
```
