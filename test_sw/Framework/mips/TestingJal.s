.data

.text

addi $5, $zero, 10
addi $9, $zero, 10
jal stuff
nop

j exit

stuff:
addi $6, $zero, 1
addi $4, $4, 2
jr $31

exit:

halt
