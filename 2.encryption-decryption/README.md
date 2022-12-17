# Homework 2

## Learning Outcomes

After completion of this assignment, you should be able to:

- manage the main memory stack.

- define and call functions in MIPS.

- work with one-dimensional arrays in MIPS.

## Getting Started

Before you begin the assignment read the *Guide to writing functions in  MIPS assembly* posted in *Brightspace* under *Readings*. Also, review the register conventions discussed in class. If you violate register conventions, you will be heavily penalized.

To complete this homework assignment, you will need the MARS simulator. Download it from Brightspace under *Software*. You can write your programs in the MARS editor itself. You can choose to use other text editors if you are not comfortable with the MARS editor. At any point, if you need to refer to instructions click on the *Help* tab in the MARS simulator.

Read the rest of the document carefully. This document describes everything that you will need to correctly implement the homework and submit the code for testing.

You should have already setup Git and configured it to work with SSH. If you haven't then do Homework 0 first!

The first thing you need to do is download or clone this repository to your local system. Use the following command:

`$ git clone <ssh-link>`

After you clone, you will see a directory of the form *cse220-hw2-\<username\>*, where *username* is your GitHub username.

In this directory, you will find two asm files: *hw2.asm* and *hw2_test.asm*. The file *hw2.asm* is where you will write your code. At the top of the file you will find hints to fill your full name, NetID, and SBU ID. Please fill them up accurately. This information will be used to collect your scores from GitHub. If you do not provide this information, your submission will not be graded. The *hw2_test.asm* file is a template that has been provided for preliminary testing. You can change this file to test different cases for each part (described later). You must run *hw2_test.asm* to run *hw2.asm*. The *tests* directory contains the test cases for this homework. You can use the test cases as specifications to guide your code. Your goal should be to pass all the tests. If you do so, then you are almost guaranteed to get full credit. None of the files in the *tests* directory should be modified. If you do, you will receive no credit for the homework.

## Assembling and Running Your Program in MARS

To execute your MIPS programs in MARS, you will first have to assemble the program. Click on the *assemble* option in the *Run* tab at the top of the editor. If the instructions in your program are correctly specified, the MARS assembler will load the program into memory. You can then run the program by selecting the *Go* option in the same *Run* tab. To debug your program, add breakpoints. This is done after assembling the program. Select the *execute* tab, you will see the instructions in your program. Each instruction will have a checkbox associated with it. Clicking on the checkbox will add a breakpoint, that is, when the program is run, control will stop at that instruction allowing you to inspect the registers and memory up to that point. The execute tab will show you the memory layout in the bottom pane. The right hand pane shows list of registers and their values.

**Note in order to run hw2.asm, you will have to assemble and run hw2_test.asm**. You should change **hw2_test.asm** to test for different cases for the functions you define in *hw2.asm*.

## How to read the test cases

As mentioned previously, the *tests* folder contains a test file, which contains tests to verify a specific feature. Each test is a Java function with a name prefixed with *verify_*. In each of these functions, you will find one or more assert statements that need to be true for the test to pass. These asserts compare the expected result with the result returned from the respective functions in registers *$v0* or/and *$v1*. The tests assume that the expected results will be in these registers as specified in the later parts of this readme. In each test, we will execute your program by calling the *run* function along with the necessary arguments required to test that particular feature. If a test fails, the name of the failing test will be reported with an error message. You can use the error message from the failing test to diagnose and fix your errors. Another way is to look at the inputs of the failed test case and plug them into appropriate labels in *hw2_test.asm* and run *hw2_test.asm* to debug your program.

*Do not change any files in the tests directory. If you do then you won't receive any credit for this homework assignment*.

## Problem Specification

The RSA algorithm is an encryption algorithm used to generate a pair of public and private keys, which are further used for secure communication (e.g., HTTPS). A communication channel is secure when all parties using the channel have proven their identity to each other.

Here is how it works informally. Suppose Alice and Bob want to communicate securely. Alice uses the RSA algorithm to generate a public-private key and broadcasts the public key to the world. Alice keeps the private key a secret and stores it securely in some place. If Bob wants to communicate with Alice, Bob gets hold of Alice's public key (publicly available), encrypts a secret message with the public key, sends it to Alice, and challenges Alice to decrypt it. If Alice has the corresponding private key, which she has, she will successfully decrypt Bob's secret, thereby proving to Bob that she is indeed Alice. However, if someone other than Alice claims to be her, then she won't have Alice's secret private key, which will prevent the fake Alice from decrypting Bob's message, thereby failing Bob's challenge. This will prove to Bob that Alice is fake and further communication with fake Alice is aborted.

The steps in the RSA algorithm are as follows:

1. Choose two distinct prime numbers `p` and `q` and compute `n = p * q`.
2. Compute `K = lcm(p-1, q-1)`.
3. Choose a random integer `1 < e < K` such that `e` and `K` are *co-prime*, i.e, `gcd(e, K) = 1`. `K` must be kept secret and `e` is released publicly as the public key.
4.  Compute the private key `d`, where `d` is the [modular multiplicative inverse](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse) of `e modulo K`. An efficient way to calculate `d` is to use the [Extended Euclidean algorithm](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm). The private key must be kept a secret.
5. A message `m` is encrypted to a ciphertext `c` using the formula `c = m^e (mod n)`. The numbers `m`, `e` and `n` can get very large and can end up occupying vast amounts of memory. Hence, a memory-efficient way to generate the ciphertext is to use the [Modular Exponentiation algorithm](https://en.wikipedia.org/wiki/Modular_exponentiation).
6. Given a ciphertext `c`, the original message, `m`, can be extracted using the private key, `d`, with the formula `m = c^d (mod n)`.

Here is an example of the RSA algorithm in action:

1. Choose `p = 61` and `q = 53`. Hence, `n = 61 * 53 = 3233`.
2. `K = lcm(60, 52) = 780`.
3. Suppose `e = 17` as `1 < e < K` and `e` and `K` are co-prime.
4. `d = 413`, the modulo multiplicative inverse of `17 (mod 780)`.
5. Suppose m = 65, then
    1. ciphertext, `c = 65^17 (mod 3233) = 2790`.
    2. on decryption, `m = 2790^413 (mod 3233) = 65`. Note how we get the original m back on decryption.

*Aside: The RSA algorithm is relatively slow. Hence, instead of directly encrypting data with it, it is used by involved parties to exchange a shared secret key, which is used for further encryption and decryption.*

In this homework, we will Write a MIPS program to implement the RSA encryption algorithm. To this end, we will build the algorithm step-by-step by implementing the functions described below. You can define additional functions if necessary. You are also allowed to call functions from other functions. In fact, this is advisable for code reuse.

### Part 1: Hash a Message

Define a function *hash* that takes the address of a string as input in register `$a0` and returns a hash of the string in register `$v0`. The hash of the string is an integer calculated as the sum of the ascii values of the characters in the string.

### Part 2: Detect Primes

Define a function *isPrime* that takes an integer as input in register `$a0` and returns 1 in register `$v0` if the input is a prime number, otherwise, it returns 0 in register `$v0`.

### Part 3: Calculate Least Common Multiple (LCM)

Define a function *lcm* that takes two input arguments in register `$a0` and `$a1` and returns the LCM of the inputs in register `$v0`. Assume that the inputs are positive integers.

### Part 4: Calculate Greatest Common Divisor (GCD)

Define a function *gcd* that takes two input arguments in register `$a0` and `$a1` and returns the GCD of the inputs in register `$v0`. Assume that the inputs are positive integers.

### Part 5: Compute Public Key Exponent

Define a function *pubkExp* that takes an integer `z` as argument in register `$a0` and returns a random number `r` such that `1 < r < z`. Further, `z` and `r` are co-prime, that is, the `gcd(z,r) = 1`. To generate a random number in MIPS, use the `syscall 42`. See `MARS Help` for usage information.

In the context of RSA, the argument `z = K = lcm(p-1, q-1)`, where `p` and `q` are distinct prime numbers.

## Part 6: Compute Private Key Exponent

Define a function *prikExp* that takes two integers, `x` and `y`, as input arguments in registers `$a0` and `$a1`. Assume `x < y`. The function returns an integer `z` in register `$v0`, where `z` is the multiplicative modulo inverse of `x mod y`. In other words, dividing `x*z` by `y` will yield a remainder of 1.

In the context of RSA, `x` is the public key and `y = K = lcm(p-1, q-1)`, where `K` is used to generate the public key. Due to the requirements of the RSA algorithm, `x` and `y` tend to be large integers, which makes calculating `z` via brute force extremely inefficient in terms of runtime and memory. An efficient way to compute the multiplicative modulo inverse is the Extended Euclidean Algorithm. As per this algorithm, to calculate the inverse of `x mod y`, we start with dividing `y by x` continue till we reach a step with 0 remainder same as the Euclidean algorithm for computing the GCD. At each step of the division, `i`, we get a quotient, q<sub>i</sub>. We will use the quotient to calculate an auxiliary value at each step, p<sub>i</sub> = (p<sub>i-2</sub> - p<sub>i-1</sub> \* q<sub>i-2</sub>) (mod y). For the first two steps, p<sub>0</sub> = 0 and p<sub>1</sub> = 1. The p<sub>i</sub> values are calculated till one step beyond the last step of the Euclidean algorithm, i.e, where the remainder is 0.

For example, here are the steps of the algorithm to calculate the inverse of `15 mod 26`:

- Step 0: 26 = 1\*15 + 11 | p<sub>0</sub> = 0

- Step 1: 15 = 1\*11 + 4 | p<sub>0</sub> = 1

- Step 2: 11 = 2\*4 + 3	| p<sub>2</sub> = (0 - 1\*1) (mod 26) = -1 mod 26 = 25

- Step 3: 4 = 1\*3 + 1 | p<sub>3</sub> = (1 - 25\*1) (mod 26) = -24 mod 26 = 2

- Step 4: 3 = 3\*1 + 0 | p<sub>4</sub> = (25 - 2\*2) (mod 26) = 21 mod 26 = 21

- Step 5: -- | p<sub>5</sub> = (2 - 21\*1) (mod 26) = -19 mod 26 = 7

Note the multiplicative modulo inverse of `15 mod 26 = 7` since `(15*7) mod 26 = 1`.

Using steps in the Extended Euclidean Algorithm allows us to manage large numbers in a memory-efficient manner.

Since the multiplicative modulo inverse of two integers `x` and `y` exists only if the `x` and `y` are co-prime, the function `priExp` should return -1 in `$v0` when the input arguments are not co-prime.

## Part 7: Encrypt Message

Define a function *encrypt* that takes as input a hashed message `m`, two prime numbers, `p` and `q`, in registers `$a0`, `$a1`, and `$a2`, respectively. It returns the encrypted message, which is really the integer `c = m^e (mod n)`, in register `$v0` and the public key `e` in the register `$v1`. Note `n = p * q`. For the encryption to be accurate, `n > m`.

## Part 8: Decrypt Message

Define a function *decrypt* that takes as input an encrypted message `c`, the public key, and two prime numbers, `p` and `q`, in registers `$a0`, `$a1`, `$a2`, and `$a3`, respectively. It returns the decrypted message, which is really the hash of the original message `m = c^d (mod n)`, in register `$v0`. Note `d` is the private key derived from the public key and `n = p * q`.

Note that both the encrypt and the decrypt functions use exponentiation to compute the result. However, since exponent of large numbers leads to very large numbers, we need a memory efficient way to manage the exponentiation, otherwise we will run out of memory, which may lead to overflow. An efficient way to compute exponentiation is the modular exponentiation algorithm. In this algorithm, we exploit the identity `(a*b) mod m = [(a mod m)*(b mod m)] mod m`. Based on this idea, we can compute `u^v (mod w)` by calculating `(u'*u) mod w` `v-1` times, where `u' = u mod w` initially.

## Submitting Code to GitHub

You can submit code to your GitHub repository as many times as you want till the deadline. After the deadline, any code you submit will be rejected. To submit a file to the remote repository, you first need to add it to the local git repository in your system, that is, directory where you cloned the remote repository initially. Use following commands from your terminal:

`$ cd /path/to/cse220-hw2-<username>` (skip if you are already in this directory)

`$ git add hw2.asm`

To submit your work to the remote GitHub repository, you will need to commit the file (with a message) and push the file to the repository. Use the following commands:

`$ git commit -m "<your-custom-message>"`

`$ git push`

You can check which files in your repository have beens modified using the command `$ git status`.

Every time you push code to the GitHub remote repository, the test cases in the *tests* folder will run and you will see either a green tick or a red cross in your repository just like you saw with homework0. Green tick indicates all tests passed. Red cross indicates some tests failed. Click on the red cross and open up the report to view which tests failed. Diagnose and fix the failed tests and push to the remote repository again. Repeat till all tests pass or you run out of time!

**Do not forget to add your GitHub username as comments in Brightspace Assignment 2**

## Running Test Cases Locally

It may be convenient to run the test cases locally before pushing to the remote repository. To run a test locally use the following command:

`$ java -jar munit.jar tests/<test-file>.class hw2.asm`

Remember to set java in your classpath. Your test cases may fail if you do not have the right setup. If you do not have the right setup it is most likely because you did not do homework 0 correctly. So, do homework 0 first and then come back here!
