.data
	msg_1: .asciiz "! = "
	error_no_positivo: .asciiz "Error! No se puede calcular el factorial de un numero negativo."

.text
	#----------------------------------------------------
	# Rutina Principal
	#----------------------------------------------------
	main:
		# Inicializacion de variables
		li $s0, -6 # fact=6
		move $t2, $s0 # value=fact
		sub $t3, $s0, 1 # count=value-1
		
		move $a0, $s0 # $a0=fact
		jal imprimir_integer # Llamada a subrutina imprimir_integer
		
		la $a0, msg_1 # Carga la direccion de la cadena de texto msg_1
		jal imprimir_string # Llamada a subrutina imprimir_string

		move $a0, $s0 # $a0=fact
		jal validacion_cero_o_positivo # Llamada a subrutina validacion_cero_o_positivo (fact=0 -> 1 | fact<=0 -> error)
		
		while:
			blt $t3, 1, end_while # count<1 -> end_while
			move $a1, $t2 # $a1=value
			move $a2, $t3 # $a2=count
			jal multiplicacion # Llamada a subrutina multiplicacion
			move $t2, $v0 # value=resultado de multiplicacion de $a1 y $a2
			sub $t3, $t3, 1 # count--
			j while # retorno
		
		end_while:
			move $a0, $t2 # $a0=value
			jal imprimir_integer # llamado subrutina imprimir_integer
		
		# Fin programa
		li $v0, 10 # Carga codigo 10 (exit) en $v0
		syscall # Termina el programa
		
	#----------------------------------------------------
	# Subrutina: multiplicacion
	# Args: $a1 (primer_multiplo), $a2 (segundo_multiplo)
	# Ret: $v0 ($a1*$a2)
	#----------------------------------------------------	
	multiplicacion:
		li $t0, 0 # i = 0
		li $t1, 0 # resultado = 0
		for_loop:
			bge $t0, $a2, end_for_loop # i>=b -> end_for_loop
			addi $t0, $t0, 1 # i++ 
			add $t1, $t1, $a1 # $resultado += a 
			j for_loop # retorno
			
		end_for_loop:
			move $v0, $t1 # $v0 = resultado
			jr $ra # Vuelve a rutina principal
			 
	#----------------------------------------------------
	# Subrutina: imprimir_integer
	# Args: $a0 (numero)
	# Efecto Secundario: Imprime numero
	#----------------------------------------------------
	imprimir_integer:
    		li $v0, 1 # Carga codigo 1 (print_int) en $v0
    		syscall # Imprime numero
    		jr $ra # Retorno
	
	#----------------------------------------------------
	# Subrutina: imprimir_string
	# Args: $a0 (msj)
	# Efecto Secundario: Imprime mensaje
	#----------------------------------------------------
	imprimir_string:
    		li $v0, 4 # Carga codigo 4 (print_string) en $v0
    		syscall # Imprime la cadena de texto
    		jr $ra # Retorno
	
	#----------------------------------------------------
	# Subrutina: validacion_cero_o_positivo
	# Args: $a0 (numero)
	# Efecto Secundario: Imprime mensaje y termina programa
	#----------------------------------------------------
	validacion_cero_o_positivo:
		beq $a0, $zero, fact_zero #$a0=0 -> fact_zero
		bltz $a0, end_programa #$a0<=0 -> end_programa
		jr $ra # Vuelve a rutina principal
		
		fact_zero:
			li $a0, 1 # $a0=1
			jal imprimir_integer # Llamada a subrutina imprimir_integer
			li $v0, 10 # Carga codigo 10 (exit) en $v0
			syscall # Termina el programa
		
		end_programa:
			la $a0, error_no_positivo # Carga la direccion de la cadena de texto error_cero
			jal imprimir_string # Llamada a subrutina imprimir_string
			li $v0, 10 # Carga codigo 10 (exit) en $v0
			syscall # Termina el programa