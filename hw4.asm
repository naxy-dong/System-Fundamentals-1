######### Yuxiang Dong ##########
######### 114322553 ##########
######### yuxdong ##########

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
#takes in I and J as the total number of node possible in a network and the maximum no. of edges
#returns the address of the network
#creat network (5,10) returns the following
#5   (0 - 3 offset)
#10  (4 - 7 offset)
#0   (8 - 11 offset)			//no. of node currently in the network
#0   (12 - 15 offset)			//no. of edges currently in the network
#0 0 0 0 ... (16 - 35 offset)
#0 0 0 0 ... (36 - 76 offset)
.globl create_network
create_network:
  ###########################CHECK if a1 and a2 are negative ###############################
  sge $v0 $a0 $0
  beqz $v0 create_network_error
  sge $v0 $a1 $0
  beqz $v0 create_network_error

  ########################## Creat the network ###############################
  li $t0 16			#create 16 bytes for the 4 ints
  li $t1 4
  mul $t2 $a0 $t1		#allocate memory for the nodes
  add $t0 $t0 $t2
  mul $t2 $a1 $t1		#allocate memory for the edges
  add $t0 $t0 $t2
  
  move $t1 $a0
  move $a0 $t0
  li $v0, 9
  syscall 			#create the network and store the address in t0
  move $a0 $t1
  
  sw $a0 0($v0)
  sw $a1 4($v0)
  sw $0 8($v0)
  sw $0 12($v0)

  jr $ra

create_network_error:
  li $v0 -1
  jr $ra

# add person takes in $a0 as the network and $a1 as the name of the person

.globl add_person
add_person:
  #################### Preliminary checks for errors #######################
  ##### Case 1: the network is at its capacity
  lw $t0 0($a0)			#t0 is the max nodes
  lw $t1 8($a0)			#t1 is the current nodes
  beq $t0 $t1 v1_v0_error
  ##### Case 2: an empty string is passed as the name of the person
  lbu $t0 0($a1)
  beqz $t0 v1_v0_error
  ##### Case 3: The person with the name passed already exist
  lw $t3 8($a0)		# the current nodes in the network
  bnez $t3 check_person_exist
  
  #################### Begin add person #######################
  continue_add_person:
  #### Step1: figure our how much memory should we allocate
  
  #this for loop figures out how many characters are in the string
  li $t0 0		# counter for characters
  move $t1 $a1		# a dup reference for the string
  #t2 = current char
  for_string:
  	lbu  $t2 0($t1)		#get the current char
  	addi $t0 $t0 1		# counter ++
  	addi $t1 $t1 1		# next char
  	bnez $t2 for_string
  	
  #### Step2: creating the Node in the heap structure
  li $t2 4			#create 4 bytes for the 1 int
  add $t2 $t0 $t2		
  
  move $t1 $a0
  move $a0 $t2
  li $v0, 9
  syscall 			#create the node and store the address in t0
  move $a0 $t1

  #### Step3: Append information to the node
  addi $t0 $t0 -1
  sw $t0 0($v0)		# append the integer K
  move $t1 $a1		# move the string
  move $t0 $v0		# move the name part of the node
  addi $t0 $t0 4
  for_string1:
  	lbu  $t2 0($t1)		#get the current char
  	#addi $t0 $t0 1		# counter ++
  	sb $t2 0($t0)		# store the address of the string
  	addi $t1 $t1 1		# next char
  	addi $t0 $t0 1
  	bnez $t2 for_string1
  #### Step4: Append the node to the network
  lw $t0 8($a0)		#get the current no. of nodes in the network
  
  #calculate the current position of the node array
  li $t1 4
  li $t2 16
  
  mul $t3 $t0 $t1		# allocate memory for the nodes
  add $t3 $t3 $t2
  add $v1 $a0 $t3		# find the spot to insert the reference node
  sw $v0 0($v1)
  
  addi $t0 $t0 1
  sw $t0 8($a0)			#increase the current # of nodes by 1
  ################### Return v0 as network and 1 in v1 as success #######################
  move $v0 $a0 
  li $v1 1
  
  jr $ra
  
check_person_exist:
  move $t0 $a0		#create dup reference to network and the name
  addi $t0 $t0 16	#get to the nodelist section of the network
  li $t2 0		# counter

  for_node1:
  	lw $t4 0($t0)		#load the current node
  	addi $t4 $t4 4
  	move $t5 $t4		#load the name part of the current node
  	
  	addi $sp $sp -12
  	sw $ra 0($sp)
  	sw $a0 4($sp)
	sw $a1 8($sp)
  	move $a0 $t5
  	jal compare_strings
  	lw $ra 0($sp)
  	lw $a0 4($sp)
	lw $a1 8($sp)
  	addi $sp $sp 12
  	#if v0 is 1, then the name matches, and we should throw an error
  	bgtz $v0 v1_v0_error		
  	
  	addi $t0 $t0 4			#move on to the next node address
  	addi $t2 $t2 1
  	bne $t2 $t3 for_node1
  j continue_add_person
v1_v0_error:
  li $v1 -1
  li $v0 -1
  jr $ra

# parameters address of the network as a0 and address of the name in a1
.globl get_person
get_person:
  move $t0 $a0		#create dup reference to network and the name
  addi $t0 $t0 16	#get to the nodelist section of the network
  li $t2 0		# counter
  lw $t3 8($a0)		# the current nodes in the network
  
  beqz $t3 v1_v0_error		#if there's no node in the network, then automatic error
  
  for_node:
  	lw $t4 0($t0)		#load the current node
  	addi $t5 $t4 4		#load the name part of the current node
  	
  	addi $sp $sp -12
  	sw $ra 0($sp)
  	sw $a0 4($sp)
	sw $a1 8($sp)
  	move $a0 $t5
  	jal compare_strings
  	lw $ra 0($sp)
  	lw $a0 4($sp)
	lw $a1 8($sp)
  	addi $sp $sp 12
  	bgtz $v0 name_found		#if v0 is 1, then the name matches
  	
  	addi $t0 $t0 4			#move on to the next node address
  	addi $t2 $t2 1
  	bne $t2 $t3 for_node
  
  #no person is found 
  j v1_v0_error

name_found:
  move $t5 $a1 				#set its name to the input name
  move $v0 $t4 				#return address of the node to v0
  
  li $v1 1
  jr $ra

#takes in str1 in a0 and str2 in a1
#sets $v0 to 1 if equal, and -1 if not equal
compare_strings:
  addi $sp $sp -8
  sw $s0 0($sp)
  sw $s1 4($sp)
  for_compare_string:
  	lbu $s0 0($a0)
  	lbu $s1 0($a1)
  	sne $v0 $s0 $s1
  	bnez $v0 string_not_equal
  	addi $a0 $a0 1
  	addi $a1 $a1 1
  	bnez $s0 for_compare_string
  li $v0 1
  lw $s0 0($sp)
  lw $s1 4($sp)
  addi $sp $sp 8
  jr $ra

string_not_equal:
  li $v0 -1
  lw $s0 0($sp)
  lw $s1 4($sp)
  addi $sp $sp 8
  jr $ra

#takes in network address in a0, name1 address in a1, name2 address in a2, and relation type in a3
#relationship reference:
	# 0 - unknown
	# 1 - friendship
	# 2 - acquaintance
	# 3 - family
.globl add_relation
add_relation:
  #################### Preliminary checks for errors #######################
  ##### Case 1: the network is at its capacity, meaning the network is at its maximum capacity
  lw $t0 4($a0)		#max edge
  lw $t1 12($a0)		#curr edge  
  beq $t0 $t1 v1_v0_error
  ##### Case 2: if relationship type is not 0 <  relationship type < 3
  li $t1 3
  slt $t0 $a3 $0
  sgt $t1 $a3 $t1
  or $t0 $t0 $t1
  bnez $t0 v1_v0_error
  ##### Case 3: name1 == name2
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $a0 4($sp)
  sw $a1 8($sp)
  move $a0 $a1
  move $a1 $a2
  jal compare_strings
  lw $ra 0($sp)
  lw $a0 4($sp)
  lw $a1 8($sp)
  addi $sp $sp 12
  bgtz $v0 v1_v0_error		#if v0 == 1 then the names are equal
  ##### Case 4: If no person with name1 exists in the network
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $a0 4($sp)
  sw $a1 8($sp)
  jal get_person
  lw $ra 0($sp)
  lw $a0 4($sp)
  lw $a1 8($sp)
  addi $sp $sp 12
  bltz $v0 v1_v0_error	
  move $t8 $v0			#stores t0 as the address of the first node
  ##### Case 5: If no person with name2 exists in the network
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $a0 4($sp)
  sw $a1 8($sp)
  move $a1 $a2
  jal get_person
  lw $ra 0($sp)
  lw $a0 4($sp)
  lw $a1 8($sp)
  addi $sp $sp 12
  bltz $v0 v1_v0_error		#if v0 == 1 then the names are equal
  move $t9 $v0			#stores t1 as the address of the second node
  ##### Case 6: A relation between a person with name1 and a person with name2 
  #already exists in the network.
  lw $t2 12($a0)
  bnez $t2 check_relation_exists
  #################### Begin add edge #######################
  continue_add_edge:
  #creating the edge structure
  move $t2 $a0
  li $a0 12
  li $v0, 9
  syscall 			#create the edge and store the address in v0
  move $a0 $t2
  move $t2 $v0
  #storing the values to the edge structure
  sw $t8 0($t2)
  sw $t9 4($t2)
  sw $a3 8($t2)
  #storing the edge structure to the network
  move $t0 $a0 			#create a dup reference to the network
  lw $t1 0($a0)			# get the max node
  addi $t0 $t0 16		# go to the node list section
  li $t3 4
  mul $t1 $t1 $t3		# calculate for far should we go 
  add $t0 $t0 $t1		# go PAST The node list section / AKA the edge list section
  lw $t1 12($a0)			# get the curr no. of edges
  mul $t1 $t1 $t3
  add $t0 $t0 $t1		# go to the latest edge section
  sw $t2 0($t0)			# store the edge to the network
  
  lw $t1 12($a0)			
  addi $t1 $t1 1			
  sw $t1 12($a0)			# update the curr no. of edges
  
  move $v0 $a0
  li $v1 1
  jr $ra

#takes in network a0, node address a1, and node address a2
check_relation_exists:
  move $t0 $a0 			#create a dup reference to the network
  lw $t1 0($a0)			# get the max node
  addi $t0 $t0 16		# go to the node list section
  li $t2 4
  mul $t1 $t1 $t2		# calculate for far should we go 
  add $t0 $t0 $t1		# go PAST The node list section / AKA go to the edge list section

  #now that we're in the edge list section, going to iterate through each edge
  lw $t1 12($a0)			# get the curr no. of edges
  li $t2 0			# edge counter
  for_edge:
  	lw $t3 0($t0)		# get the current edge reference
  	lw $t4 0($t3)		# get the first node
  	lw $t5 4($t3)		# get the second node
  	
  	seq $t6 $t4 $t8
  	seq $t7 $t5 $t9
  	and $t6 $t6 $t7
  	seq $t4 $t4 $t9		#it's bidirectional
  	seq $t5 $t5 $t8
  	and $t4 $t4 $t5
  	or $t6 $t6 $t4
  	bnez $t6 v1_v0_error	#if the relation is found, we have an error
  	
  	addi $t0 $t0 4 
  	addi $t2 $t2 1
  	bne $t2 $t1 for_edge
  j continue_add_edge

#takes in network in a0 and person's name in a1
#returns linkedlist in v0
#use breath-first search algorithm to solve this problem
.globl get_distant_friends
get_distant_friends:
  addi $sp $sp -8
  sw $s0 0($sp)
  sw $s1 4($sp)
  #s0 should be the head of the reference
  li $s0 0
  
  ############################## PRELIMINARY SETUP ##################################
  move $t0 $a0 			# create a dup reference to the network
  lw $t1 0($a0)			# get the max node
  addi $t0 $t0 16		# go to the node list section
  li $t2 4
  mul $t1 $t1 $t2		# calculate for far should we go 
  add $t0 $t0 $t1		# go PAST The node list section / AKA go to the edge list section
  move $t9 $t0			#dup reference
  
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $a0 4($sp)
  sw $a1 8($sp)
  jal get_person
  lw $ra 0($sp)
  lw $a0 4($sp)
  lw $a1 8($sp)
  addi $sp $sp 12
  bltz $v0 person_not_exist	
  
  move $t1 $v0			#stores t1 as the address of the node with the name
  ############################## Depth first search ##################################
  move $s1 $sp
  move $fp $sp		#have one going up, one going down
  addi $fp $fp 4
  sw $t1 0($fp)
  
  lw $t3 12($a0)		# current number of edges in the network
  beqz $t3 no_distant_friend	#if there's no edges
  ############################ FIRST ROUND CHECK #################################
  lw $t2 0($fp)		# current node
  addi $fp $fp -4
  move $t0 $t9		# reset address
  li $t4 0		# reset counter
  for_get_neighbors1:
  		#if either one of the edge contains the node, then we have the neighbor
  		lw $t5 0($t0)		#get the current edge node
  		lw $t6 0($t5)		#node1 of the edge node
  		lw $t8 8($t5)		#get the relationship of the edge
  		li $t7 1
  		seq $t7 $t8 $t7		#checks for friend relationship
  		seq $t8 $t6 $t2		#checks for if the node1 is equal to the current node 
  		and $t7 $t7 $t8
  		bnez $t7 appendNode22	#append the node2 to the stack
  		
  		lw $t6 4($t5)		#node2 of the edge node
  		li $t7 1
  		lw $t8 8($t5)		#get the relationship of the edge
  		seq $t7 $t8 $t7		#checks for friend relationship
  		seq $t8 $t6 $t2		#checks for if the node2 is equal to the current node 
  		and $t7 $t7 $t8
  		bnez $t7 appendNode11	#append the node1 to the stack
  		j increment1
  ############################### Begin the real loop #################################
  while:
  	lw $t2 0($fp)		#current node
  	addi $fp $fp -4
  	#we should not append a node to the Linkedlist if the node has direct edge to the input name
  	addi $sp $sp -12
  	sw $ra 0($sp)
  	sw $a0 4($sp)
  	sw $a1 8($sp)
  	move $a0 $t2 
  	move $a1 $t1			#t1 is the target node
  	jal node_is_friend_to_target
  	lw $ra 0($sp)
  	lw $a0 4($sp)
  	lw $a1 8($sp)
  	addi $sp $sp 12
  	bnez $v0 skip
  	
  	####################### appending the node to the linkedlist #############################
	lw $t6 0($t2)		# the length of the name
	addi $t6 $t6 1		# the length with the \0
  	
  	move $t7 $a0
  	move $a0 $t6		# the amount of memory
  	li $v0, 9
  	syscall 			#create the friendNode and store the address in v0
  	move $a0 $t7 
  	
  	move $t8 $v0		# create a separate reference to the linkedlist
  				#stores the name to the friendnode
  	addi $t6 $t2 4		#the name address of popped node
  	
  	for_string3:
  		lbu $t7 0($t6)		# get the current char
  		sb $t7 0($v0)		# store the address of the string
  		addi $v0 $v0 1		# next char
  		addi $t6 $t6 1
  		bnez $t7 for_string3
  		
  	move $t7 $a0
  	li $a0 4
  	li $v0, 9
  	syscall
  	move $a0 $t7
  	
  	sw $s0 0($v0) 		#store the linkedlist to the address of the new friendNode
  	move $s0 $t8		#update the new head

  	############### deciding what node to append to the stack ########################
  	skip:
  	move $t0 $t9	# reset address
  	li $t4 0		# reset counter
  	for_get_neighbors:
  		#if either one of the edge contains the node, then we have the neighbor
  		lw $t5 0($t0)		#get the current edge node
  		lw $t6 0($t5)		#node1 of the edge node
  		lw $t8 8($t5)		#get the relationship of the edge
  		li $t7 1
  		seq $t7 $t8 $t7		#checks for friend relationship
  		seq $t8 $t6 $t2		#checks for if the node1 is equal to the current node 
  		and $t7 $t7 $t8
  		bnez $t7 appendNode2	#append the node to the stack
  		
  		lw $t6 4($t5)		#node2 of the edge node
  		li $t7 1
  		lw $t8 8($t5)		#get the relationship of the edge
  		seq $t7 $t8 $t7		#checks for friend relationship
  		seq $t8 $t6 $t2		#checks for if the node2 is equal to the current node 
  		and $t7 $t7 $t8
  		bnez $t7 appendNode1	#append the node to the stack
  		j increment
  	continue_while:
  	bne $fp $sp while
  move $v0 $s0			#move the linkedlist to the return value
  beqz $s0 no_linkedlist_returned

  lw $s0 0($sp)
  lw $s1 4($sp)
  addi $sp $sp 8

  jr $ra
  no_linkedlist_returned:
  li $v0 -1 
  lw $s0 0($sp)
  lw $s1 4($sp)
  addi $sp $sp 8
  jr $ra
  
person_not_exist:
  li $v0 -2
  lw $s0 0($sp)
  lw $s1 4($sp)
  addi $sp $sp 8
  jr $ra
  
no_distant_friend:
  li $v0 -1
  lw $s0 0($sp)
  lw $s1 4($sp)
  addi $sp $sp 8
  jr $ra

increment1:
  addi $t4 $t4 1
  addi $t0 $t0 4
  bne $t4 $t3 for_get_neighbors1
  
  ####### If it has no friends like me :(, then exit out of the program ##########
  beq $fp $s1 no_distant_friend	#if there's no friend
  j while
appendNode22:  
  lw $t6 4($t5)		#node2 address of the edge node
  addi $fp $fp 4
  sw $t6 0($fp)		#store node2 in to the stack
  j increment1
appendNode11:
  ####################### appending the node to the stack ############################
  lw $t6 0($t5)		#node2 address of the edge node
  addi $fp $fp 4
  sw $t6 0($fp)		#store node2 in to the stack
  j increment1
increment:
  addi $t4 $t4 1
  addi $t0 $t0 4
  bne $t4 $t3 for_get_neighbors
  j continue_while

#appends node2 to the linkedlist 
appendNode2:
  ####################### Preliminary Checks #############################
  # we can t6 to t8 without any side effects
  addi $sp $sp -8
  sw $ra 0($sp)
  sw $a0 4($sp)	
  lw $a0 4($t5)		#node2 address of the edge node
  jal isVisited
  lw $ra 0($sp)
  lw $a0 4($sp)
  addi $sp $sp 8
  #we should not append a node to the STACK if it's already visited
  bnez $v0 increment 
  ####################### appending the node to the stack ############################
  lw $t6 4($t5)		#node2 address of the edge node
  addi $fp $fp 4
  sw $t6 0($fp)		#store node2 in to the stack
  j increment

appendNode1:
  ####################### Preliminary Checks #############################
  # we can t6 to t8 without any side effects
  addi $sp $sp -8
  sw $ra 0($sp)
  sw $a0 4($sp)
  lw $a0 0($t5)		#node1 of the edge node
  jal isVisited
  lw $ra 0($sp)
  lw $a0 4($sp)
  addi $sp $sp 8
  #we should not append a node to the STACK if it's already visited
  bnez $v0 increment
  ####################### appending the node to the stack ############################
  lw $t6 0($t5)		#node1 address of the edge node
  addi $fp $fp 4
  sw $t6 0($fp)		#store node2 in to the stack
  j increment

#checks if a node is visited or not, returns 1 if it's visited and 0 if it's not visited
#takes in the node as $a0
isVisited:
  li $v0 0
  #1. the node has the input name
  beq $t1 $a0 node_visited
  
  #2. it's already been appended to the stack 
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $a0 4($sp)
  sw $a1 8($sp)
  #a0 is the way it is
  move $a1 $fp			#sp is the stack pointer
  jal node_in_stack
  lw $ra 0($sp)
  lw $a0 4($sp)
  lw $a1 8($sp)
  addi $sp $sp 12
  bnez $v0 node_visited
  
  #3. it's on the linkedlist already
  addi $sp $sp -12
  sw $ra 0($sp)
  sw $a0 4($sp)
  sw $a1 8($sp)
  #a0 is the way it is
  move $a1 $s0			#s0 is the linkedlist
  jal node_in_linkedlist
  lw $ra 0($sp)
  lw $a0 4($sp)
  lw $a1 8($sp)
  addi $sp $sp 12
  bnez $v0 node_visited

  jr $ra	         #it has not been visited
  node_visited:
  li $v0 1
  jr $ra

#check if the node already exist in stack
#takes in the node $a0 and a copy of the stack pointer in $a1
node_in_stack:
  addi $sp $sp -4
  sw $s0 0($sp)
  
  beq $s1 $a1 node_not_in_stack
  while_stack:
  	lw $s0 0($a1)		#current node
  	beq $a0 $s0 node_exist_in_stack
  	addi $a1 $a1 -4
  	bne $s1 $a1 while_stack
  node_not_in_stack:
  li $v0 0
  lw $s0 0($sp)
  addi $sp $sp 4
  jr $ra
  node_exist_in_stack:
  li $v0 1
  lw $s0 0($sp)
  addi $sp $sp 4
  jr $ra
  
#check if the node already exist in stack
#takes in the node $a0 and linkedlist in $a1
node_in_linkedlist:
  addi $sp $sp -16
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  sw $s3 12($sp)
  li $v0 0
  beq $s0 $0 no_node_exist_in_linkedlist	#if the list is empty
  for_node_in_list:
  	#check if the name is equal to the name in node $a0
  	addi $s1 $a0 4		#name from the node
  	move $s2 $s0		#name from the linkedlist node 
  	addi $sp $sp -12
  	sw $ra 0($sp)
  	sw $a0 4($sp)
  	sw $a1 8($sp)
  	move $a0 $s1
  	move $a1 $s2
  	jal compare_strings
  	lw $ra 0($sp)
  	lw $a0 4($sp)
  	lw $a1 8($sp)
  	addi $sp $sp 12
  	bgtz $v0 node_exist_in_linkedlist		#if v0 == 1 then the names are equal
  	
  	#this for loop figures out how many characters are in the string
  	li $s1 0		# counter for characters
  	move $s2 $s0		# a dup reference for the string
  	#t2 = current char
  	for_string4:
  		lbu  $s3 0($s2)		#get the current char
  		addi $s1 $s1 1		# counter ++
  		addi $s2 $s2 1		# next char
  		bnez $s3 for_string4	# 
  	li $s2 4
  	div $s1 $s2
  	mflo $s3
  	mfhi $s1
  	mul $s2 $s2 $s3
  	beqz $s1 skip_plus4
  	addi $s2 $s2 4
  	skip_plus4:
  	add $s0 $s0 $s2
  	lw $s0 0($s0)
  	bnez $s0 for_node_in_list
  	
  no_node_exist_in_linkedlist:
  li $v0 0
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $s3 12($sp)
  addi $sp $sp 16
  jr $ra
  node_exist_in_linkedlist:
  li $v0 1
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $s3 12($sp)
  addi $sp $sp 16
  jr $ra
  	
#returns true if the node is the input name or the neighbor of the input name
#takes in the node $a0 and the target node in $a1
node_is_friend_to_target:
  addi $sp $sp -12
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  li $s0 1
  move $s1 $t9		# reset address
  li $s2 0		# reset counter
  
  beqz $t3 not_friend
  for_edge_list1:
  	#if either one of the edge contains the node, then we have the neighbor
  	lw $t5 0($s1)		#get the current edge node
  	lw $t6 0($t5)		#node1 of the edge node
  	lw $t7 4($t5)		#node2 of the edge node
  	lw $t8 8($t5)		#get the relationship of the edge
  	seq $v0 $t8 $s0		#checks for friend relationship
  	seq $t6 $t6 $a0		#checks for if the node1 is equal to the current node 
  	seq $t7 $t7 $a1
  	and $v0 $v0 $t6
  	and $v0 $v0 $t7
  	bnez $v0 is_friend
  	
  	lw $t6 0($t5)		#node1 of the edge node
  	lw $t7 4($t5)		#node2 of the edge node
  	seq $t7 $t7 $a0		#checks for if the node2 is equal to the current node 
  	seq $t6 $t6 $a1
  	seq $v0 $t8 $s0
  	and $v0 $v0 $t6
  	and $v0 $v0 $t7
  	bnez $v0 is_friend
  	
  	addi $s1 $s1 4
  	addi $s2 $s2 1
  	bne $s2 $t3 for_edge_list1
  not_friend:
  li $v0 0
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  addi $sp $sp 12
  jr $ra	
  is_friend:
    li $v0 1
    lw $s0 0($sp)
    lw $s1 4($sp)
    lw $s2 8($sp)
    addi $sp $sp 12
    jr $ra
