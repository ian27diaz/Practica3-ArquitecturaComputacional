addi $t0,$zero,5

add $zero,$zero,$zero# NOP
add $zero,$zero,$zero# NOP

add $t1,$t0,$zero

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP

addi $t1,$t1,2

add $zero,$zero,$zero# NOP
add $zero,$zero,$zero#NOP

addi $t2,$t1,3

addi $t3, $t3, 0x1001

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP

sll $t3,$t3,16

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP

sw $t2,0($t3)

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP

add $s0,$t2,$t1

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP

sub $s1,$s0,$t3

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP

lw $t2, 0($t3)

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP

addi $s2,$t2,-2

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP

or $s2,$s2,$t4

add $zero,$zero,$zero#NOP
add $zero,$zero,$zero#NOP
 
sll $s7,$s2,2

exit:
