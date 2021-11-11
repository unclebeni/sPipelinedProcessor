addi	$t0, $0, 15			# $t0 = $0 + 15         $t0 = 15
addiu   $t1, $0, 15         # $t0 = $t0 + 15        $t1 = 15
add     $t0, $t0, $t1       # $t0 = $t0 + $t1       $t0 = 30
addu    $t1, $t1, $t0       # $t1 = $t1 + $t0       $t1 = 30
and		$t2, $t0, $t1		# $t2 = $t0 & $t1       $t2 = 1
andi	$t2, $t2, 0			# $t2 = $t2 & 0         $t2 = 0
lui
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
sra
sw		$t1, 0($s1)
sub		$t0, $t1, $t2		# $t0 = $t1 - $t2
subu    $t0, $t1, $t2
