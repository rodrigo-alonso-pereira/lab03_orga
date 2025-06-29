.data
	sim_division: .asciiz " / "
	sim_igual: .asciiz " = "
	sim_punto: .asciiz "."
	error_cero: .asciiz "Error! No se puede dividir por cero."
	
.text
	#----------------------------------------------------
	# Rutina Principal
	#----------------------------------------------------
	main:
		# Inicializacion de variables
		li $s0, 17 # dividendo=17
		li $s1, 8 # divisor=8
		
		move $a0, $s0 # $a0=dividendo
		jal imprimir_integer # Llamada a subrutina imprimir_integer
		
		la $a0, sim_division # Carga la direccion de la cadena de texto sim_division
		jal imprimir_string # Llamada a subrutina imprimir_string
		
		move $a0, $s1 # $a0=divisor
		jal imprimir_integer # Llamada a subrutina imprimir_integer
		
		la $a0, sim_igual # Carga la direccion de la cadena de texto sim_igual
		jal imprimir_string # Llamada a subrutina imprimir_string
		
		move $a0, $s1 # $a0=divisor
		jal validacion_divisor # Llamada a subrutina validacion_divisor (divisor=0 -> error)
		
		move $a1, $s0 # $a1=dividendo
		move $a2, $s1 # $a2=divisor
		jal division # Llamada a subrutina division
		
		# Fin programa
		li $v0, 10 # Carga codigo 10 (exit) en $v0
		syscall # Termina el programa
		
	#----------------------------------------------------
	# Subrutina: division
	# Args: $a1 (dividendo), $a2 (divisor)
	# Ret: $v0 ($a1/$a2)
	#----------------------------------------------------	
	division:
		li $t0, 0 # cociente_entero=0
		move $t1, $a1 # resto_entero=dividendo
		move $t2, $a2 # $t2=divisor

		# Uso de pila para guardar $ra
		addi $sp, $sp, -4 # Reservar espacio en la pila
    	sw $ra, 0($sp) # Guardar $ra en ese espacio

		for_entero:
			blt $t1, $t2, end_for_entero # resto_entero<divisor -> end_for_entero
			addi $t0, $t0, 1 # cociente_entero++
			sub $t1, $t1, $t2 # resto_entero = resto_entero - divisor 
			j for_entero # return
			
		end_for_entero:
			move $a0, $t0 # $a0=cociente_entero
			jal imprimir_integer # llamado subrutina imprimir_integer (imprime cociente_entero)
		
		beq $t1, $zero, return # resto_entero=0 -> return (evalua si resto_entero es cero)
		la $a0, sim_punto # Carga la direccion de la cadena de texto sim_punto
		jal imprimir_string # Llamada a subrutina imprimir_string (imprime punto de parte decimal)
	
		move $a1, $t1 # $a1=resto_entero
		li $a2, 100 # $a2=100 (precision requerida para obtener dos decimales)
		jal multiplicacion # llamado subrutina multiplicacion (resto_entero*100)
		move $t1, $v0 # $t1=resto_decimal (resto_entero*100)
		li $t0, 0 # cociente_decimal=0

		for_decimal:
			blt $t1, $t2, end_for_decimal # resto_decimal<divisor -> end_for_decimal
			addi $t0, $t0, 1 # cociente_decimal++
			sub $t1, $t1, $t2 # resto_decimal = resto_decimal - divisor 
			j for_decimal # return
		
		end_for_decimal:	
			move $a0, $t0 # $a0=cociente_decimal
			jal imprimir_integer # llamado subrutina imprimir_integer (imprime cociente_decimal)
		
		return:
			lw $ra, 0($sp) # Cargar $ra desde la pila
    		addi $sp, $sp, 4 # Liberar el espacio en la pila
			jr $ra # Vuelve a rutina principal
		 
	#----------------------------------------------------
	# Subrutina: multiplicacion
	# Args: $a1 (primer_multiplo), $a2 (segundo_multiplo)
	# Ret: $v0 ($a1*$a2)
	#----------------------------------------------------	
	multiplicacion:
		li $t3, 0 # i = 0
		li $t4, 0 # resultado = 0
		for_loop:
			bge $t3, $a2, end_for_loop # i>=b -> end_for_loop
			addi $t3, $t3, 1 # i++ 
			add $t4, $t4, $a1 # $resultado += a 
			j for_loop # retorno
			
		end_for_loop:
			move $v0, $t4 # $v0 = resultado
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
	# Subrutina: validacion_divisor
	# Args: $a0 (numero)
	# Efecto Secundario: Imprime mensaje y termina programa
	#----------------------------------------------------
	validacion_divisor:
		beq $a0, $zero, end_programa #$a0=0 -> end_programa
		jr $ra # Vuelve a rutina principal
		
		end_programa:
			la $a0, error_cero # Carga la direccion de la cadena de texto error_cero
			jal imprimir_string # Llamada a subrutina imprimir_string
			li $v0, 10 # Carga codigo 10 (exit) en $v0
			syscall # Termina el programa