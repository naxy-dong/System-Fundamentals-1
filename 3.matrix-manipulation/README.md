# Homework 3

## Learning Outcomes

After completion of this assignment, you should be able to:

- Manipulate 2D Arrays.

- Write Functions and manage the call stack.

- Perform low-level File I/O Operations.

## Getting Started

To complete this homework assignment, you will need the MARS simulator. Download it from Brightspace. You can write your programs in the MARS editor itself. You can choose to use other text editors if you are not comfortable with the MARS editor. At any point, if you need to refer to instructions click on the *Help* tab in the MARS simulator.

Read the rest of the document carefully. This document describes everything that you will need to correctly implement the homework and submit the code for testing.

You should have already setup Git and configured it to work with SSH. If you haven't then do Homework 0 first!

The first thing you need to do is download or clone this repository to your local system. Use the following command:

`$ git clone <ssh-link>`

After you clone, you will see a directory of the form *cse220-hw3-username*, where *username* is your GitHub username.

In this directory, you will find *hw3.asm*. This file has function stubs that you will need to fill up. The directory also has a template test file ending with *hw3_test.asm*. Use the file for testing.  You can change the data section or the text section in this files to test different cases for each part (described later). You may also create your own *_test.asm* files if necessary. Don't push these additional *_test.asm* files to the repository.

**Note the hw3.asm file doent have a .data section. Do not add a .data section.**

## Assembling and Running Your Program in MARS

To execute your MIPS programs in MARS, you will first have to assemble the program. Click on the *assemble* option in the *Run* tab at the top of the editor. If the instructions in your program are correctly specified, the MARS assembler will load the program into memory. You can then run the program by selecting the *Go* option in the same *Run* tab. To debug your program, add breakpoints. This is done after assembling the program. Select the *execute* tab, you will see the instructions in your program. Each instruction will have a checkbox associated with it. Clicking on the checkbox will add a breakpoint, that is, when the program is run, control will stop at that instruction allowing you to inspect the registers and memory up to that point. The execute tab will show you the memory layout in the bottom pane. The right hand pane shows the list of registers and their values.

Always assume that memory and registers will have garbage data. When using memory or registers, it is your responsibility to initialize it correctly before using it. You can enable the *Garbage Data* option under *Settings* in MARS to run your programs with garbage data in memory.

## Testing

There are no automated tests in this homework repository. You are expected test your implementation systematically with all possible inputs based on the specifications given below. You can take inspiration from previous homeworks and develop your own test suite that is comprehensive and verifies every aspect of your code. To get you started on test data, the *inputs* directory has some test input files. You can use them to test your code. Swap the string in the *Filename* label in *hw3_test.asm* to test the different input files. Any output files produced by your code should be deleted and not added to the repository.

## File I/O in MIPS

To open a file in MIPS, we use the *syscall 13*. This syscall takes the address of a null-terminated string in *$a0*. This string indicates the filename. In *$a1*, we provide the mode in which the file will be opened. This should be 0 for reading and 1 for writing. The register *$a2* is ignored and should be 0. This syscall returns a file descriptor in the register *$v0*. The file descriptor is a pointer to the file we want to open. *$v0* is negative if an error occurs while opening the file. Once we have the file descriptor in *$v0*, we can now read from the file if we opened it in read mode or write to the file if we opened it in write mode.

To read a file, we use the *syscall 14*. It takes a file descriptor in *$a0*, the address of an input buffer in *$a1*, and the maximum no. of characters to read from the buffer in *$a2*. It returns the no. of characters read in *$v0*. It returns 0 in *$v0* if reading from end-of-file and a negative number if an error occurs.

To write to a file, we use the *syscall 15*. It takes a file descriptor in *$a0*, the address of an input buffer in *$a1*, and the no. of characters to write in *$a2*. It returns the no. of characters written in *$v0*. It returns a negative number if an error occurs.  

See the *Help* section in MARS for more information.

## Problem Specification

Suppose we are given a *txt* file that stores a bunch of numbers in a matrix arrangement. The lines in the file have the following format:

- The first line indicates the no. of rows in a two-dimensional (2D) matrix. It must be an integer [1-10].

- The second line indicates the no. of columns in a 2D matrix. It must be an integer [1-10].

- The subsequent lines represent numbers in a matrix. The numbers are positive integers separated by a whitespace.

- Each line represents a row in the  matrix. Each line ends with a terminating character/s. On Windows, line endings are terminated with a combination of carriage return (*\r*) and newline (*\n*) characters, also referred to as CR/LF. On UNIX-based systems, line endings are just the newline character (*\n*).

Here is an example input file:

```
2
3
12 3 24
45 6 17
```

This file indicates a 2D matrix with 2 rows and 3 columns. Each line after the first two lines indicates a row in the matrix. Each line after the first two lines has exactly one whitespace after each number, excluding the last number in a line. Each line terminates with a terminating character/s.

We will parse such files and store them in a data structure `Buffer`:

```
struct Buffer {
  int no_of_rows
  int no_of_cols
  int[100] matrix
}
```

Note we have used C-like syntax to define the data structure `Buffer`. This basically means that the first 4 bytes of `Buffer` will hold the no. of rows in the 2D matrix, the next 4 bytes will hold the no. of columns in the 2D matrix, and the next 400 (4*100) bytes will hold the integers in the matrix. We are assuming that the matrix cannot be bigger than 10 X 10. Assume the structure will be stored in the global data section of the main memory.

We will use this data structure to perform transformative matrix operations as defined below. But first we will see how to read a file's contents and initialize the data structure with it and also how to write the contents in `Buffer` to a an output file.

### Part 1 -- Initialize Data Structure

**int initialize(char\* filename, Buffer\* buffer)**

This function takes two arguments -- a string *filename* and the address of a data structure *buffer* (as defined above). The function will read the content in *filename*, parse it and store the contents in *buffer*. The contents in *buffer* should be in the format defined for the data structure above. So, the first two elements should be the no. of rows and columns of a matrix and the remaining elements should be the integers of the matrix. One way to do this is to read the file one character at a time, and store them in the buffer as integers in appropriate positions.

If the file is read without any errors and the buffer is initialized properly, then the function should return 1 in *$v0*.

The function should return -1 in *$v0* if an error occurs during initialization. When this happens the *buffer* data structure should remain unchanged. You should assume the buffer contains all zeros before initialization. Initialization errors can occur due to the following reasons:

- File I/O error.
- The first two lines are not [1-10].
- The file has more than X lines (excluding the first two lines), where X is the no. of rows in the first line.
- The file has more than Y columns (excluding the first two lines), where Y is the no. of columns in the second line.
- Lines 3 and after have non-numeric characters.
- Numbers in lines 3 and after (except the last number) do not end with exactly one whitespace.

**Note that this function must handle newline characters in both Windows and UNIX-based systems**. On Windows, line endings are terminated with a combination of carriage return (*\r*) and newline (*\n*) characters, also referred to as CR/LF. On UNIX-based systems, line endings are just the newline character (*\n*).   


### Part 2 -- Write Buffer To File

**void write_file(char\* filename, Buffer\* buffer)**

This function takes two arguments -- a string filename and the address of the buffer data structure (as defined above). It should write the data in *buffer* to the file in *filename*. The format of the file is the same as defined previously. Here is an example:

```
2
3
12 3 24
45 6 17
```

for

```
struct Buffer {
  int no_of_rows = 2
  int no_of_cols = 3
  int[100] matrix = [12,3,24,45,6,17,...]
}
```

Remember to close the file after writing. Failure to close a file may lead to memory leaks, which degrades performance in the long run.

You may assume that the matrix space provided will be greater than or equal to the size defined, and that buffer's fields contain valid integers in range.

In the test files you may observe the matrix being given a much larger space than defined in no_of_rows/cols, this is fine and your method should only be concerned with the scope defined in ```matrix[0] to matrix[ (no_of_rows x no_of_cols) ]```  

The function returns the no. of characters written to the file in register `$v0` and -1 if there is an error during writing the file.

### Part 3 -- Rotate Clockwise By 90

**void rotate_clkws_90(Buffer\* buffer, char\* filename)**

This function takes two arguments -- the address of the *buffer* data structure and a string *filename*. It rotates the matrix in *buffer* clockwise by 90 degrees and writes it to *filename*. For example, consider the following matrix with 2 rows and 3 columns:

```
12 3 24
45 6 17
```

Rotating this matrix clockwise by 90 degrees will result in the following matrix with 3 rows and 2 columns:

```
45 12
6 3
17 24
```

This new matrix after rotation should be written to the file *filename* as follows:

```
3
2
45 12
6 3
17 24
```

Notice how the first two lines in the file have no. of rows = 3 and no. of columns = 2 as the rotation switched the original no. of rows and columns.

Assume that buffer points to a valid Buffer struct. Hence, you do not need to validate the buffer's data.

The function returns the no. of characters written to the file in register `$v0` and -1 if there is an error while writing. **You are not allowed to call any of the other rotate functions from this function**. You will get no credit for this part if you do.

### Part 4 -- Rotate Clockwise By 180

**void rotate_clkws_180(Buffer\* buffer, char\* filename)**

This function takes two arguments -- the address of the *buffer* data structure and a string *filename*. It rotates the matrix in *buffer* clockwise by 180 degrees and writes it to *filename*. For example, consider the following matrix with 2 rows and 3 columns:

```
12 3 24
45 6 17
```
Rotating this matrix clockwise by 180 degrees will result in the following matrix with 2 rows and 3 columns:

```
17 6 45
24 3 12
```

This new matrix after rotation should be written to the file *filename* as follows:

```
2
3
17 6 45
24 3 12
```

Notice how the first two lines in the file have the same no. of rows columns the original matrix.

Assume that buffer points to a valid Buffer struct. You do not have to validate the buffer.

The function returns the no. of characters written to the file in register `$v0` and -1 if there is an error while writing. **You are not allowed to call any of the other rotate functions from this function**. You will get no credit for this part if you do.

### Part 5 -- Rotate Clockwise By 270

**void rotate_clkws_270(Buffer\* buffer, char\* filename)**

This function takes two arguments -- the address of the *buffer* data structure and a string *filename*. It rotates the matrix in *buffer* clockwise by 270 degrees and writes it to *filename*. For example, consider the following matrix with 2 rows and 3 columns:

```
12 3 24
45 6 17
```

Rotating this matrix clockwise by 270 degrees will result in the following matrix with 3 rows and 2 columns:

```
24 17
3 6
12 45
```

This new matrix after rotation should be written to the file *filename* as follows:

```
3
2
24 17
3 6
12 45
```

Similar to the 90 degree rotation, the no. of rows and columns will be switched.

Assume that buffer points to a valid Buffer struct. You do not need to validate the buffer.

The function returns the no. of characters written to the file in register `$v0` and -1 if there is an error while writing. **You are not allowed to call any of the other rotate functions from this function**. You will get no credit for this part if you do.


### Part 6 -- Mirroring

**void mirror(Buffer\* buffer, char\* filename)**

This function takes two arguments -- the address of the *buffer* data structure and a string *filename*. It creates a mirror of the matrix in *buffer* writes it to *filename*. For example, consider the following matrix with 2 rows and 3 columns:

```
12 3 24
45 6 17
```
Mirroring the matrix will result in the following matrix with 3 rows and 2 columns:

```
24 3 12
17 6 45
```

This new matrix after mirroring should be written to the file *filename* as follows:

```
2
3
321
654
```

The no. of rows and columns (as indicated by the first two lines) will remain the same in the mirror file.

Assume that buffer points to a valid Buffer struct. You do not need to validate the buffer.

The function returns the no. of characters written to the file in register `$v0` and -1 if there is an error while writing.

### Part 7 -- Duplicates

**(int, int) duplicate(Buffer\* buffer)**

This function takes the data structure *buffer* as an argument. Assume that the matrix in *buffer* contains only binary values 0 and 1. The function checks to see if the matrix has any duplicate rows. If a duplicate row exists in the matrix then the function returns 1 in *$v0* and the index (starting at 1) of the first duplicate row in *$v1*. If the matrix has no duplicate rows then the function returns -1 in *$v0* and 0 in *$v1*

For example, consider the following matrix with 3 rows and 5 columns:

```
1 0 0 1 0
0 1 1 0 0
1 0 0 1 0  
```

The 3rd row in this matrix is a duplicate of the first row. Hence, the function should return 1 in *$v0* and 3 in *$v1*.

Consider another example, where we have the following 6 X 9 matrix:

```
1 0 0 1 0 1 0 1 1
1 0 0 1 0 1 1 1 1
1 0 1 1 1 1 0 1 1
1 1 0 1 0 1 0 1 1
1 0 1 1 1 1 0 1 1
1 0 1 1 1 1 0 1 1
```
The 5th row in this matrix is a duplicate of the third row. Hence, the function should return 1 in *$v0* and 5 in *$v1* as the first duplicate row is row 5.


Assume that buffer points to a valid Buffer struct. You do not need to validate the buffer.

## Submitting Code to GitHub

You can submit code to your GitHub repository as many times as you want till the deadline. After the deadline, any code you try to submit will be rejected. To submit a file to the remote repository, you first need to add it to the local git repository in your system, that is, directory where you cloned the remote repository initially. Use following commands from your terminal:

`$ cd /path/to/cse220-hw3-<username>` (skip if you are already in this directory)

`$ git add hw3.asm`

To submit your work to the remote GitHub repository, you will need to commit the file (with a message) and push the file to the repository. Use the following commands:

`$ git commit -m "<your-custom-message>"`

`$ git push`

**Do not push any output files your code produces**. If you push unwanted files to the repository, use the following commands to clean them from the repository.

`$ git rm --cached <filename>`

`git push`

To see the status of your files, use the command `$ git status`.

**After you submit your code on GitHub. Enter your GitHub username in the Brightspace homework assignment and click on Submit**. This will help us find your submission on GitHub.
