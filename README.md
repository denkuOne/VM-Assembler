# Assembler-and-VM
Assembler and Virtual Machine for a fictitious hardware. Assembly code is passed to the VM which is assembled and ran on simulated hardware. This code was written for a school project and is not necessarily useful for anything but educational purposes.

# About the Code
vm.cpp contains the code which emulates a processor at a high abstraction. It follows the 5-stage architecture fetch, decode, execute, memory and write back but is not pipe lined. The code consists of a large while loop that executes all 5 of the stages mentioned above before the next instruction is fed into the CPU. A large switch statement is used to define the behavior of every single available instruction in my fictional assembly language. The vm also supports simple multi-threading by breaking up memory between a total of 5 possible threads and context switching between every single active thread per instruction.
assembler.cpp contains the code which reads user created assembly code and assembles it into a machine code. The machine code is passed to the vm through a struct that contains some data regarding the assembled file and a large array of memory with the machine code loaded inside. The assembler conducts robust error checking throughout the assembly process to warn the user regarding unrecognizable assembly code syntax.   

# How to Use
Download the files and build the vm.cpp file with a C++ compiler. assembler.cpp is a library used by vm.cpp.

# Project 1
This assembly program demonstrates working arithmetic, and IO commands. It also demonstrates how to put and load variables from memory.

# Project 2
This assembly program demonstrates working with arrays using register based addressing

# Project 3
This assembly program is a manually compiled implementation of the example.c program and implements function calls using the run-time stack.

# Project 4
Demonstrates recursion by implementing a Fibonacci sequence calculator
It also demonstrates multi-threading by running up to five Fibonacci calculations simultaneously.
