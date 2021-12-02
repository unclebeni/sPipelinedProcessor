


#say the array address location is stored in $s0
#say the array size is located in $s1

#this is the main body of the bubble sort algorithm implementation
.data

array: .word 3, -1, 2, -4



lui $s0, 0x1003

la $s0, array

#initialize the array ^^^^^^^^^^

#begin

addu $t1 $zero, $zero	#initialize i
addi $t7 $t7, -1		#t7 will be n-1

j loop1:

loop0:

addi $t1, $t1, 1

loop1:
	addu $t6, $zero, $zero   #j = 0
	addu $t2, $s0, $zero #t2 = &arr
	
	add $zero, $zero, $zero #nop

	slt $t2, $t1, $t7 
	beq $t2, $zero exit(?) #while  i < n-1	

	add $zero, $zero, $zero #nop  

loop2:  

	sub $t5. $t7, $t1  # n - i - 1
	slt $t2, $t6, $t5

	add $zero, $zero, $zero #nop

	bne $t2, $zero loop0	#while j < n-1-i 

	add $zero, $zero, $zero #nop

	addu $t2, $s0, $t6  #current array address... &arr + j

	lw $t3, (0)$t2 #load array [j]
	lw $t4, (4)$t2 #load array [j+1]

	slt $t2, $t3, $t4 
	beq $t2, $zero point #if t4 >= t3 then start the loop again, otherwise swap then loop

	add $zero, $zero, $zero #nop

	add $t2, $t4, $zero 
	add $t4, $t3, $zero  #swap

	add $zero, $zero, $zero #nop	

	add $t3, $t2, $zero

point: 
	addi $t6, $t6, 1
	addu $t2, $t2, 4 #j + #arr
	j loop2          #loop back

exit:

	halt
