# Homework 4

## Learning Outcomes

After completion of this assignment, you should be able to:

- Create and manipulate data structure.

- Write Functions and manage the call stack.

- Dynamically allocate memory.

## Getting Started

To complete this homework assignment, you will need the MARS simulator. Download it from Brightspace. You can write your programs in the MARS editor itself. You can choose to use other text editors if you are not comfortable with the MARS editor. At any point, if you need to refer to instructions click on the *Help* tab in the MARS simulator.

Read the rest of the document carefully. This document describes everything that you will need to correctly implement the homework and submit the code for testing.

You should have already setup Git and configured it to work with SSH. If you haven't then do Homework 0 first!

The first thing you need to do is download or clone this repository to your local system. Use the following command:

`$ git clone <ssh-link>`

After you clone, you will see a directory of the form *cse220-hw4-<username>*, where *username* is your GitHub username.

In this directory, you will find *hw4.asm*. This file has function stubs that you will need to fill up. You can define your own helper functions if required as well. The directory also has a template test file ending with *hw4_test.asm*. Use the file for writing your test cases. You can change the data section or the text section in this file to test different cases for each part (described later). You may also create your own *_test.asm* files if necessary. Don't push these additional *_test.asm* files to the repository.

**Note the hw4.asm file doesn't have a .data section. Do not add a .data section.**

**Remember to submit your username to Brightspace. You will be penalized if you do not follow the instructions.**

## Assembling and Running Your Program in MARS

To execute your MIPS programs in MARS, you will first have to assemble the program. Click on the *assemble* option in the *Run* tab at the top of the editor. If the instructions in your program are correctly specified, the MARS assembler will load the program into memory. You can then run the program by selecting the *Go* option in the same *Run* tab. To debug your program, add breakpoints. This is done after assembling the program. Select the *execute* tab, you will see the instructions in your program. Each instruction will have a checkbox associated with it. Clicking on the checkbox will add a breakpoint, that is, when the program is run, control will stop at that instruction allowing you to inspect the registers and memory up to that point. The execute tab will show you the memory layout in the bottom pane. The right hand pane shows the list of registers and their values.

Always assume that memory and registers will have garbage data. When using memory or registers, it is your responsibility to initialize it correctly before using it. You can enable the *Garbage Data* option under *Settings* in MARS to run your programs with garbage data in memory.

## Test Cases

In this homework assignment, you will not be provided with executable test cases. It is your job to come up with test cases to verify the correctness of your implementation. Use the *hw4_test.asm* file to write your own tests. You can take inspiration from hw1 and hw2 to get an idea of how to write comprehensive test cases.

**Make sure that your implementation follows register conventions. You will lose points if register convention violations are found.**

## Dynamic Memory Allocation

In this homework assignment, we will need to allocate memory in the heap. To store data in the system heap, MARS provides system call 9, called *sbrk*. For example, to allocate N bytes of memory, where N is a positive integer literal, we would write the following:

```
li $a0, N
li $v0, 9
syscall
```

When the system call completes, the address of the newly-allocated memory buffer will be available in `$v0`. The address will be on a word-aligned boundary, regardless of the value passed through $a0. Unfortunately, there is no way in MARS to automatically de-allocate memory to avoid creating memory leaks. The run-time systems of Java, Python and some other languages take care of freeing unneeded memory blocks with garbage collection, but assembly languages, C/C++, and other languages put the responsibility on the programmer to manage memory. You will learn more about this in CSE 320.

## Problem Specification

In this assignment, we will learn how to build and manipulate custom data structures using MIPS.

Mark Jobs has a brilliant idea to create a network of people in which nodes represent people and edges between nodes represent relationships between people. Mark’s goal, through this network, is to capture various properties about people and their relationships. Further, he wants to be able to query the network
- for persons using their names and
- for persons related to each other as friends.

We need to help Mark build and manage such a network. To this end, we will construct and maintain a graph-based data structure called Network.

### The Network Data Structure

The Network data structure uses two other structures called Node and Edge. We first define the structure of Node and Edge. Since MIPS does not natively understand a structure, we will use C-like syntax to describe the necessary structures.

The Node data structure represents a person with a name and is defined as follows:

```
struct Node {
   int K            // non-negative integer K
   char* name[K]   // null-terminated string of K characters
}
```

Note, *char\** is the same as an array of characters (also called a string) in C.

The Edge data structure represents a relationship between two people. It is defined as follows:

```
struct Edge {
  Node* p1	     // address of a node p1
  Node* p2	    // address of a node p2
  int relation	// non-negative integer to indicate type of relationship
}
```

Notice that *Edge* does not contain the actual person nodes in a relationship, but a reference to (or address of) the nodes that are related. Relationships are bidirectional, i.e., if *p1* is related to *p2* then *p2* is also related to *p1*. The relation attribute/property is 1 if the relationship is a friendship. It is 2 if the relationship is an acquaintance. It is 3 if the relationship is family. It is 0, if the relationship type is unknown.

Further, the nodes and the edges connecting the nodes are captured in a graph-like structure called *Network* defined as follows:

```
struct Network {
  int N            // Total no. of nodes possible in the network.
  int E            // Total no. of edges possible in the network.
  int X            // no. of nodes currently in the network.
  int Y            // no. of edges currently in the network.
  Node* nodes[N]   // An array of node addresses.
  Edge* edges[E]   // An array of edge address.
}
```

We will use these data structures to define operations/functions that will help us implement the social network envisioned by Mark Jobs. Your task in this assignment will be to implement each of the defined functions.


### Part 1: Create a Network

**Network\* create\_network(int I, int J)**

The function *create_network* takes two integers, *I* and *J*, as arguments in registers *$a0* and *$a1*. *I* is the total no. of nodes possible in the network and *J* is the max no. of edges in the network. Both *I* and *J* must be non-negative numbers. Otherwise, the function returns -1 in register *$v0*. If *I* and *J* are non-negative, the function instantiates the network structure in the heap and returns the address of the network in register *$v0*. The initial value of *X* and *Y* is 0 in the initial instantiation of the network. Further, the *nodes* and *edges* arrays should also be initialized with 0.

For e.g., if *create_network(5, 10)* then a block of 76 bytes should be allocated in the heap as the network will have 5 nodes and 10 edges. This is how the structure will look like in the heap:

```
5   (0 - 3 offset)
10  (4 - 7 offset)
0   (8 - 11 offset)
0   (12 - 15 offset)
0 0 0 0 ... (16 - 35 offset)
0 0 0 0 ... (36 - 76 offset)
```

### Part 2: Add a Person

**Node\* add\_person(Network\* ntwrk, char\* name)**

The function *add_person* takes the address of a *Network* structure, *ntwrk*, in register *a0* creates a person node with the null-terminated string *name* in register *a1* (note char\* is C-syntax for string), adds it to the network, and returns the network's address in register *v0* and 1 in register *v1*.

Creating a person involves instantiating a *Node* structure in the heap, incrementing the current no. of nodes in the network by 1, and storing the *Node*'s heap reference in the *nodes* array in the network.

The function returns -1 in registers *v0* and *v1* without changing anything in the memory (including the heap) in the following cases:

- If the Network is at capacity.
- If an empty string is passed as the name of a person.
- If a person with the same name exists in the network.

For example, suppose we call *add_person(ntwrk_addr, 'Sam')*. This will first create a person node in the heap as follows:

```
node_1:
3
'Sam\0'
```

and then add the node to the network. The network in the heap will look as follows:

```
5   (0 - 3 offset)
10  (4 - 7 offset)
1   (8 - 11 offset)
0   (12 - 15 offset)
addr_of_node_1 0 0 0 ... (16 - 35 offset)
0 0 0 0 ... (36 - 76 offset)
```

Suppose we call *add_person(ntwrk_addr, 'Sam')* again. This will lead to the function returning -1 in register *v0* as 'Sam' already exists in the network. All parts of the memory remain unchanged.

### Part 3: Query Network

**Node\* get\_person(Network\* network, char\* name)**

The function *get_person* takes two arguments -- a reference to Network in *$a0* and a string name in *$a1*. The string name is null-terminated. The function should return a reference to the person node in Network that has its name set to the input argument *name* in register *v0* and 1 in register *v1*. If no such person is found, then the function should return -1 in register *v0* and register *v1*.

### Part 4: Add Relationship

**Network\* add\_relation(Network\* ntwrk, char\* name2, char\* name2, int relation_type)**

The function *add_relation* takes a reference to Network in *$a0*, two null-terminated strings, *name1* and *name2*, in *$a1* and *$a2*, and an integer in *$a3*. If *name1* and *name2* exist in the Network, then an edge between person1, with *name1*, and person2, with name *name2*, and the appropriate relation type should be created in the heap based on the *Edge* structure defined previously. A reference to this edge should be added to the *edges* array in network. The function should return the network address in register *v0* and 1 in register *v1* if the relation was added successfully to the network.

The function fails to add the relation if:

1. If no person with *name1* exists in the network, or
2. If no person with *name2* exists in the network, or
3. The network is at capacity, that is, it already contains the maximum no. of edges possible, or
4. A relation between a person with *name1* and a person with *name2*, or vice-versa already exists in the network. Relations must be unique, or
5. *name1* == *name2*. A person cannot be related to themselves.
6. If *0 > relation_type > 3*

The function must return -1 in registers *v0* and *v1* if the relation could not be added to the network.


### Part 5: Distant friends

**FriendNode\* get\_distant\_friends(Network\* ntwrk, char\* name)**

A person *p1* is a distant relation of *p2* if *p1* and *p2* are not immediate friends, that is, there is no edge between *p1* and *p2* but there is a path in the network connecting *p1* and *p2* and the path has more than one edge. For example, consider a network of 6 persons *p1, p2, p3, p4, p5, p6*. Suppose the friendships in the network are captured as follows:

```
    p1   p6
    /\  /
  p2  p3
  /    \
p5      p4

```
In this network, *p1* is distant friends with *p4, p5*, and *p6* as there is a path with more than one edge from *p1* to *p4,p5*, and *p6*. However, *p1* is not distant friends with *p2* and *p3* as there is at most one edge between *p1,p2* and *p1,p3*.  

Note two people in the network can be related to each other but may not be friends. For instance, in the network above, suppose *p1* and *p3* are siblings instead of friends then *p1* and *p4* are not distant friends even if there is a path connecting *p1* and *p4* via *p3*.

Assume the network passed as argument to the function is a connected graph.

The function *get_distant_friends* takes a reference to the network in *$a0* and a null-terminated string indicating person name in *$a1*. It returns a linked list of friend nodes in register *v0*, where each node is a distant friend of a person with *name*. It returns -1 in *v0* if the person with *name* has no distant friends. It returns -2 in *v0* if the person with *name* does not exist in the network.

A linked list is a linear collection of elements where each element points to the address of the next element in memory. To create a linked list of distant friend nodes, use the following structure.

```
struct FriendNode {
  char* name
  FriendNode* friendnode
}
```

Create a linked-list structure with FriendNodes in the heap and return a reference to the head of the linked list, i.e., the first element.

The first attribute in *FriendNode* is the name of the person who is a distant friend. The second attribute is a reference to (or address of) the next distant friend node. In the example network shown above, suppose the name of person node *p1* is passed as argument to *get_distant_friends* along with the network address. In this case, the function should return a linked list of friend nodes in *$v0* such that *$v0* has a reference to a FriendNode *fnode1*, which has the name for *p4* and a reference to a FriendNode *fnode2*. The FriendNode *fnode2* has the name of *p5* and a reference to *fnode3*. FriendNode *fnode3* has the name of *p6* and null as the reference to the next element. The null element indicates the end of the linked list. The elements in the linked list do not have to be linked in the same order as specified in the current example. For instance, the linked list returned could also be linked as *p5 -> p4 -> p6*.

## Submitting Code to GitHub

You can submit code to your GitHub repository as many times as you want till the deadline. After the deadline, any code you try to submit will be rejected. To submit a file to the remote repository, you first need to add it to the local git repository in your system, that is, directory where you cloned the remote repository initially. Use following commands from your terminal:

`$ cd /path/to/cse220-hw4-<username>` (skip if you are already in this directory)

`$ git add hw4.asm`

To submit your work to the remote GitHub repository, you will need to commit the file (with a message) and push the file to the repository. Use the following commands:

`$ git commit -m "<your-custom-message>"`

`$ git push`

**After you submit your code on GitHub. Enter your GitHub username in the Brightspace homework assignment and click on Submit**. This will help us find your submission on GitHub.
