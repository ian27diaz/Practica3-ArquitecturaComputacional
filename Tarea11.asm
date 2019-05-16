.text
#addi $sp, $sp, 0x03FC
addi $t0, $zero, 5
add $t1, $t0, $zero
addi $t1, $t1, 2
addi $t2, $t1, 3
addi $t3, $t3, 0x1001
sll $t3,$t3,16
sw $t2, 0($t3)

add $s0, $t2, $t1
sub $s1, $s0, $t3
lw $t2, 0($t3)
addi $s2, $t2, -2
or $s2, $s2, $t4
sll $s7, $s2, 2
#Lo siguiente es para ver que el flujo del programa siga
#cuando pasan slls y srls.
addi $t0, $zero, 5
add $zero, $zero, $zero
add $t1, $t0, $zero
addi $t1, $t1, 2
addi $t2, $t1, 3
#Programa sin hazards


exit:
