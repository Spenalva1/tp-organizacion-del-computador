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

	numeroFormato				db					'%hi',0
	objetoIngresadoFormato		db					'%hi %c',0

	destinos					db					'PST',0
	destinosLista				db					'Posadas         ',0
								db					'Salta           ',0
								db					'Tierra del Fuego',0

	objetosPosadas				times 20 dw			0
	objetosSalta				times 20 dw			0
	objetosTierra				times 20 dw			0

	ultimaPosicionPosadas		dw					0
	ultimaPosicionSalta			dw					0
	ultimaPosicionTierra		dw					0

	
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

section .text
main:
	call 	ingresarCantidadDeObjetos

	call 	ingresarObjetos

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
	cmp		word[destinoIngresadoNumero],1
	je		guardarPosadas

	cmp		word[destinoIngresadoNumero],2
	je		guardarSalta

	cmp		word[destinoIngresadoNumero],3
	je		guardarTierra

guardarPosadas:
mov 	rcx,guardandoPosadas ;debug
sub		rsp,32
call	printf
add		rsp,32
	jmp 	finGuardarObjeto

guardarSalta:
mov 	rcx,guardandoSalta ;debug
sub		rsp,32
call	printf
add		rsp,32
	jmp 	finGuardarObjeto

guardarTierra:
mov 	rcx,guardandoTierra ;debug
sub		rsp,32
call	printf
add		rsp,32

finGuardarObjeto:
ret