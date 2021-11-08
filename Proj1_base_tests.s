addi	$t0, $0, 15			# $t0 = $0 + 15         $t0 = 15
addiu   $t1, $0, 15         # $t0 = $t0 + 15        $t1 = 15
add     $t0, $t0, $t1       # $t0 = $t0 + $t1       $t0 = 30
addu    $t1, $t1, $t0       # $t1 = $t1 + $t0       $t1 = 30
and		$t2, $t0, $t1		# $t2 = $t0 & $t1       $t2 = 1
andi	$t2, $t2, 0			# $t2 = $t2 & 0         $t2 = 0


