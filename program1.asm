.data
	msg_1: .asciiz " x "
	msg_2: .asciiz " = "

.text
	#----------------------------------------------------
	# Rutina Principal
	#----------------------------------------------------
	main:
		# Inicializacion de variables
		li $s0, 9 # a=9
		li $s1, 7 # b=7
		
		move $a0, $s0 # $a0=a
		jal imprimir_integer # Llamada a subrutina imprimir_integer
		
		la $a0, msg_1 # Carga la direccion de la cadena de texto msg_1
		jal imprimir_string # Llamada a subrutina imprimir_string
		
		move $a0, $s1 # $a0=b
		jal imprimir_integer # Llamada a subrutina imprimir_integer
		
		la $a0, msg_2 # Carga la direccion de la cadena de texto msg_2
		jal imprimir_string # Llamada a subrutina imprimir_string
		
		move $a1, $s0 # $a1=a
		move $a2, $s1 # $a2=b
		jal multiplicacion # Llamada a subrutina multiplicacion
		
		move $a0, $v0 # $a0=$v0
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
		li $t1, 0 # result = 0
		for_loop:
			bge $t0, $a2, end_for_loop # i>=b -> end_for_loop
			addi $t0, $t0, 1 # i++ 
			add $t1, $t1, $a1 # $result += a 
			j for_loop # return
			
		end_for_loop:
			move $v0, $t1 # $v0 = result
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
