add     $t0, $0, $0
addi    $t1, $0, 15 
addiu   $t2, $0, 15
sub     $t3, $t3, $t3
addu    $t0, $t0, $t1
and     $t4, $t1, $t1
andi    $t5, $t2, 15
j test
andi    $t5, $t2, 15
test:
lui     $t1, 0x1001
nor     $t0, $t0, $t2
xor     $t3, $t2, $t3
xori    $t4, $t4, $t5
lw      $t2, 4($t1)
subu    $t0, $t0, $t0
sw      $t1, 0($t3)
or      $t5, $t3, $0
ori     $t4, $t4, $t3
beq     $t0, $0 zero
slt     $t0, $t0, $t0
zero:
slt     $t1, $t1, $t2
slti    $t2, $t2, 3
sll     $t3, $t3, 4
srl     $t4, $t4, 4
bne     $t5, $0, exit
add     $t0, $t0, $t0
exit:
