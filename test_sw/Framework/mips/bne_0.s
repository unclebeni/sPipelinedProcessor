# This test determines if the bne instruction will branch since both register will not be equal to each other.
# This has value since it determines if the instruction is working properly before the following tests.
# The end value of $8 should be 1, since it should never have it's value changed.

.data
.text
.globl main
main:
	# Start Test
	addi $8, $0, 1
	nop
	nop
	nop
	bne $8, $0, exit
	nop
	nop
	nop
	addi $8, $8, 1

	
exit:
	# Exit program
	halt
	li $v0, 10
	syscall
