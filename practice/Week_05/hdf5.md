# HDF5

## Question 1

Which of the following statements is true?

1. Using HDF5 has a little overhead in execution time when compared with binary I/O. {indeed, if you do binary I/O efficiently, you'll beat HDF5] [x]
1. HDF5 files are human-readable. [No, open one in an editor and see for yourself]
1. You can annotate data sets with arbitrary character data. [Indeed, this allows you to add meta-information conveniently] [x]
1. An HDF5 requires at least one group. [No, you can have an HDF5 files that contains one or more data sets, but no groups]


## Question 2

Which of the following statements is true?

1. A simple data space consists of the name, the rank the dimensions and the type of the data. [No, almost, but not quite]
1. The data type specified reading from a data set (i.e., the data type in memory) should be identical to that of the data set. [No, they can be different, which makes this a portable data format]
1. The data in HDF5 files can be automatically compressed/decompressed. [Indeed, although that has an impact on I/O performance] [x]
1. Data sets can be defined variable length, so they can be extended in one dimension in an existing file. [Indeed] [x]


## Question 3

Which of the following statements is true?

1. HDF5 supports reading and writing non-contiguous data. [Indeed, that's what hyperslabs are for] [x]
1. When an application performs a write operation, the data is not necessarily written to the file system immediately. [Indeed, the library may optimize I/O operations] [x]
1. HDF5 has facilities for error-correction. [No, it can do error detection, but not correction]
1. When you have a parallel file system, multiple threads or processes can write concurrently to an HDF5 file. [Indeed] [x]
