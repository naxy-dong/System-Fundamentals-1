################# Change args and n to test hw1.asm with different inputs #################
.data
#args: .asciiz "D" "1"
#args: .asciiz "D" "0101"
#args: .asciiz "D" "01010101"
#args: .asciiz "D" "11111111111111111111111111111111"

#error cases
#args: .asciiz "O" "x"				#--Err
#args: .asciiz "O" "0a"				#--Err
#args: .asciiz "O" "0x"				#--Err(edge case)
#args: .asciiz "O" "0x111111111111"		#--Err(edge case)
#args: .asciiz "O" "0x30EF9FCG"
#general cases
#args: .asciiz "O" "0x30E9FFFC"		
#args: .asciiz "S" "0x30E9FFFC"
#args: .asciiz "T" "0x30E9FFFC"
#args: .asciiz "E" "0x30E9FFFC"
#args: .asciiz "H" "0x30E9FFFC"
#args: .asciiz "U" "0x30E9FFFC"

#special case section
#args: .asciiz "F" "00000000"
#args: .asciiz "F" "80000000"
#args: .asciiz "F" "FF800000"
#args: .asciiz "F" "7F800000"
#NAN section
#args: .asciiz "F" "7f800001"
#args: .asciiz "F" "7f899999"		#somewhere in between
#args: .asciiz "F" "7FFFFFFF"
#args: .asciiz "F" "ff800001"
#args: .asciiz "F" "FFFFFFFE"		#somewhere in between
#args: .asciiz "F" "FFFFFFFF"
#general test cases
#args: .asciiz "F" "F4483B47"
#args: .asciiz "F" "42864000"

#Error cases
#args: .asciiz "L" "M6M4P3P2M4M5P5"
#args: .asciiz "L" "M4P3P2M4M5"
#args: .asciiz "L" "M6S4P3P2M4M5"
#args: .asciiz "L" "M6M9P3P2M4M5"
#args: .asciiz "L" "M6M1P3P2M4M5"
#args: .asciiz "L" "M6M5P5P2M4M5"
#General cases
#args: .asciiz "L" "M6M4P3P2M4M5"

		#weird, this code runs correctly in mars but it's wrong on the test
args: .asciiz "S" "0xff18ab"			
n: .word 2

.text
main:
 lw $a0, n
 la $a1, args
 j hw_main

.include "hw1.asm"
