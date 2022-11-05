######### Yuxiang Dong ##########
######### 114322553 ##########
######### yuxdong ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:

  #################################### File Setup #########################################
  	#syscall 13
  	#a0 filename, a1 is the mode (0 is read and 1 is write)
  	#a2 is 0, returns v0, which contains the file descriptor
  
  move $s0 $a1			#preserve a1 since it stores the buffer

  li $v0 13			#read the file
  li $a1 0
  li $a2 0
  syscall
  blt $v0 $0 done		# if error occurred in the system
  move $a0 $v0			#move the file descriptor/or the pointer to $a0
  #li $v0 1
  #syscall			#prints the file descriptor
  move $a1 $s0			#bring the buffer back
  
  li $a2 1			#reading one char at a time!!!!
  ##################################   LET THE REAL FUN BEGINS ##############################
  li $t7 -1			#counter
  li $t9 0			#the numeric value
  for_rows_and_columns:		#loop through it two times
  li $v0 14			#getting the character in a1		
  syscall
  beqz $v0 done 		# the file ends, we're done
  
  li $v0 0
  addi $sp $sp -4
  sw $ra 0($sp)
  jal check_line  	#Line CHARACTER(s), could be \r\n or a \n depending on the system
  lw $ra 0($sp)
  addi $sp $sp 4
  
  bgez $v0 is_a_line		#if the current char is a line
  
  li $v0 0
  addi $sp $sp -4
  sw $ra 0($sp)
  jal check_between_0_9		# parse the first character, should be char [0-9]
  lw $ra 0($sp)
  addi $sp $sp 4
  blt $v0 $0 done		# if v0 -1, then it's not within [0-9] and it's not a number
  
  addi $sp $sp -20
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  sw $t2 12($sp)
  sw $t3 16($sp)
  jal appendCharacter		# parse the character, should be char [0-9]
  move $t9 $v0
  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  lw $t2 12($sp)
  lw $t3 16($sp)
  addi $sp $sp 20
  j for_rows_and_columns
  
is_a_line:
  addi $t7 $t7 1
  
  addi $sp $sp -4
  sw $ra 0($sp)
  jal check_between_1_10		# t9 should be number [1-10]
  lw $ra 0($sp)
  addi $sp $sp 4
  
  bltz $v0 initialization_error

  sw $t9 0($a1)			# store it in the first position in our buffer
  li $t9 0
  addi $a1 $a1 4         	#move on to the next address  
  bne $t7 $a2 for_rows_and_columns
  ########################### Here ends the check for the first 2 lines #######################
  # crucial!! $s0 stores the original buffer, since we've to update the buffer address as we go
  lw $s1 0($s0) 			# stores the row of the matrix
  lw $s2 4($s0)			# stores the column of the matrix
  li $t0 0			# detect if we have a white space
  li $t1 ' '			# represent space between the numbers
  li $t2 13			# the \r symbol
  li $t3 10			# the \n symbol
  				# t4 current character
  li $t7 1			# current numbers count in a row, it's the #of spaces + 1
  li $t8 0			# current numbers count in a col 
  li $t9 0			# numberic value of the number
  loop:
 	li $v0 14			
  	syscall

  	lbu $t4 0($a1) 			# load current character
  	
  	# situation 1 #if we reach the end of the line
  	beqz $v0 deal_with_end_of_file
  	# situation 2 #if it's a space
  	beq $t4 $t1 deal_with_space
  	# situation 3: # if it's a new line
  	seq $t5 $t2 $t4			#if the char is \r
  	seq $t6 $t3 $t4			#if the char is \n
  	or $t5 $t5 $t6
  	bnez $t5 deal_with_new_line
  	# situation 4: if it's a number / not a number
  	j deal_with_numbers	#while the character we detect is not /r or /n or the end of the file
#takes in $t9 and see if it's within 1-10
check_between_1_10:
  #checking if t9 is [1-10]
  li $t0, 1			
  li $t1, 10
	
  sge $t3, $t9, $t0		#if curr char >= 1
  sle $t4, $t9, $t1 		#if curr char <= 10
  and $t3, $t3, $t4		#if curr char >= 0 && curr char <= 9

  beq $t3, $0, initialization_error 	#if it's not between 0 - 9 set v0 to -1
  jr $ra
deal_with_end_of_file:
  bgt $t8 $s1 initialization_error	#check the # of rows match # of number in a column
  j done
  
deal_with_space:
  bne $t0 $0 initialization_error
  li $t0 1
  addi $t7 $t7 1			#current numbers in a row ++
  sw $t9 0($a1)
  li $t9 0			#reset the numeric value after we insert the value
  addi $a1 $a1 4
  j loop
  
deal_with_new_line:
  bgt $t7 $s2 initialization_error	#check the # of rows match # of number in a column
  li $t7 1				#reset numbers in that row
  li $t0 0

  # check if the current number in a row matches our store row count
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  jal check_line  	#Line CHARACTER(s), could be \r\n or a \n depending on the system
  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  addi $sp $sp 12

  addi $t8 $t8 1			#current numbers in a column ++
  sw $t9 0($a1)
  li $t9 0			#reset the numeric value after we insert the value
  addi $a1 $a1 4
  j loop
  
deal_with_numbers:
  li $t0 0
  addi $sp $sp -24
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  sw $t2 12($sp)
  sw $t3 16($sp)
  sw $t4 20($sp)
  jal check_between_0_9		# parse the first character, should be char [0-9]

  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  lw $t2 12($sp)
  lw $t3 16($sp)
  lw $t4 20($sp)
  addi $sp $sp 24
  blt $v0 $0 done		# if v0 -1, then it's not within [0-9]
  
  addi $sp $sp -20
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  sw $t2 12($sp)
  sw $t3 16($sp)
  jal appendCharacter		# parse the first character, should be char [0-9]
  move $t9 $v0
  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  lw $t2 12($sp)
  lw $t3 16($sp)
  addi $sp $sp 20
 
  j loop

#takes in $a1 as the input
#outputs v0 to -1 if it's not between 0 and 1
check_between_0_9:
	li $t1, '0'			#save ascii of "0" to $s1
	li $t2, '9'
	lbu $t0, 0($a1)
	
	sge $t3, $t0, $t1		#if curr char >= 0 
	sle $t4, $t0, $t2 		#if curr char <= 9
	and $t3, $t3, $t4		#if curr char >= 0 && curr char <= 9

	beq $t3, $0, initialization_error 	#if it's not between 0 - 9 set v0 to -1
	jr $ra
	
check_line:
	j check_CR
check_CR:
	li $t1, 13
	lbu $t0, 0($a1)

	bne $t1, $t0, check_LF 	#if it's not the \r, then check if the current char is \n
	#if the current char is \r, we need to check if the next char is \n
	li $v0 14			#getting the next character	
  	syscall
	j check_LF
	
check_LF:
	li $t1, 10
	lbu $t0, 0($a1)

	bne $t1, $t0, initialization_error 	#if it's not between 0 - 9 set v0 to -1
	jr $ra
		
initialization_error:
	li $v0 -1
	jr $ra
	
done:
	jr $ra
	
#t9 is the number that we currently have
#returns the result in v0
appendCharacter:
	move $v0 $t9 			
	li $t1 10			#the number 10
	lbu $t2 0($a1)			#extract the number, it will be in ascii
	li $t3 '0'			#ascii of 0
	sub $t2 $t2 $t3			# get the numeric value
	mul $v0 $v0 $t1			# then mul by 10
	add $v0 $v0 $t2	
	jr $ra

.globl write_file
write_file:
  li $t9 0			# character written
  addi $sp $sp -8
  sw $s0 0($sp)
  sw $s1 4($sp)
  
  move $s0 $a1			#preserve a1 since it stores the buffer
  li $v0 13			#read the file
  li $a1 1			#write mode
  li $a2 0
  syscall
  blt $v0 $0 done		# if error occurred in the system
  move $a0 $v0			#move the file descriptor/or the pointer to $a0
  #li $v0 1
  #syscall			#prints the file descriptor
  move $a1 $s0			#bring the buffer back
  li $a2 1			#writing one char at a time!!!!
  
  ##################################   LET THE REAL FUN BEGINS ##############################
  lw $s0 0($a1) 		#store the s0 as the row
  lw $s1 4($a1) 		#store the s1 as the columns

  li $t0 10			# \n in ascii
  li $t1 -1			# counter
  for_write_row_and_columns:
  
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  jal write_number
  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  addi $sp $sp 12
  
  sw $t0 0($a1)
  li $v0 15		#write the character
  syscall
  bltz $v0 initialization_error
  addi $t9 $t9 1
  addi $t1 $t1 1
  addi $a1 $a1 4
  bne $t1 $a2 for_write_row_and_columns
  
  ################################ WRITING THE MATRIX ############################
  li $t1 32		#ascii of space
  li $t2 1		#number of rows counter
  li $t3 1 		#number of columns counter
  write_loop:
  addi $sp $sp -20
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  sw $t2 12($sp)
  sw $t3 16($sp)
  jal write_number
  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  lw $t2 12($sp)
  lw $t3 16($sp)
  addi $sp $sp 20

  bne $t3 $s1 write_space
  bne $t2 $s0 write_line
  ################################ The end ############################
  #write an extra new line to follow the format
  sw $t0 0($a1)		#load new line into the matrix
  li $v0 15		#write the character
  syscall
  bltz $v0 initialization_error
  addi $t9 $t9 1
  #need to have $a0 as the file descriptor
  li $v0 16		#closes the file
  syscall

  lw $s0 0($sp)
  lw $s1 4($sp)
  addi $sp $sp 8
  
  move $v0 $t9
  jr $ra
 
write_space:
  sw $t1 0($a1)		#load space into the matrix
  li $v0 15		#write the character
  syscall
  bltz $v0 initialization_error
  addi $t9 $t9 1
  addi $t3 $t3 1
  addi $a1 $a1 4
  j write_loop
  
write_line:
  li $t3 1
  sw $t0 0($a1)		#load new line into the matrix
  li $v0 15		#write the character
  syscall
  bltz $v0 initialization_error
  addi $t9 $t9 1
  addi $t2 $t2 1
  addi $a1 $a1 4
  j write_loop

#step 2: write the character line by line
write_number:
  #step1: find the length of the digit
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  jal find_digit_length
  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  addi $sp $sp 12
  move $t0 $v0			#t0 is the length
  lw $t4 0($a1)		#get the current number
  for_number:
  	li $t1 1			#the number to divide by
  	li $t3 10		#the number 10
  	li $t2 1			#the counter

  	
  	beq $t0 $t2 skip_mul		#if the length equals to 1, skip multiplying
  	for_digit_len:
  		mul $t1 $t1 $t3
  		addi $t2 $t2 1
  		bne $t2 $t0 for_digit_len 
  	skip_mul:
  		div $t4 $t1
  		mflo $t6			#store the quotient
  		li $t7 '0'		#
  		add $t6 $t6 $t7		#convert values into ascii
  		sw $t6 0($a1)
  		li $v0 15		#write the character
  		syscall
  	  	bltz $v0 initialization_error
  		addi $t9 $t9 1
  		mfhi $t5			#store the remainder
  		move $t4 $t5
  	
	addi $t0 $t0 -1
  	bnez $t0 for_number
  jr $ra

#assuming the digit is currently stored in the address of a1
#returns the length in v0
find_digit_length:
	lw $t0 0($a1)
	li $t1 10
	li $v0 0
	whileLen:
		div $t0 $t1
		mflo $t0
		addi $v0 $v0 1
		bnez $t0 whileLen
	jr $ra

#takes in a1 as the buffer
#result: every_row_in the matrix will be reversed
reverse_rows:
	lw $s0 0($a1)		# the no. of row of the matrix
	lw $s1 4($a1)		# the no. of column of the matrix

	li $t2 0			#current column number
	li $t5 4			# teh element size
	
	for_every_row:
	li $t0 0			#the index at the beginning row
	move $t1 $s1		#
	addi $t1 $t1 -1		#the index at the end of the row	
	
	reverse_single_row: 
		#step1: calculate the index to swap
		#t3 represent the index from the beginning
		#t4 represent the index from the end
		mul $t3 $t2 $s1 		# i * column size
		add $t3 $t3 $t0		# i * column size + j
		mul $t3 $t3 $t5		# element_size*(i * column_size + j)
		addi $t3 $t3 8		# element_size*(i * column_size + j) + base address
		
		mul $t4 $t2 $s1 		
		add $t4 $t4 $t1		
		mul $t4 $t4 $t5		
		addi $t4 $t4 8		# + base address		
		
		#step2: make 2 address copies to work with
		move $t6 $a1
		move $t7 $a1
		add $t6 $t6 $t3
		add $t7 $t7 $t4
		
		#step3: swap these 2 positions
		lw $s2 0($t6)		# get the value from the front
		#move $t8 $s2
		lw $s3 0($t7)		# get the value from the end
		sw $s2 0($t7)
		sw $s3 0($t6)
		
		#last but not least, increment our value
		addi $t0 $t0 1
		addi $t1 $t1 -1
		blt $t0 $t1 reverse_single_row 
	addi $t2 $t2 1
	bne $t2 $s0 for_every_row
  	jr $ra


reverse_columns:
	lw $s0 0($a1)		# the no. of row of the matrix
	lw $s1 4($a1)		# the no. of column of the matrix

	li $t0 0			# j
	li $t5 4			# teh element size
	
	for_every_col:
	li $t2 0			# i 
	move $t1 $s0		#
	addi $t1 $t1 -1		#the index at the end of the row
	
	reverse_single_col: 
			
		#step1: calculate the index to swap
		#t3 represent the index from the beginning
		#t4 represent the index from the end
		mul $t3 $t2 $s1 		# i * column size
		add $t3 $t3 $t0		# i * column size + j
		mul $t3 $t3 $t5		# element_size*(i * column_size + j)
		addi $t3 $t3 8		# element_size*(i * column_size + j) + base address
		
		mul $t4 $t1 $s1 		
		add $t4 $t4 $t0		
		mul $t4 $t4 $t5		
		addi $t4 $t4 8		# + base address		
		
		#step2: make 2 address copies to work with
		move $t6 $a1
		move $t7 $a1
		add $t6 $t6 $t3
		add $t7 $t7 $t4
		
		#step3: swap these 2 positions
		lw $s2 0($t6)		# get the value from the front
		#move $t8 $s2
		lw $s3 0($t7)		# get the value from the end
		sw $s2 0($t7)
		sw $s3 0($t6)
		
		#last but not least, increment our value
		addi $t2 $t2 1
		addi $t1 $t1 -1		#the index at the end of the row
		blt $t2 $t1 reverse_single_col 
	addi $t0 $t0 1
	bne $t0 $s1 for_every_col
  	jr $ra
#rotate the matrix clockwise by 90 deg
#first step: reverse elements in every column
#second step: transpose the matrix
.globl rotate_clkws_90
rotate_clkws_90:
  move $s0 $a1
  move $a1 $a0
  move $a0 $s0
  
  addi $sp $sp -20
  sw $ra 0($sp)
  sw $s0 4($sp)
  sw $s1 8($sp)
  sw $s2 12($sp)
  sw $s3 16($sp)
  jal reverse_columns
  lw $ra 0($sp)
  lw $s0 4($sp)
  lw $s1 8($sp)
  lw $s2 12($sp)
  lw $s3 16($sp)
  addi $sp $sp 20
  
  j write_file_in_column_major
 jr $ra
#rotate the matrix clockwise by 180 deg
#first step: reverse elements in every row
#second step: reverse elements in every column
.globl rotate_clkws_180
rotate_clkws_180:
  move $s0 $a1
  move $a1 $a0
  move $a0 $s0
  
  addi $sp $sp -20
  sw $ra 0($sp)
  sw $s0 4($sp)
  sw $s1 8($sp)
  sw $s2 12($sp)
  sw $s3 16($sp)
  jal reverse_rows
  lw $ra 0($sp)
  lw $s0 4($sp)
  lw $s1 8($sp)
  lw $s2 12($sp)
  lw $s3 16($sp)
  addi $sp $sp 20

  addi $sp $sp -20
  sw $ra 0($sp)
  sw $s0 4($sp)
  sw $s1 8($sp)
  sw $s2 12($sp)
  sw $s3 16($sp)
  jal reverse_columns
  lw $ra 0($sp)
  lw $s0 4($sp)
  lw $s1 8($sp)
  lw $s2 12($sp)
  lw $s3 16($sp)
  addi $sp $sp 20
  j write_file
 jr $ra

#rotate the matrix clockwise by 270 deg
#first step: reverse elements every row
#second step: transpose the matrix
.globl rotate_clkws_270
rotate_clkws_270:
  move $s0 $a1
  move $a1 $a0
  move $a0 $s0
  
  addi $sp $sp -20
  sw $ra 0($sp)
  sw $s0 4($sp)
  sw $s1 8($sp)
  sw $s2 12($sp)
  sw $s3 16($sp)
  jal reverse_rows
  lw $ra 0($sp)
  lw $s0 4($sp)
  lw $s1 8($sp)
  lw $s2 12($sp)
  lw $s3 16($sp)
  addi $sp $sp 20

  j write_file_in_column_major
 jr $ra

write_file_in_column_major:  
  li $t9 0
  move $s0 $a1			#preserve a1 since it stores the buffer
  li $v0 13			#read the file
  li $a1 1			#write mode
  li $a2 0
  syscall
  blt $v0 $0 done		# if error occurred in the system
  move $a0 $v0			#move the file descriptor/or the pointer to $a0
  #li $v0 1
  #syscall			#prints the file descriptor
  move $a1 $s0			#bring the buffer back
  li $a2 1			#writing one char at a time!!!!
  
  ##################################   LET THE REAL FUN BEGINS ##############################
  lw $s0 0($a1) 		#store the s0 as the row
  lw $s1 4($a1) 		#store the s1 as the columns

  li $t0 10			# \n in ascii
  li $t1 -1			# counter
  addi $a1 $a1 4			#write the number of column first
  write_row_and_columns_for_column_major:
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  jal write_number
  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  addi $sp $sp 12
  
  sw $t0 0($a1)
  li $v0 15		#write the character \n
  syscall
  bltz $v0 initialization_error
  addi $t9 $t9 1
  addi $t1 $t1 1
  addi $a1 $a1 -4			#then go to the row
  bne $t1 $a2 write_row_and_columns_for_column_major
  #after this, the address should be at -4, but we want to end at 8
  addi $a1 $a1 12
  ################################ WRITING THE MATRIX ############################
  #t0 is the ascii of new line
  li $t1 32		#ascii of space
  li $t2 1		#number of rows counter
  li $t3 1 		#number of columns counter
  move $t4 $a1		#remember the address of a1	
  write_loop_in_col_major:
  addi $sp $sp -28
  sw $ra 0($sp)
  sw $t0 4($sp)
  sw $t1 8($sp)
  sw $t2 12($sp)
  sw $t3 16($sp)
  sw $t4 20($sp)
  sw $a1 24($sp)
  move $a1 $t4
  jal write_number
  lw $ra 0($sp)
  lw $t0 4($sp)
  lw $t1 8($sp)
  lw $t2 12($sp)
  lw $t3 16($sp)
  lw $t4 20($sp)
  lw $a1 24($sp)
  addi $sp $sp 28

  bne $t2 $s0 write_space_in_col_major
  bne $t3 $s1 write_line_in_col_major
  ################################ The end ############################
  #write an extra new line to follow the format
  sw $t0 0($a1)		#load new line into the matrix
  li $v0 15		#write the character
  syscall
  bltz $v0 initialization_error
  addi $t9 $t9 1
  #need to have $a0 as the file descriptor
  li $v0 16		#closes the file
  syscall
  move $v0 $t9
  jr $ra
  
write_space_in_col_major:
  li $t5 4
  move $t7 $a1
  move $a1 $t4
  sw $t1 0($a1)		#load space into the matrix
  li $v0 15		#write the character
  syscall
  bltz $v0 initialization_error
  addi $t9 $t9 1
  move $a1 $t7
  
  addi $t2 $t2 1		#increment row number
  addi $t6 $t2 -1			#get the row index
  addi $t7 $t3 -1			#get the column index
  			#calculate the next space based on i and j
  mul $t6 $t6 $s1 		# i * column size
  add $t6 $t6 $t7		# i * column size + j
  mul $t6 $t6 $t5		# element_size*(i * column_size + j)
  #addi $t3 $t3 8		# element_size*(i * column_size + j) + base address
  add $t4 $a1 $t6	#set the target address to t4
  j write_loop_in_col_major
  
write_line_in_col_major:
  li $t2 1		#reset the row number
  li $t5 4
  
  move $t7 $a1
  move $a1 $t4
  sw $t0 0($a1)		#load new line into the matrix
  li $v0 15		#write the character
  syscall
  bltz $v0 initialization_error
  addi $t9 $t9 1
  move $a1 $t7
  
  addi $t3 $t3 1		#increment the column number
  addi $t6 $t2 -1			#get the row index
  addi $t7 $t3 -1			#get the column index
  			#calculate the next space based on i and j
  mul $t6 $t6 $s1 		# i * column size
  add $t6 $t6 $t7		# i * column size + j
  mul $t6 $t6 $t5		# element_size*(i * column_size + j)
  #addi $t3 $t3 8		# element_size*(i * column_size + j) + base address
  add $t4 $a1 $t6	#set the target address to t4
  
  #addi $t4 $t4 4
  j write_loop_in_col_major
#should be obvious
.globl mirror
mirror:
  move $s0 $a1
  move $a1 $a0
  move $a0 $s0
  
  addi $sp $sp -20
  sw $ra 0($sp)
  sw $s0 4($sp)
  sw $s1 8($sp)
  sw $s2 12($sp)
  sw $s3 16($sp)
  jal reverse_rows
  lw $ra 0($sp)
  lw $s0 4($sp)
  lw $s1 8($sp)
  lw $s2 12($sp)
  lw $s3 16($sp)
  addi $sp $sp 20
  j write_file
 jr $ra

#takes buffer as input,v0 as output
.globl duplicate
duplicate:
  move $a1 $a0
  
  addi $sp $sp -24
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  sw $s3 12($sp)
  sw $s4 16($sp)
  sw $s5 20($sp)
  
  li $v0 -1 		#-1 means not found
  li $v1 0		#0 means not found
  lw $s0 0($a1)		# the no. of row of the matrix
  lw $s1 4($a1)		# the no. of columns of the matrix
  li $s4 0		# first value index
  li $s5 0		# second value index
  #$t0 will be the first number to compare
  #$t1 will be the second number to compare
  li $t2 -1			# the first row index
  li $t3 0			# the column
  li $t4 4			# the element size
  #li $t5 0			# the second row index
  li $t9 1			# the number 1 would indicator that a duplicate is not found 
  addi $a1 $a1 8			#get to the matrix address
  ########################### let the real fun begins #########################
  for_each_first_row:
  addi $t2 $t2 1
  move $t5 $t2
  beq $t2 $s0 end_dup
  for_each_second_row:
  li $t3 0			# reset column
  li $t9 0			# the duplicate is initialized as "found"
  addi $t5 $t5 1
  beq $t5 $s0 for_each_first_row
  for_each_number:
  
  #create a for loop to check each number is the same in each row
  mul $s4 $t2 $s1 		# i1 * column size
  add $s4 $s4 $t3		# i1 * column size + j
  mul $s4 $s4 $t4		# element_size*(i1 * column_size + j)
  
  mul $s5 $t5 $s1 		# i1 * column size
  add $s5 $s5 $t3		# i1 * column size + j
  mul $s5 $s5 $t4		# element_size*(i1 * column_size + j)
  
  #step2: make 2 address copies to work with
  move $t6 $a1
  move $t7 $a1
  add $t6 $t6 $s4
  add $t7 $t7 $s5
  #step3:check if the numbers are equal or not
  lw $s2 0($t6)		# get the first value
  lw $s3 0($t7)		# get the second value 
  sne $t9 $s2 $s3 	# sets t9 to 1 if s2 and s3 are not equal, meaning it's not a duplicate
  
  bnez $t9 for_each_second_row 		#if it's not a duplicate, just skip to the next row
  addi $t3 $t3 1			# go to the next character
  bne $t3 $s1 for_each_number
  
  ##################### Reach this point, we found the duplicate ###############################
  move $v1 $t5
  addi $v1 $v1 1		#change from index to row number
  li $v0 1
  end_dup:
    
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $s3 12($sp)
  lw $s4 16($sp)
  lw $s5 20($sp)
  addi $sp $sp 24
  jr $ra
 
transpose_matrix:
	lw $s0 0($a1)		# the no. of row of the matrix
	lw $s1 4($a1)		# the no. of column of the matrix
	sw $s1 0($a1)		# the no. of row of the matrix
	sw $s0 4($a1)		# the no. of column of the matrix
	
	li $t2 0			# current row
	li $t5 4			# teh element size
	
	transpose_every_row:
	move $t0 $t2			#the index at the beginning row
	
	transpose_single_row: 
		#step1: calculate the index to swap
		#t3 represent the index from the beginning
		mul $t3 $t2 $s1 		# i * column size
		add $t3 $t3 $t0		# i * column size + j
		mul $t3 $t3 $t5		# element_size*(i * column_size + j)
		addi $t3 $t3 8		# element_size*(i * column_size + j) + base address
		
		mul $t4 $t0 $s1 		# j * column size	
		add $t4 $t4 $t2		# j * column size + i
		mul $t4 $t4 $t5		# element_size*(j * column_size + i)
		addi $t4 $t4 8		# element_size*(j * column_size + i) + base address		
		
		#step2: make 2 address copies to work with
		move $t6 $a1
		move $t7 $a1
		add $t6 $t6 $t3
		add $t7 $t7 $t4
		
		#step3: swap these 2 positions
		lw $s2 0($t6)		# get the value
		#move $t8 $s2
		lw $s3 0($t7)		# get the other value
		sw $s2 0($t7)
		sw $s3 0($t6)		#swap
		
		#last but not least, increment our value
		addi $t0 $t0 1
		bne $t0 $s1 transpose_single_row 
	addi $t2 $t2 1
	bne $t2 $s0 transpose_every_row
  	jr $ra
 #function that takes in the address in $a1, the current decimal place in $t0
#returns the number to the decimal place in $v0
multiply:
	li $t1 10			#the number 10
	li $t2 0				#counter
	lbu $t3 0($a1)			#extract the number, it will be in ascii
	li $t4 '0'			#ascii of 0
	sub $t3 $t3 $t4
	beq $t0 $0 done_multiply		#if it's 0, then you don't need to multiply
	for_multiply:
		mul $t3 $t3 $t1
		addi $t2 $t2 1
		bne $t2 $t0 for_multiply
		
	done_multiply:
		move $v0 $t3
		jr $ra
