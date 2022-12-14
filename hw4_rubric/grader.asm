##############################################################
##### Add the following functions to the beginning of hw4.asm ######
##############################################################

.data

p1: .asciiz "Zoe"
p2: .asciiz "Joe"
p3: .asciiz "Roe"
p4: .asciiz "Woe"
p5: .asciiz "Loe"
I: .word 4
J: .word 8

##############################################################
##### Add the following functions to the end of hw4.asm ######
##############################################################

.globl grader_122022_add_person
grader_122022_add_person:
  addi $sp, $sp, -16
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  add $s0, $a0, $0
  add $s1, $a1, $0
  add $s2, $a2, $0
  add $a0, $s0, $0
  add $a1, $s1, $0
  jal create_network
  add $a0, $v0, $0
  add $a1, $s2, $0
  jal add_person
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  addi $sp, $sp, 16
  jr $ra

.globl grader_122022_add_two_persons
grader_122022_add_two_persons:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  add $s0, $a0, $0
  add $s1, $a1, $0
  add $s2, $a2, $0
  add $s3, $a3, $0
  add $a0, $s0, $0
  add $a1, $s1, $0
  jal create_network
  add $s0, $v0, $0
  add $a0, $s0, $0
  add $a1, $s2, $0
  jal add_person
  add $a0, $s0, $0
  add $a1, $s3, $0
  jal add_person
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

.globl grader_122022_add_max_persons
grader_122022_add_max_persons:
  add $fp, $sp, $0
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  add $s0, $a0, $0
  add $s1, $a1, $0
  add $s2, $a2, $0
  add $a0, $s0, $0
  add $a1, $s1, $0
  jal create_network
  lw $s0, 0($v0)
  sw $s0, 8($v0)
  add $a0, $v0, $0
  add $a1, $s2, $0
  jal add_person
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

.globl grader_122022_get_person
grader_122022_get_person:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  add $s0, $a0, $0
  add $s1, $a1, $0
  add $s2, $a2, $0
  add $s3, $a3, $0
  add $a0, $s0, $0
  add $a1, $s1, $0
  jal create_network
  add $s0, $v0, $0
  add $a0, $s0, $0
  add $a1, $s2, $0
  jal add_person
  add $a0, $s0, $0
  add $a1, $s3, $0
  jal add_person
  add $a0, $s0 ,$0
  add $a1, $s3, $0
  jal get_person
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

.globl grader_122022_get_person_fail
grader_122022_get_person_fail:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  add $s0, $a0, $0
  add $s1, $a1, $0
  add $s2, $a2, $0
  add $s3, $a3, $0
  add $a0, $s0, $0
  add $a1, $s1, $0
  jal create_network
  add $s0, $v0, $0
  add $a0, $s0, $0
  add $a1, $s2, $0
  jal add_person
  add $a0, $s0 ,$0
  add $a1, $s3, $0
  jal get_person
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

.globl grader_122022_add_relation_test
grader_122022_add_relation_test:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  # p1 arg
  add $s0, $a0, $0
  # p2 arg
  add $s1, $a1, $0
  # rel_type arg
  add $s2, $a2, $0
  lw $a0, I
  lw $a1, J
  jal create_network
  add $s3, $v0, $0  # network address in $s3
  add $a0, $s3, $0
  la $a1, p1
  jal add_person
  add $a0, $s3, $0
  la $a1, p2
  jal add_person
  add $a0, $s3, $0
  la $a1, p3
  jal add_person
  add $a0, $s3, $0
  la $a1, p4
  jal add_person
  add $a0, $s3, $0
  add $a1, $s0, $0
  add $a2, $s1, $0
  add $a3, $s2, $0
  jal add_relation
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

.globl grader_122022_add_multi_relation_test
grader_122022_add_multi_relation_test:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  # p1 arg
  add $s0, $a0, $0
  # p2 arg
  add $s1, $a1, $0
  # rel_type arg
  add $s2, $a2, $0
  lw $a0, I
  lw $a1, J
  jal create_network
  add $s3, $v0, $0  # network address in $s3
  add $a0, $s3, $0
  la $a1, p1
  jal add_person
  add $a0, $s3, $0
  la $a1, p2
  jal add_person
  add $a0, $s3, $0
  la $a1, p3
  jal add_person
  add $a0, $s3, $0
  la $a1, p4
  jal add_person
  add $a0, $s3, $0
  la $a1, p1
  la $a2, p3
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  la $a1, p1
  la $a2, p4
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  la $a1, p4
  la $a2, p2
  addi $a3, $0, 2
  jal add_relation
  add $a0, $s3, $0
  add $a1, $s0, $0
  add $a2, $s1, $0
  add $a3, $s2, $0
  jal add_relation
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

.globl grader_122022_add_max_relation_test
grader_122022_add_max_relation_test:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  # p1 arg
  add $s0, $a0, $0
  # p2 arg
  add $s1, $a1, $0
  # rel_type arg
  add $s2, $a2, $0
  add $a0, $0, 3
  add $a1, $0, 2
  jal create_network
  add $s3, $v0, $0  # network address in $s3
  add $a0, $s3, $0
  la $a1, p1
  jal add_person
  add $a0, $s3, $0
  la $a1, p2
  jal add_person
  add $a0, $s3, $0
  la $a1, p3
  jal add_person
  add $a0, $s3, $0
  la $a1, p1
  la $a2, p2
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  la $a1, p2
  la $a2, p3
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  add $a1, $s0, $0
  add $a2, $s1, $0
  add $a3, $s2, $0
  jal add_relation
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

.globl grader_122022_distant_friend_test
grader_122022_distant_friend_test:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  # distant_friend arg
  add $s0, $a0, $0
  lw $a0, I
  lw $a1, J
  jal create_network
  add $s3, $v0, $0  # network address in $s3
  add $a0, $s3, $0
  la $a1, p1
  jal add_person
  add $a0, $s3, $0
  la $a1, p2
  jal add_person
  add $a0, $s3, $0
  la $a1, p3
  jal add_person
  add $a0, $s3, $0
  la $a1, p4
  jal add_person
  add $a0, $s3, $0
  la $a1, p1
  la $a2, p3
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  la $a1, p1
  la $a2, p4
  addi $a3, $0, 2
  jal add_relation
  add $a0, $s3, $0
  la $a1, p4
  la $a2, p2
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  la $a1, p1
  la $a2, p2
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  la $a1, p1
  la $a2, p3
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  la $a1, p2
  la $a2, p3
  addi $a3, $0, 1
  jal add_relation
  add $a0, $s3, $0
  add $a1, $s0, $0
  jal get_distant_friends
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra
