addi	$t0, $0, 15			# $t0 = $0 + 15         $t0 = 15
equal:
addiu   $t1, $0, 15         # $t0 = $t0 + 15        $t1 = 15
beq     $t0, $t1, equal
add     $t0, $t0, $t1       # $t0 = $t0 + $t1       $t0 = 30
j test
add     $t0, $t0, $t1       # $t0 = $t0 + $t1       $t0 = 30
test:
addu    $t1, $t1, $t0       # $t1 = $t1 + $t0       $t1 = 45
and		$t2, $t0, $t1		# $t2 = $t0 & $t1       $t2 = 1
andi	$t2, $t2, 0			# $t2 = $t2 & 0         $t2 = 0
lui     $s1, 0x1001
lw		$t1, 0($s1)
nor		$t0, $t1, $t2		# $t0 = ~($t1 | $t2)
xor		$t0, $t1, $t2		# $t0 = $t1 ^ $t2
xori	$t0, $t1, 0			# $t0 = $t1 ^ 0
or		$t0, $t1, $t2		# $t0 = $t1 | $t2
ori		$t0, $t1, 0			# $t0 = $t1 | 0
slt		$t0, $s0, $s1		# $t0 = ($s0 < $s1) ? 1 : 0
slti	$t0, $s0, 0			# $t0 = ($s0 < 0) ? 1 : 0
sll		$t0, $t1, 0			# $t0 = $t1 << 0
srl		$t0, $t1, 0			# $t0 = $t1 >> 0
sw		$t1, 0($s1)
sub		$t0, $t1, $t2		# $t0 = $t1 - $t2
subu    $t0, $t1, $t2
bne		$t0, $t1, skip	# if $t0 != $t0 then target
addi    $t3, $t1, $t1
skip:

