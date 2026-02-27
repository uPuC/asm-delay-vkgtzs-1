;------------- definiciones e includes ------------------------------
;.INCLUDE "m1280def.inc" ; Incluir definiciones de Registros para 1280
.INCLUDE "m2560def.inc" ; Incluir definiciones de Registros para 2560

.equ k=103

.equ n=90	
.equ m=236

.equ a=117
.equ b=237
.equ c=191

;------------- implementar ------------------------------------------
;call delay20uS
;call delay4mS
;call delay1S
ret

;call myRand ; Retorna valor en R25

; DELAY 20uS
delay20uS:
ldi R24, k			; 1
nop					; 1
next:
	dec R24			; k
	brne next		; 2k - 1
	ret				; 10

; DELAY 4mS
delay4ms:
ldi R24, n				; 1
clo1:ldi R25, m			; n
	clo2: dec R25		; n*m
	      brne clo2		; n(2m-1)
	dec R24				; n
	brne clo1			; 2n-1
	ret					; 10

; DELAY 1S
delay1S:
ldi R24, a				; 1
nop						; 1
nop						; 1
nop						; 1
nop						; 1
nop						; 1
nop						; 1
clco1: ldi R25,b				; x
	clco2: ldi R26, c 			; x * y
		clco3:dec R26			; x * y * z
			brne clco3			; xy (2z-1)
		dec R25					; x * y
		nop						; x * y
		brne clco2				; x (2y-1)
	dec R24						; x
	brne clco1					; 2x - 1
	ret	
			
; ------------- ciclo principal --------------------------------------

ldi  R25, 0xAC      ; semilla
ldi  R26, 0xB8      ; máscara LFSR

arriba: inc R24
	cpi R24,10
	breq abajo
	out PORTA,R24
	rcall myRand
	rjmp arriba

abajo: dec R24
	cpi R24,0
	breq arriba
	out PORTA,R24
	rcall myRand
	rjmp abajo

myRand:
    lsl  R25
    brcc fin
    eor  R25, R26
fin:
    ret