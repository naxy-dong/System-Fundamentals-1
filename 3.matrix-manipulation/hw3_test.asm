# This is a test file. Use this file to run the functions in hw3.asm
#
# Change data section as you deem fit.
# Change filepath if necessary.
.data
Filename: .asciiz "inputs/input9.txt"
OutFile: .asciiz "out.txt"
Buffer:
    .word 0	# num rows
    .word 0	# num columns
    # matrix
    .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0


.text
main:
 la $a0, Filename
 la $a1, Buffer

 jal initialize
 move $a0 $v0
 li $v0 1
 syscall
 
 la $a0 OutFile
 la $a1, Buffer

 #jal write_file
 jal rotate_clkws_90
 #jal rotate_clkws_180
 #jal rotate_clkws_270
 #jal mirror
 #jal duplicate

 move $a0 $v0
 li $v0 1
 syscall
 
 li $v0, 10
 syscall


.include "hw3.asm"
