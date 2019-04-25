#Team members: 
#Ian Ricardo Díaz Meda
#Luis Joaquín Ávalos Guzmán

.text

main:
	
	addi $sp, $zero, 0x1001
	sll $sp, $sp, 16
	addi $sp, $sp, 0x03FC
	
	addi $s0, $zero, 3 #Number of discs
	#initializing pointers
	addi $s5, $zero,0x1001 #s5 -> origin tower
	sll $s5, $s5, 16
	
	addi $s6, $zero,0x1001 #s6 -> dist tower
	sll $s6, $s6, 16
	add $s6, $s6, 0x0020
	
	addi $s7, $zero,0x1001 #s7 -> aux tower
	sll $s7, $s7, 16
	add $s7, $s7, 0x0040
		
	add $s5, $s5, -4
	add $s6, $s6, -4
	add $s7, $s7, -4
	
	#loading Discs in first tower ...
	add $t0, $zero, $s0
	loop_LD: 
	add $s5, $s5, 4
	sw $t0, 0($s5)
	addi, $t0, $t0, -1
	bne $t0, $zero, loop_LD
		
	#prepping arguments of Hanoi
	add $a0, $zero, $s0 
	add $a1, $zero, $s5 
	add $a2, $zero, $s7
	add $a3, $zero, $s6
	jal Hanoi
	j exit
	#Hanoi(int n, Stack org, Stack dest, Stack aux);
	#n    => #a0
	#org  => #a1
	#dest => #a2
	#aux  => #a3
Hanoi:
	addi $sp, $sp, -8
	#sw $a0, 0($sp)
	sw $ra, 4($sp)
	beq $a0, 1, baseCase #if (n == 1) { baseCase}
	
	#else (casoInductivo) {
	
	addi $a0,$a0,-1 # n = n - 1
	sw $a0, 0($sp)
	
	#en este primer paso del caso en esta llamada el origen siempre es el mismo pero cambios en la torres aux y dest
	#en cada llamada aux será dest y dest será aux variando en los casos en que llame esta función
	#n => #a0

	#Cambiando apuntadores de pilas
	add $t7,$zero,$a2 # t7  = destino
	add $a2,$zero,$a3 #dest = aux
	add $a3,$zero,$t7 #aux  = destino
	
	#Llamando a Hanoi(n-1,org,aux,dest)
	jal Hanoi
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	
	add $t7, $zero, $a2 #ty = aux
	add $a2, $zero, $a3 #aux = dest
	add $a3, $zero, $t7 #dest = aux
	#dest.push(o.pop());
	lw $t8,0($a1) # $t8 = o.pop();
	sw $zero,0($a1)
	addi $a1,$a1,-4
	addi $a2,$a2,4
	sw $t8,0($a2)#d.push($t8);
	
	#sw $a0, 0($sp)
	#sw $ra, 4($sp)
	#en este paso del caso en esta llamada el dest siempre es el mismo pero habrá cambios en las torres aux y orig
	#en cada llamada aux será orig y origin será aux variando en los casos en que llame esta función
	add $t7,$zero,$a1 #t7 = org
	add $a1,$zero,$a3 #org = aux
	add $a3,$zero,$t7 #aux = org
		
	jal Hanoi #hanoi(n-1,aux,dest,origin)
	
	add $t7, $zero, $a1 #ty = aux
	add $a1, $zero, $a3 #aux = dest
	add $a3, $zero, $t7 #dest = aux
	j endHanoi
	#} //End of Else
	
	baseCase:
	#Mov disc from orig to dest
	lw $t8,0($a1) # $t8 = o.pop();
	sw $zero,0($a1)
	addi $a1,$a1,-4
	addi $a2,$a2,4
	sw $t8,0($a2)#d.push($t8);
	
	endHanoi:
	#terminando Hanoi
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra	
exit:
	
