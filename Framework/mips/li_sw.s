.data
temp: .word -23 # declare storage for temp; initial value is -23
.text
.globl main

main:
    # Start Test
    lui $s0, 4097
    li $s2, 1 # load contents of RAM location into register $t0:  $t0 = var1
    sw $s2, 0($s0) # store contents of register $t1 into RAM:  var1 = $t1
    sw $s2, 4($s0)
    # End Test

    # Exit program
    halt
    li $v0, 10
    syscall
