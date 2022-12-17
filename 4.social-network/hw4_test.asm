############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
############################ Add more names if needed ####################################

.data

Name1: .asciiz "Jane"
Name2: .asciiz "Joey"
Name3: .asciiz "Alit"
Name4: .asciiz "Veen"
Name5: .asciiz "Stan"
Name6: .asciiz "Naxy"
Name7: .asciiz "Ryan"	

Name8: .asciiz "r"		#cant have empty names
NameX: .asciiz "Joey"		# a network should not have dup names

I: .word 10
J: .word 10

.text
main:
    lw $a0, I
    lw $a1, J
    jal create_network
    add $s0, $v0, $0		# network address in heap

    add $a0, $0, $s0		# pass network address to add_person
    la $a1, Name1
    jal add_person
    
    move $a0, $v0		# pass network address to add_person
    la $a1, Name2
    jal add_person
    
    move $a0, $v0		# pass network address to add_person
    la $a1, Name3
    jal add_person
    
    move $a0 $v0
    la $a1 Name1
    la $a2 Name2
    li $a3 0
    jal add_relation
    
    move $a0 $v0
    la $a1 Name1
    la $a2 Name3
    li $a3 1
    jal add_relation
    
    move $a0 $v0
    la $a1 Name2
    la $a2 Name3
    li $a3 1
    jal add_relation
    
    move $a0 $v0
    la $a1 Name3
    jal get_distant_friends
exit:
    li $v0, 10
    syscall
.include "hw4.asm"
