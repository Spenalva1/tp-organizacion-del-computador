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

	objetos						times 0  db			''
		objetosPosadas			times 20 dw			0		; BORRAR SI NO SE USA
		objetosSalta			times 20 dw			0		; BORRAR SI NO SE USA
		objetosTierra			times 20 dw			0		; BORRAR SI NO SE USA

	cantidades					times 0  db			''
		cantidadPosadas			times 1  db			0
		cantidadSalta			times 1  db			0
		cantidadTierra			times 1  db			0

	objetoAuxDesplazamiento		dw					0
	objetoAux					dw					0
	contadorDestino				db					0

	
numeroDebugger				db					10,'a ver... %lli',10,0 ;DEBUG
debugger				db					'a ver: %lli',10,0 ;DEBUG
guardandoPosadas	   	db  				'Guardando objeto en Posadas...',10,0 ;DEBUG
guardandoSalta	   	db  				'Guardando objeto en Salta...',10,0 ;DEBUG
guardandoTierra	   	db  				'Guardando objeto en Tierra...',10,0 ;DEBUG

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

; mov 	rbx,0
; siguiente:
; cmp		word[objetosTierra+rbx],0
; je		fin
; mov 	rcx,numeroDebugger
; mov 	rdx,0
; mov 	dx,word[objetosTierra+rbx]
; sub 	rsp,32
; call 	printf
; add 	rsp,32
; add		rbx,2
; jmp		siguiente
; fin:

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
	mov 	rax,40									; 20*2=40
	mov 	rbx,0
	mov 	bx,word[destinoIngresadoNumero]
	imul	rbx,rax										; ya queda rbx con el desplazamiento al vector correspondiente

siguienteObjeto:
	mov		cx,word[objetos+rbx]
	cmp		cx,word[objetoIngresadoPeso]
	jl		insertarObjeto
	add		rbx,2
	jmp 	siguienteObjeto

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

	cmp		byte[cantidades+rcx],20
	jge		finGuardarObjeto

	cmp		word[objetoAuxDesplazamiento],0
	je		finGuardarObjeto

	add		rbx,2
	call 	desplazarObjetos
finGuardarObjeto:
ret

;------------------------------------------------------
;   desplaza una posicion los objetos de "objetos" desde el desplazamiento indicado por rbx hasta encontrar un 0
;------------------------------------------------------
desplazarObjetos:
	mov		ax,word[objetos+rbx]
	mov		word[objetoAux],ax

	mov		ax,word[objetoAuxDesplazamiento]
	mov		word[objetos+rbx],ax

	mov		ax,word[objetoAux]
	mov		word[objetoAuxDesplazamiento],ax

	add		rbx,2

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
	imul	rbx,rcx,40									; 20*2=40
	add		rax,rbx
	mov		[direccionInicial],rax
	
	mov		rbx,0
	mov		bl,byte[cantidadActual]
	dec		rbx
	imul	rbx,2
	add		rax,rbx
	mov		[direccionFinal],rax

siguientePaquete:
	mov		word[sumaPaquete],0

	mov		rcx,0
	mov		cl,byte[contadorDestino]
	imul	rcx,17
	add		rcx,destinosLista
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov 	rcx,mensajeGuion
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov 	rcx,numeroFormato
	mov 	rdx,[direccionInicial]
	mov		rbx,rdx
	mov		rdx,0
	mov		dx,word[rbx]
	sub 	rsp,32
	call 	printf
	add 	rsp,32

	mov		rdx,0
	mov		dx,word[rbx]
	add		word[sumaPaquete],dx
	add		qword[direccionInicial],2
	dec		byte[cantidadActual]
	
	cmp		byte[cantidadActual],0
	jle		finDestino

siguienteObjetoPaquete:
	mov		rax,0
	mov		ax,word[sumaPaquete]
	mov 	rbx,[direccionFinal]
	mov		dx,word[rbx]
	mov		word[objetoAux],dx
	add		ax,word[objetoAux]

	cmp		ax,15
	jg		finPaquete

	mov		word[sumaPaquete],ax

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

	sub		qword[direccionFinal],2
	dec		byte[cantidadActual]
	
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