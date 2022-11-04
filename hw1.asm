################# YuXiang Dong #################
################# yuxdong #################
################# 1114322553 #################
################# DON'T FORGET TO ADD GITHUB USERNAME IN BRIGHTSPACE #################

################# DO NOT CHANGE THE DATA SECTION #################

.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "Invalid Arguments\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
invalid_hand_msg: .asciiz "Loot Hand Invalid\n"
newline: .asciiz "\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:
# $a0 		the # of arguments
# $a1		this argument 1 address

# $t0		the second argument address
# $t1  		the first character of the first argument
# $t2 		Any immediates that needs to be loaded
# $t3		the boolean that determines if hex string is valid or not
# $t4 		store the binary form of the hex string
# $t5		number of merchant ships
# $t6 		number of pirate ships
#PART I: (a) Checking valid # of arguments
	li $t1 2
	bne $a0, $t1, print_args_err_msg 		#if (num_args != 2) print err and terminate
#(b) checking if arg1[0] is 2 characters or not
	lbu $t1, 1($a1)					#if the second btye/character is a null terminator, $t1 = 0
	bne $t1, $0, print_invalid_arg_msg		#if $t1 != 0, then print invalide arg error

#(c) switch statment that checks if the first character is equal to "D" "O" "S" "T" "E" "H" "U" "F", or "L"
	lbu $t1, 0($a1)					# get the first character of argument
	li $t3, 1					# boolean for hex string is valid or not
#PART II
	caseD:
		li $t2, 'D' 			#loads the Ascii of "D" to the console.
		bne $t1, $t2, caseO		#If it's not D, go to the other branches
		j string_to_decimal
	
#PART III
#for the HEX String section, there will be a boolean $s0 that indicates whether a HEX string has been verified or not
	caseO:
		li $t2, 'O' 
		bne $t1, $t2, caseS
		bne $t3, $0, verify_hex_string			#if t3 is 1, then we have not verified the string yet
		#after verifying it, the decimal representation of hex string is stored in $t4
		j display_upcode
	caseS:
		li $t2, 'S' 
		bne $t1, $t2, caseT
		bne $t3, $0, verify_hex_string
		j display_rs
	caseT:
		li $t2, 'T' 
		bne $t1, $t2, caseE
		bne $t3, $0, verify_hex_string	
		j display_rt
	caseE:
		li $t2, 'E' 
		bne $t1, $t2, caseH
		bne $t3, $0, verify_hex_string	
		j display_rd
	caseH:
		li $t2, 'H' 
		bne $t1, $t2, caseU
		bne $t3, $0, verify_hex_string	
		j display_shamt
	caseU:
		li $t2, 'U' 
		bne $t1, $t2, caseF
		bne $t3, $0, verify_hex_string	
		j display_funct
#PART IV
	caseF:
		li $t2, 'F' 
		bne $t1, $t2, caseL
		bne $t3, $0, verify_hex_string2
		j hex_to_IEEE754
#PART V
	caseL:
		li $t2, 'L' 
		bne $t1, $t2, default
		bne $t3, $0, verify_hand
		
		j done
	default:
		j print_invalid_arg_msg
		
	j done
verify_hand:
	#first gotta check if the argument is 13 characters including the null terminator
	move $t2, $t0			# create a copy of the second argument to $t2
	li $s1, 0			# counter
	li $s2, 13			# end condition/maximum character with null terminator
	li $t5, 0
	li $t6, 0			#set the pirate ship & merchant ships to 0
	
	#$s0		current character 
	#since the string may or may not be null terminated, we have to keep track of it's length
	for3:
		
		li $s4 'M'
		li $s5 'P'
		lbu $s0, 0($t2)			# get the curr char
		addi $s1, $s1, 1			# counter++
		bgt $s1 $s2, print_invalid_hand_msg
		beq $s0, $0, verify_13_characters	# if it's a null terminator, then exit and print the result
		addi $t2, $t2, 1			# next character!
		beq $s0, $s4, verify_between_digit_3_8	#it's merchant
		beq $s0, $s5, verify_between_digit_1_4	#it's pirate ship
		j  print_invalid_hand_msg		# if it's not any of them, then print err
		
verify_13_characters:
	bne $s1, $s2 print_invalid_arg_msg	# if counter != 13 , then print err msg
	j print_hand_value			#otherwise, we can print the hand value
	
print_hand_value:
	sll $a0, $t5, 3
	add $a0, $a0, $t6		#a0 will be the sign binary representation of representation
	li $s0 32			
	bge $a0 $s0 convert_to_negative_hand_value
	
	li $v0 1
	syscall
	j done
	
convert_to_negative_hand_value:
	addi $a0 $a0 -64
	li $v0 1
	syscall
	j done

verify_between_digit_3_8:
	li $s6 '3'
	li $s7 '8'
	lbu $s0, 0($t2)
	
	sge $s4, $s0, $s6		#if curr str >= 3
	sle $s5, $s0, $s7 		#if curr str <= 8
	and $s4, $s4, $s5		#if curr str >= 3 && curr char <=8
	
	bnez $s4, update_merchant_ship	#if it's between the two, then update the merchant ship
	j print_invalid_hand_msg 		# if it's not, then  print invalid args

update_merchant_ship:
	addi $t5, $t5, 1			# merchant ships++
	addi $s1, $s1, 1			# counter++
	addi $t2, $t2, 1			# next character!
	j for3
verify_between_digit_1_4:
	li $s6 '1'
	li $s7 '4'
	lbu $s0, 0($t2)
	
	sge $s4, $s0, $s6		#if curr str >= 1
	sle $s5, $s0, $s7 		#if curr str <= 4
	and $s4, $s4, $s5		#if curr str >= 1 && curr char <=4
	
	bnez $s4, update_pirate_ship	#if it's between the two, then update the merchant ship
	j print_invalid_hand_msg 		# if it's not, then  print invalid 
update_pirate_ship:
	addi $t6, $t6, 1			# merchant ships++
	addi $s1, $s1, 1			# counter++
	addi $t2, $t2, 1			# next character!
	j for3
verify_hex_string2:
#first check if the hex string must have 8 characters
	move $t2, $t0			# create a copy of the second argument to $t2
	li $s1, 0			# counter
	li $s2, 9			# end condition/maximum character with null terminator
	
	for2:
		lbu $s0, 0($t2)			# get the curr char
		addi $s1, $s1, 1			# counter++
		addi $t2, $t2, 1			# next character!
		bne $s0, $0, for2		# if it's a null terminator, then exit
	bne $s1, $s2 print_invalid_arg_msg	# if counter != 9 , then print err msg
	#second we have to iterate through the characters and check if it's a valid hex char
	move $t2, $t0
	j while2				# let the error checking begin!!
	
hex_to_IEEE754:
	#checks for special cases
	li $s1 0x00000000
	beq $t4 $s1 print_zero
	
	li $s1 0x80000000
	beq $t4 $s1 print_zero
	
	li $s1 0xFF800000
	beq $t4 $s1 print_inf_neg
	
	li $s1 0x7F800000
	beq $t4 $s1 print_inf_pos

	li $s1 0x7F800001
	li $s2 0x7FFFFFFF
	
	sge $s3, $t4, $s1		#if curr str >= 0x7f800001
	sle $s4, $t4, $s2 		#if curr str <= 0x7FFFFFFF
	and $s3, $s3, $s4		#if curr str >= 0x7f800001 && curr char <= 0x7FFFFFFF
	bnez $s3, print_nan	#if it's between the two, then print the label
	
	li $s1 0xFF800001
	li $s2 0xFFFFFFFF

	sge $s3, $t4, $s1		#if curr str >= 0x7f800001
	sle $s4, $t4, $s2 		#if curr str <= 0x7FFFFFFF
	and $s3, $s3, $s4		#if curr str >= 0x7f800001 && curr char <= 0x7FFFFFFF
	bnez $s3, print_nan		#if it's between the two, then print the label
	
	li $s2, 0x7FFFFF			#extract the first 23 bits to $a2
	and $a2, $s2, $t4		#let $a2 = mantissa in hex
	
	srl $t4, $t4, 23 		#then extract the next 8 bits
	li $s1, 0xFF			
	and $a0 $s1 $t4			#store the exponent to $a0
	addi $a0, $a0, -127		#use biase 127 to find the real exponent
	
	srl $t4, $t4, 8			#$t4 now represent the signed bit
	
	la $a1 mantissa		#STORING THE BASE ADDRESS to $a1
	#$a0 exponent
	#$a2 the binary mantissa
	#$t4 signed bit
	#steps: prepend the negative sign and then "1."
	#Then, add the mantissa stored in $a1 afterwards 
	#finally, end it with $0 because it needs null terminator
	bnez $t4 prepend_negative_sign 		#if t4 = 1, then the number is negative
	j prepend_normalized_1

prepend_negative_sign:
	li $s0 '-'
	sb $s0 0($a1)
	addi $a1 $a1 1
	j prepend_normalized_1	
prepend_normalized_1:
	li $s1 '1'
	li $s2 '0'
	li $s3 '.'
	sb $s1 0($a1)
	sb $s3 1($a1)
	addi $a1 $a1 2

	j add_mantissa
	
add_mantissa:
	# $s0 is the current character
	li $s3, 0			# counter
	li $s4, 23			# end condition/maximum character WITHOUT null terminator

	for4:
		li $s7 0x400000
		and $s0, $a2, $s7		# get the 23rd curr bit
		addi $s3, $s3, 1			# counter++
		sll $a2, $a2, 1			# next bit please!
		beqz $s0, add_0_to_bin_string	#if equal to 0, add 0 to bin string
		j add_1_to_bin_string		#if equal to 1, add 1 to bin string
		
add_1_to_bin_string:
	sb $s1 0($a1)
	addi $a1 $a1 1
	bne $s3, $s4, for4 	# if counter != 23 , then keep looping
	j print_bin_string
	
add_0_to_bin_string:
	sb $s2 0($a1)		# adds 0 to the current character
	addi $a1 $a1 1		# move on to the next character
	bne $s3, $s4, for4 	# if counter != 23 , then keep looping
	j print_bin_string
	
print_bin_string:
	sb $0 0($a1)		# add-in null terminator in the end
	
	la $a1 mantissa	
	

	j done
print_zero:
	la $a0 zero
	li $v0, 4
	syscall
	j done

print_inf_neg:
	la $a0 inf_neg
	li $v0, 4
	syscall
	j done
	
print_inf_pos:
	la $a0 inf_pos
	li $v0, 4
	syscall
	j done

print_nan:
	la $a0 nan
	li $v0, 4
	syscall
	j done
display_upcode:
	srl $a0 $t4 26
	li $v0 1
	syscall
	j done	
display_rs:
	srl $a0, $t4, 21
	andi $a0, $a0, 0x1F
	li $v0 1
	syscall
	j done
	
display_rt:
	srl $t4, $t4, 16
	andi $a0, $t4, 0x1F
	li $v0 1
	syscall
	j done
display_rd:
	srl $t4, $t4, 11
	andi $a0, $t4, 0x1F
	li $v0 1
	syscall
	j done
display_shamt:
	srl $t4, $t4, 6
	andi $a0, $t4, 0x1F
	li $s0 16	#If the shamt is greater than 16, then sign extend the value
	bge $a0 $s0 sign_extend_shamt
	li $v0 1
	syscall
	j done
sign_extend_shamt:
	addi $a0, $a0 -32
	li $v0 1
	syscall
	j done
display_funct:
	andi $a0, $t4, 0x3F
	li $v0 1
	syscall
	j done

#Checks if the hex string is valid or not
#During checking, since we're looping over each character, in the meantime,
#we'll convert the character to its binary form and store it to a register
verify_hex_string:
	move $t2, $t0 			#create a copy of the second argument to $t2
	li $s1, '0'			#save ascii of "0" to $s1
	li $s2, 'x'			#save ascii of "x" to $s2

	#Checks the first two characters of the second argument
	lbu $s0, 0($t2)			# checks if the first char is "0"
	bne $s0, $s1, print_invalid_arg_msg
	addi $t2, $t2, 1
	
	lbu $s0, 0($t2) 		# checks if the second char is "x"
	bne $s0, $s2, print_invalid_arg_msg
	addi $t2, $t2, 1
	
# verify the string to be between 1 to 8 characters
	move $t2, $t0			# create a copy of the second argument to $t2
	li $s1, 0			# counter
	li $s2, 9			# end condition/maximum character with null terminator
	lbu $s0, 2($t2)			# $s0 stores the character after "0x"
	beq $s0, $0, print_invalid_arg_msg	# if the string is "0x", then it's an err
	
	for1:
		lbu $s0, 2($t2)			# get the curr char
		addi $s1, $s1, 1			# counter++
		addi $t2, $t2, 1			# next character!
		bne $s0, $0, for1		# if it's a null terminator, then exit
	
	sle $s1, $s1, $s2			# sets $s1 to 1 if the counter is less than 9
	beq $s1, $0, print_invalid_arg_msg	# if it's not 1, then print err msg
	
	li $t4 0 			# need to initialize $t4 with 0 otherwise garbage memory messes up the program
	move $t2, $t0				#reinitialize $t2 to the whole string
	addi $t2, $t2, 2				# skips "0x"
	while2:
		lbu $s0, 0($t2)		# step 2: get the base address of the second argument, (after "0x")
		slt $t3, $0, $s0		#                                                      = 1 if 0 < current char and t3 = 0 if 0 < 0/null term
		beq $t3, $0, caseO	# if we detect a null terminator, then we've verified the number
		addi $t2, $t2, 1	# move on to the next char
		j check_between_0_9

# checks the current character stored in $t2 is a between A-Z or not 
check_between_0_9:
	li $s1, '0'			#save ascii of "0" to $s1
	li $s2, '9'
	
	sge $s3, $s0, $s1		#if curr char >= 0 
	sle $s4, $s0, $s2 		#if curr char <= 9
	and $s3, $s3, $s4		#if curr char >= 0 && curr char <= 9
	
	beq $s3, $0, check_between_A_F	#if it's not between 0 - 9, move on to the next check
	#else it passes the test! move on the the next character by jumping to while2
	
	addi $s5, $s0, -48		#if it passes the test, add the numeric value to $t4
	sll $t4, $t4, 4
	add $t4, $t4, $s5
	j while2
	
check_between_A_F:
	li $s1, 'A'
	li $s2, 'F'
	
	sge $s3, $s0, $s1		#if curr char >= A
	sle $s4, $s0, $s2 		#if curr char <= F
	and $s3, $s3, $s4		#if curr char >= A && curr char <= F
	
	beq $s3, $0, check_between_a_f	#if it's not between A - F, move on to the next check
	
	addi $s5, $s0, -55
	sll $t4, $t4, 4
	add $t4, $t4, $s5
	j while2
	
check_between_a_f:
	li $s1, 'a'
	li $s2, 'f'
	
	sge $s3, $s0, $s1		#if curr char >= a
	sle $s4, $s0, $s2 		#if curr char <= f
	and $s3, $s3, $s4		#if curr char >= a && curr char <= f
	
	beq $s3, $0, print_invalid_arg_msg	#if it's not between a - f, print the err messages
	addi $s5, $s0, -87
	sll $t4, $t4, 4
	add $t4, $t4, $s5
	j while2
	
# convert a binary string in 2's complement to a decimal 	
string_to_decimal:
	li $a0, 0		# current decimal vlaue
	li $s4 0			# counter
	li $s5 32 		# max time the loops should run
	li $s1, '1'
	li $s2, '0'
	#also have $s3 we don't have ot initialize
	while1:
		lbu $t2, 0($t0)		# step 2: get the base address of the second argument, (first character)
		beq $t2, $0, print_number_result	# if we detect a null terminator, then we'll print the result
		addi $s4 $s4 1
		#if the current character is not 1, not null term., and not 0, then it's invalid
		slt $s3 $t2, $s2 	
		bne $s3, $0, print_invalid_arg_msg
		sgt $s3 $t2, $s1
		bne $s3, $0, print_invalid_arg_msg
		
		sll $a0, $a0, 1		# $a0 = $a0 * 2
		addi $t0, $t0, 1
		beq $t2, $s1, add_1	# if character = "1" then add the current value by 1
		j while1
	
add_1:
	addi $a0, $a0, 1 
	j while1

#Checks if AND 
#$a0 needs to have the result!!
print_number_result:
	#if the length is less than 1 or greater than 32, print error
	beqz $s4 print_invalid_arg_msg 
	bgt $s4 $s5 print_invalid_arg_msg 
	li $v0, 1
	syscall
	j done
	
print_args_err_msg:
	la $a0 args_err_msg
	li $v0, 4
	syscall
	j done	

print_invalid_arg_msg:
	la $a0 invalid_arg_msg
	li $v0, 4
	syscall
	j done	
print_invalid_hand_msg:
	la $a0 invalid_hand_msg
	li $v0 4
	syscall
	j done
done:
	li $v0 10
	syscall 
