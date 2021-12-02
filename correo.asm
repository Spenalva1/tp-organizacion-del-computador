global main
extern printf
extern gets
extern sscanf

section .data
  	mensajeCantidadDeObjetos    db  				'Ingrese un entero indicando cuantos objetos se van a ingresar (entre 1 y 20 inclusive): ',0
  	mensajeErrorCantidad	    db  				'Numero no valido.',10,0
  	mensajeDestinosPosibles	    db  				'Los destinos posibles para los objetos son: ',10,0
  	mensajeDestinoPosible	    db  				'  -  %c -> %s',10,0
  	mensajeInstructivo	    	db  				'Los objetos deben ser ingresados con el siguiente formato: "PESO DESTINO". Para el peso ingresar un entero entre 1 y 15 inclusive. Para el destino ingresar una de las iniciales anteriormente listadas.',10,0
  	mensajeIngresarObjeto	   	db  				'Ingresar objeto: ',0
  	mensajeFormatoNoValido	   	db  				'Formato del objeto no valido',10,0
  	mensajePesoNoValido	   		db  				'El peso ingresado no es valido',10,0
  	mensajeDestinoNoValido	   	db  				'El destino ingresado no es valido',10,0
  	mensajeSeparador		   	db  				'==================================================',10,0
  	mensajeGuion			   	db  				' - ',0
  	mensajeSuma			   		db  				' + ',0
  	mensajeSaltodeLinea			db  				'',10,0

	numeroFormato				db					'%hi',0
	objetoIngresadoFormato		db					'%hi %c',0

	destinos					db					'PST',0
	destinosLista				db					'Posadas         ',0
								db					'Salta           ',0
								db					'Tierra del Fuego',0

	destinoNumero				db					0

	objetos						times 60 dw			0	; 20 objetos por cada destino 20 x 3 = 60
														; representa una matriz donde cada fila es un destino y cada columna un objeto
														; Fila 1 -> Posadas
														; Fila 2 -> Salta
														; Fila 3 -> Tierra del Fuego

	cantidades					times 3  db			0	; 1 cantidad por cada destino 1 x 3 = 3

	objetoAuxDesplazamiento		dw					0
	objetoAux					dw					0
	contadorDestino				db					0

section .bss
	cantidadObjetosIngresado	resb	10
	objetoIngresado				resb	10
	cantidadObjetos				resw	1
	destinoIngresadoNumero		resw	1
	datoValido					resb	1
	objetoIngresadoPeso			resw	1
	objetoIngresadoDestino		resb	1
	direccionInicial			resq	1
	direccionFinal				resq	1
	cantidadActual				resb	1
	sumaPaquete					resw	1

section .text
main:
	call 	ingresarCantidadDeObjetos

	call 	ingresarObjetos

	call	mostrarPaquetes
ret

;------------------------------------------------------
;------------------------------------------------------
;   RUTINAS INTERNAS
;------------------------------------------------------
;------------------------------------------------------

;------------------------------------------------------
;   Pide al usuario que ingrese por pantalla la cantidad de objetos que se van a ingresar
;------------------------------------------------------
ingresarCantidadDeObjetos:
	mov 	rcx,mensajeCantidadDeObjetos
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov		rcx,cantidadObjetosIngresado
	sub		rsp,32
	call	gets
	add		rsp,32

	mov 	rcx,cantidadObjetosIngresado
	mov		rdx,numeroFormato
	mov 	r8,cantidadObjetos
	sub		rsp,32
	call	sscanf
	add		rsp,32

	cmp		rax,1
	jl		errorIngresoCantidad

	call 	validarCantidad
	cmp		byte[datoValido],'N'
	je		errorIngresoCantidad

	jmp 	finIngresoCantidad

errorIngresoCantidad:
	mov 	rcx,mensajeErrorCantidad
	sub 	rsp,32
	call 	printf
	add 	rsp,32
	jmp 	ingresarCantidadDeObjetos
finIngresoCantidad:
ret

;------------------------------------------------------
;   Valida si la cantidad ingresada por el usuario es válida
;------------------------------------------------------
validarCantidad:
	mov		byte[datoValido],'N'

	cmp		word[cantidadObjetos],1
	jl		finValidarCantidad

	cmp		word[cantidadObjetos],20
	jg		finValidarCantidad

	mov		byte[datoValido],'S'

finValidarCantidad:
ret


;------------------------------------------------------
;   Pide al usuario que ingrese n objetos
;------------------------------------------------------
ingresarObjetos:
	call listarDestinosPosibles

	mov 	rcx,mensajeInstructivo
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov		rcx,0
	mov		cx,[cantidadObjetos]
ingresarObjeto:
	push	rcx

	mov 	rcx,mensajeIngresarObjeto
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov		rcx,objetoIngresado
	sub 	rsp,32
	call 	gets
	add 	rsp,32

	call	validarObjetoIngresado
	cmp		byte[datoValido],'S'
	je		guardarObjetoIngresado

	pop 	rcx
	jmp 	ingresarObjeto

guardarObjetoIngresado:
	call guardarObjeto
	pop 	rcx
	loop 	ingresarObjeto
ret

;------------------------------------------------------
;   Muestra en pantalla los destinos posibles para los objetos
;------------------------------------------------------
listarDestinosPosibles:
	mov 	rcx,mensajeDestinosPosibles
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov		rcx,3
	mov		rsi,0
	mov		rdi,0
mostrarDestinoPosible:
	push	rcx

	mov		rdx,0
	mov 	rcx,mensajeDestinoPosible
	mov 	dl,byte[destinos+rsi]
	lea 	r8,[destinosLista+rdi]
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	pop 	rcx

	add		rsi,1
	add		rdi,17

	loop 	mostrarDestinoPosible
ret

;------------------------------------------------------
;   Valida el objeto ingresado por el usuario detallando en pantalla en caso de algún error
;------------------------------------------------------
validarObjetoIngresado:
	mov		byte[datoValido],'N'

	mov 	rcx,objetoIngresado
	mov		rdx,objetoIngresadoFormato
	mov 	r8,objetoIngresadoPeso
	mov 	r9,objetoIngresadoDestino
	sub		rsp,32
	call	sscanf
	add		rsp,32
	cmp		rax,2
	jl		formatoNoValido

	call 	validarDestinoIngresado
	cmp		byte[datoValido],'N'
	je		destinoNoValido

	call 	validarPesoIngresado
	cmp		byte[datoValido],'N'
	je		pesoNoValido

	mov		byte[datoValido],'S'
	jmp 	finValidacionObjeto

formatoNoValido:
	mov 	rcx,mensajeFormatoNoValido
	sub		rsp,32
	call	printf
	add		rsp,32
	jmp		finValidacionObjeto
pesoNoValido:
	mov 	rcx,mensajePesoNoValido
	sub		rsp,32
	call	printf
	add		rsp,32
	jmp		finValidacionObjeto
destinoNoValido:
	mov 	rcx,mensajeDestinoNoValido
	sub		rsp,32
	call	printf
	add		rsp,32
finValidacionObjeto:
ret

;------------------------------------------------------
;   Valida el peso del objeto ingresado por el usuario
;------------------------------------------------------
validarPesoIngresado:
	mov		byte[datoValido],'N'

	cmp		word[objetoIngresadoPeso],1
	jl		finValidarPeso

	cmp		word[objetoIngresadoPeso],15
	jg		finValidarPeso

	mov		byte[datoValido],'S'
finValidarPeso:
ret

;------------------------------------------------------
;   Valida la inicial de destino ingresada por el usuario
;------------------------------------------------------
validarDestinoIngresado:
	mov 	byte[datoValido],'N'

	mov 	rbx,0
	mov 	rcx,3
	mov 	rax,0		; va a indicar el nro correspondiente al destino
siguienteDestino:
	inc 	rax
	push 	rcx
	mov		rcx,1
	lea 	rsi,[objetoIngresadoDestino]
	lea 	rdi,[destinos+rbx]
	repe 	cmpsb
	pop		rcx
	je 		destinoValido

	add		rbx,1
	loop	siguienteDestino

	jmp 	finValidacionDia

destinoValido: 
	mov 	byte[datoValido],'S'
	mov		word[destinoIngresadoNumero],ax
finValidacionDia:
ret

;------------------------------------------------------
;   Guarda el objeto ingresado por el usuario
;------------------------------------------------------
guardarObjeto:
	mov		rcx,0
	dec		word[destinoIngresadoNumero]
	mov 	rax,40										; 20*2=40 		20 por la cantidad de columnas de cada fila y 2 por el tamaño de cada columna
	mov 	rbx,0
	mov 	bx,word[destinoIngresadoNumero]
	imul	rbx,rax										; ya queda rbx con el desplazamiento a la correspondiente al destino del objeto ingresado

siguienteObjeto:
	mov		cx,word[objetos+rbx]
	cmp		cx,word[objetoIngresadoPeso]
	jl		insertarObjeto								; si el objeto apuntado por rbx es de menor peso que el objeto ingresado, 
														; significa que esa posicion es la correspondiente para el objeto ingresado
	add		rbx,2
	jmp 	siguienteObjeto								; si el objeto apuntado por rbx es de mayor peso que el objeto ingresado,
														; desplazo rbx al siguiente objeto del destino 

insertarObjeto:
	mov		rax,0
	; guardo el objeto que será pisado
	mov		ax,word[objetos+rbx]
	mov		word[objetoAuxDesplazamiento],ax

	; guardo el nuevo objeto en la posicion correspondiente
	mov		ax,word[objetoIngresadoPeso]
	mov		word[objetos+rbx],ax

	; incremento la cantidad del destino correspondiente
	mov 	cx,word[destinoIngresadoNumero]
	inc		byte[cantidades+rcx]

	; si la cantidad correspondiente es 20 significa que ya se ingresó el maximo de objetos
	cmp		byte[cantidades+rcx],20
	jge		finGuardarObjeto

	; si el objeto que quedó en objetoAuxDesplazamiento es de peso 0, significa que el nuevo objeto quedó en la ultima posicion 
	; de la fila por lo que no hay que realizar un desplazamiento
	cmp		word[objetoAuxDesplazamiento],0
	je		finGuardarObjeto

	; si el objeto que quedó en el objetoAuxDesplazamiento es de peso mayor a 0, significa que el nuevo objeto ocupó la posicion
	; de otro objeto por lo que, a partir de este ultimo, hay que correr a todos los objetos una posicion
	add		rbx,2
	call 	desplazarObjetos
finGuardarObjeto:
ret

;------------------------------------------------------
;   desplaza una posicion los objetos de "objetos" desde el desplazamiento indicado por rbx hasta encontrar un 0
;------------------------------------------------------
desplazarObjetos:
	; guardo el objeto que será pisado
	mov		ax,word[objetos+rbx]
	mov		word[objetoAux],ax

	; guardo el objeto de objetoAuxDesplazamiento en su nueva posicion
	mov		ax,word[objetoAuxDesplazamiento]
	mov		word[objetos+rbx],ax

	; guardo el objeto que iba a ser pisado en objetoAuxDesplazamiento para desplazarlo también
	mov		ax,word[objetoAux]
	mov		word[objetoAuxDesplazamiento],ax

	; avanzo el puntero rbx una posición
	add		rbx,2

	; desplazo cada objeto una posicion hasta tener un cero en objetoAuxDesplazamiento
	cmp		byte[objetoAuxDesplazamiento],0
	jg		desplazarObjetos
ret

;------------------------------------------------------
;   Lista en pantalla los paquetes de todos los destinos
;------------------------------------------------------
mostrarPaquetes:
siguienteDesitno:
	mov		rcx,0
	mov		cl,byte[contadorDestino]
	mov		rbx,0
	mov		bl,byte[cantidades+rcx]
	cmp		rbx,0
	jle		sinObjetos

	mov		byte[cantidadActual],bl
	call 	mostrarPaquetesDestino

sinObjetos:
	inc		byte[contadorDestino]
	cmp		byte[contadorDestino],2
	jle		siguienteDesitno

ret


;------------------------------------------------------
;   Lista en pantalla los paquetes del destino correspondiente al numero contadorDestino
;------------------------------------------------------
mostrarPaquetesDestino:
	mov		rcx,0
	mov		cl,byte[contadorDestino]
	mov		rax,objetos
	imul	rbx,rcx,40									; 20*2=40 	20 por la cantidad de columnas de cada fila y 2 por el tamaño de cada columna
	add		rax,rbx										
	mov		[direccionInicial],rax						; ya queda en direccionInicial la direccion a la fila correspondiente al destino que actualmente se esta
														; preparando
	
	mov		rbx,0
	mov		bl,byte[cantidadActual]
	dec		rbx
	imul	rbx,2
	add		rax,rbx
	mov		[direccionFinal],rax						; ya queda en direccionFinal la direccion al ultimo objeto de fila correspondiente al destino que actualmente 
														; se esta preparando

siguientePaquete:
	mov		word[sumaPaquete],0

	mov		rcx,0
	mov		cl,byte[contadorDestino]
	imul	rcx,17
	add		rcx,destinosLista							; imprimo en pantalla el destino del proximo paquete
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov 	rcx,mensajeGuion
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov 	rcx,numeroFormato
	mov 	rdx,[direccionInicial]						; Se mete en el paquete el primer objeto de la fila que todavía no fue incluido en ningún paquete
	mov		rbx,rdx
	mov		rdx,0
	mov		dx,word[rbx]
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov		rdx,0
	mov		dx,word[rbx]
	add		word[sumaPaquete],dx						; se actualiza sumaPaquete con el peso actual del paquete
	add		qword[direccionInicial],2
	dec		byte[cantidadActual]						; como ya se metió un objeto en un paquete, la cantidad correspondiente disminuye
	
	cmp		byte[cantidadActual],0
	jle		finDestino

siguienteObjetoPaquete:									; si ya se metió en el paquete el primer objeto de la fila y qtodavía quedan objetos, 
														; se recorre la lista desde el ultimo objeto ingresandolos en el paquete hasta llegar a 
														; la maxima capacidad o haber metido todos los objetos
	mov		rax,0
	mov		ax,word[sumaPaquete]
	mov 	rbx,[direccionFinal]
	mov		dx,word[rbx]
	mov		word[objetoAux],dx							; se obtiene el ultimo paquete de la fila que todavía no fue incluido en ningún paquete
	add		ax,word[objetoAux]

	cmp		ax,15										; se comprueba que no se pase la capacidad máxima del paquete
	jg		finPaquete									; si se paso la capacidad máxima, se termina el paquete y se avanza al próximo

	mov		word[sumaPaquete],ax						; se actualiza sumaPaquete con el peso actual del paquete

	mov 	rcx,mensajeSuma
	sub 	rsp,32
	call 	printf
	add 	rsp,32
	
	mov 	rcx,numeroFormato
	mov 	rdx,0
	mov		dx,word[objetoAux]
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	sub		qword[direccionFinal],2						; Se le resta el tamaño de una columna para que direccionFinal siempre apunte al ultimo objeto de la fila que
														; que todavía no fue incluido en ningún paquete
	dec		byte[cantidadActual]						; como ya se metió un objeto en un paquete, la cantidad correspondiente disminuye
	
	cmp		byte[cantidadActual],0
	jle		finDestino

	jmp		siguienteObjetoPaquete
	
finPaquete:
	mov 	rcx,mensajeSaltodeLinea
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	jmp		siguientePaquete

finDestino:
	mov 	rcx,mensajeSaltodeLinea
	sub 	rsp,32
	call 	printf
	add 	rsp,32
ret