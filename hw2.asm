########### YuXiang Dong ############
########### CONFIDENTIAL ################
########### CONFIDENTIAL ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl hash
hash:
  #might have to restore variables
  move $t0 $a0  #Create a copy of $a0
  li $v0 0      #Initialize result as 0
  
  #for loop adding each ascii value char until it encounters null terminator
  for:
    lbu $s0 0($t0)
    add $v0, $v0, $s0
    addi $t0, $t0, 1
    bnez $s0 for
  jr $ra

.globl isPrime
isPrime:
  #for loop that checks if a0 is prime?? loop from 2 to n-1
  #, if t0 is divisible by any of the numbers, then it's not prime
  addi $sp $sp -8
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  move $t0, $a0
  li $v0 1 # let's say that it's prime at first
  li $s0 2 # starts at 2
  #edge case: 2 is prime
  beq $t0 $s0 exitPrime
  for1:
    div $t0 $s0
    mfhi $s1
    beqz $s1 notPrime
    addi $s0, $s0, 1
    bne $s0, $t0, for1
    #div what's the hi and lo????

  lw $s0, 0($sp)
  lw $s1, 4($sp)
  addi $sp $sp 8
  jr $ra
  
notPrime:
  li $v0 0
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  addi $sp $sp 8
  jr $ra

exitPrime:
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  addi $sp $sp 8
  jr $ra
  
.globl lcm
lcm:
  # give a0 and a1, return the lcm of the two
  # lcm(a, b) = |a * b|/gcd(a, b).
  mul $t0 $a0 $a1	#a*b
  
  addi $sp $sp -4
  sw $ra 0($sp)
  jal gcd		#our gcd is stored in v0
  lw $ra 0($sp)
  addi $sp $sp 4
  
  div $t0 $v0
  mflo $v0
  jr $ra

#gcd will take in $a1 and $a0
#gcd will return the gcd in $v0
.globl gcd
gcd:
  move $t6 $a1 	# divisor
  move $t7 $a0 	# dividend
  li $t8 -1	# remainder
  li $t9 -1 	# previousRemainder
  
  while4:
  	div $t6 $t7
  	move $t9 $t8	# previousRemainder = remainder;
  	mfhi $t8		# remainder = divisor % dividend;
  	move $t6 $t7	# divisor = dividend;
  	move $t7 $t8	# dividend = remainder;
  	
  	bnez $t8 while4	#while (remainder != 0)
  
  move $v0 $t9 #store our return type to v0
  jr $ra
  
.globl pubkExp
pubkExp:
  #$a0 = i.d. of pseudorandom number generator (any int). 
  #$a1 = upper bound of range of returned values.
  #the random number would be within [0, a1).
  #GOAL: the random number would be within (1, z) 1 excluded and z excluded
  #result $a0 holds the random number that's coprime with a1
  #move $fp $sp
  addi $sp $sp -4
  sw $ra, 0($sp)
  move $a1 $a0
  
  while1:	              
  addi $a1 $a1 -2           # [0, upperbound -2)
  li $v0 42
  syscall #this generates a random number and stores it in $a0
  
  addi $a0 $a0 2            # (1, upperbound)
  addi $a1 $a1 2          

  jal gcd #takes in a0 and a1 and return GCD v0 
  li $t1 1
  bne $t1 $v0 while1
  
  #li $v0 1                  #prints out the coprime random number
  #syscall
  move $v0 $a0		    #return the coprime number in v0	
  lw $ra, 0($sp)
  addi $sp $sp 4
  jr $ra
  

#prikExp takes in a0 and a1 as x and y, then 
#returns an integer in v0
#first try let's go!!
.globl prikExp
prikExp:  

  addi $sp $sp -4
  sw $ra, 0($sp)
  jal gcd
  lw $ra, 0($sp)
  addi $sp $sp 4
  
  li $t0 0 	# p (i-2)
  li $t1 1 	# p (i-1)
  li $t2 0 	# p (i)
  li $t3 -1 	# quotient (i-2)
  li $t4 -1 	# quotient (i-1)
  li $t5 1 	# quotient (i)
  move $t6 $a1 	# divisor
  move $t7 $a0 	# dividend
  li $t8 -1	# remainder
  li $t9 1	# counter
  
  bne $v0 $t1 notCoprime
  
  while2:

  	div $t6 $t7
  	mflo $t5		# quotienti = divisor / dividend;
  	mfhi $t8		# remainder = divisor % dividend;
  	move $t6 $t7	# divisor = dividend;
  	move $t7 $t8	# dividend = remainder;
  	
  	addi $sp $sp -12
    	sw $s1, 8($sp)
    	sw $s0, 4($sp)
  	sw $ra, 0($sp)
  	jal updateCurrentPi
  	lw $s1, 8($sp)
    	lw $s0, 4($sp)
  	lw $ra, 0($sp)
  	
  	addi $sp $sp 12
  	move $t3 $t4	#quotient0 = quotient1;
  	move $t4 $t5	#quotient1 = quotienti;
  	addi $t9 $t9 1	#counter++;
  	move $t0 $t1	#p0 = p1;
  	move $t1 $t2	#p1 = pi;

  	bnez $t8 while2	#while (remainder != 0)
  	
  addi $sp $sp -12
  sw $s1, 8($sp)
  sw $s0, 4($sp)
  sw $ra, 0($sp)
  jal updateCurrentPi
  lw $s1, 8($sp)
  lw $s0, 4($sp)
  lw $ra, 0($sp)
  addi $sp $sp 12
  
  move $v0 $t2 #store our return type to v0
  
  jr $ra

notCoprime:
  li $v0 -1
  jr $ra

updateCurrentPi:
  li $s0 1
  li $s1 2
  beq $s0 $t9 set_to_0
  beq $s1 $t9 set_to_1
  bgt $t9 $s1 calculate_pi
  
set_to_0:
  li $t2 0
  jr $ra

set_to_1:
  li $t2 1
  jr $ra
  
calculate_pi:
  mul $s0 $t1 $t3
  sub $s0 $t0 $s0
  div $s0 $a1
  mfhi $t2
  
  bltz $t2 makePositive
  jr $ra

makePositive:
  add $t2 $t2 $a1 #pi += y;
  jr $ra

# takes in encrypted message m(a0), two prime number p(a1) and q(a2)
# goal: return c = m^e (mod)n, where e = public key and n = p * q
.globl encrypt
encrypt:
  move $t1 $a0		#save the hashed message for later
  mul $t0 $a1 $a2   	# n = p * q
  
  addi $sp $sp -16
  sw $ra, 0($sp)
  sw $a0, 4($sp)
  sw $a1, 8($sp)
  sw $t0, 12($sp)
  move $a0 $a1		#a0 = p
  move $a1 $a2		#a1 = q
  #z = K = lcm(p-1, q-1)
  addi $a1 $a1 -1
  addi $a0 $a0 -1
  jal lcm
  lw $ra, 0($sp)		#restoring values	
  lw $a0, 4($sp)
  lw $a1, 8($sp)
  lw $t0, 12($sp)
  addi $sp $sp 16
  
  addi $sp $sp -12
  sw $t1, 8($sp)
  sw $t0, 4($sp)
  sw $ra, 0($sp)
  move $a0 $v0    	# now a0 has the lcm of p-1 and q-1
  jal pubkExp
  move $v1, $v0		#store the public key in v1 and random number in a0
  lw $ra, 0($sp)
  lw $t0, 4($sp)
  lw $t1, 8($sp)
  addi $sp $sp 12
  
  addi $sp $sp -4
  sw $ra, 0($sp)
  move $a0 $t1		#move back the hashed message
  jal calculate_encrypted_msg		#calculate (m^e) mod n
  lw $ra, 0($sp)
  addi $sp $sp 4
  
  jr $ra 

#takes in a0 and v1, and s0 and return the (a0^v1)mod t0 in v0
#GOAL: calculate (m^e) mod(n)
calculate_encrypted_msg:
  li $t1 1		#counter
  move $v0 $a0
  for2:
    div $v0 $t0 		#result%modVal
    mfhi $v0
    mul $v0 $v0 $a0	#((result%modVal)*base)
    div $v0 $t0		# ((result%modVal)*base)%modVal;
    mfhi $v0    
    
    addi $t1 $t1 1
    bne $t1 $v1 for2
  jr $ra

#takes in encrypted message c (a0), public key (a1), two prime numbers q(a2) and p(a3)
.globl decrypt
decrypt:
  mul $t0 $a2 $a3   	# n = p * q
  move $t1 $a0		#save the encrypted message for later
  
  addi $sp $sp -20
  sw $ra, 0($sp)
  sw $a0, 4($sp)
  sw $a1, 8($sp)
  sw $t0, 12($sp)
  sw $t1, 16($sp)

  
  move $a0 $a2
  move $a1 $a3
  addi $a1 $a1 -1
  addi $a0 $a0 -1
  jal lcm		#takes in a0 (p) and a1 (q) and return v0
  lw $ra, 0($sp)
  lw $a0, 4($sp)
  lw $a1, 8($sp)
  lw $t0, 12($sp)
  lw $t1, 16($sp)
  addi $sp $sp 20
  
  addi $sp $sp -12
  sw $t1, 8($sp)
  sw $t0, 4($sp)
  sw $ra, 0($sp)
  move $a0 $a1		# stores the public key to $a0, which is the input x
  move $a1 $v0		# stores the lcm to $a1, which is the input y
  jal prikExp		#takes in a0 (x) and a1 (y) and return v0
  lw $ra, 0($sp)
  lw $t0, 4($sp)
  lw $t1, 8($sp)
  addi $sp $sp 12
  
  move $a0 $t1		#move back the encrypted message
  move $v1 $v0		# stores the private key in v1
  addi $sp $sp -12
  sw $t1, 8($sp)
  sw $t0, 4($sp)
  sw $ra, 0($sp)
  jal calculate_encrypted_msg		#calculate (m^e) mod n and stores it in v0
  lw $ra, 0($sp)
  lw $t0, 4($sp)
  lw $t1, 8($sp)
  addi $sp $sp 12
  
  jr $ra
