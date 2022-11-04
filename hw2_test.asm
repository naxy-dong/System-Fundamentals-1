.data
str: .asciiz "Seawolves let's go!"

.text
main:
#################################TESTING SECTION############################################
 #li $a0 96
 #li $a1 108
 #li $a1 111
 #li $a0 2
 #li $v1 3
 #li $s0 5
 ##################################################
#li $a0,12
#jal pubkExp
#add $a0,$v0,$0  #a0 = v0
#li $v0 1
#syscall
 ###########################################################################################
 la $a0,str
 jal hash
 add $a0,$v0,$0  #a0 = v0
 #li $a1,107
 #li $a2,157
 li $a1,5
 li $a2,7
 jal encrypt
 add $a0,$v0,$0
 add $a1,$v1,$0
 #li $a2,107
 #li $a3,157
 li $v0,1
 syscall
 
 li $a2,5
 li $a3,7
 jal decrypt
 add $a0,$v0,$0
 li $v0,1
 syscall
 li $v0, 10
 syscall

.include "hw2.asm"
