.data

.text

addi $5, $zero, 10
addi $4, $zero, 10
nop
nop
beq $5, $4, exit
nop
addi $4, $4, 1
exit:

halt
