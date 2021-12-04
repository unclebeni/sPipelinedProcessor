.data
temp: .word -23 # declare storage for temp; initial value is -23
.text
.globl main

main:
    # Start Test
    lw $t0, temp # load contents of RAM location into register $t0:  $t0 = var1
    lui $t1, 4097	 # $t1 = 5   ("load immediate")
    nop
    nop
    sw $t1, temp # store contents of register $t1 into RAM:  var1 = $t1
    # End Test

    # Exit program
    halt
    li $v0, 10
    syscall
