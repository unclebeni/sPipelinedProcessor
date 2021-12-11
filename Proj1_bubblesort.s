


#say the array address location is stored in $s0
#say the array size is located in $s1

#this is the main body of the bubble sort algorithm implementation

lui $s0, 0x1001
addi $t0, $zero, -3
addi $t1, $zero, 3
addi $t2, $zero, 2
addi $t3, $zero,  -4

addi $s1, $zero, 4
nop

sw $t0, 0($s0)
sw $t1, 4($s0)
sw $t2, 8($s0)
sw $t3, 12($s0)

#initialize the array ^^^^^^^^^^

#begin

addu $t1 $zero, $zero	#initialize i
addi $t7 $t7, -1		#t7 will be n-1

j loop1
nop
loop0:

addi $t1, $t1, 1

loop1:
	addu $t6, $zero, $zero   #j = 0
	addu $t2, $s0, $zero #t2 = &arr
	nop
	slt $t0, $t1, $t7 
	nop
	nop
	bne $t2, $zero exit #while  i < n-1	
	nop
	nop

loop2:  

	sub $t5, $t7, $t1  # n - i - 1
	nop
	nop
	slt $t0, $t6, $t5
	nop
	nop
	nop
	bne $t0, $zero, loop0	#while j < n-1-i 
	nop
	addu $t2, $s0, $t6  #current array address... &arr + j
	nop
	nop
	lw $t3, 0($t2) #load array [j]
	lw $t4, 4($t2) #load array [j+1]
	nop
	nop
	nop

	slt $t0 $t3, $t4 
	nop
	nop
	nop
	beq $t0, $zero point #if t4 >= t3 then start the loop again, otherwise swap then loop
	nop
	add $t2, $t4, $zero 
	nop
	add $t4, $t3, $zero  #swap
	nop
	add $t3, $t2, $zero
	nop

point: 
	addi $t6, $t6, 1
	nop
	addu $t2, $t2, 4 #j + #arr
	j loop2          #loop back
	nop
exit:

	halt
