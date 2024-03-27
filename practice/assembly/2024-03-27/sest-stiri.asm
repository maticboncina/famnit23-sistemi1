JMP main
; Function max (a, b)
; Vrne večje od danih dveh števil.
;
; Params:
;	a - Prvo število (preko registra A)
; 	b - Drugo število (preko registra B)
;
; Returns:
;	Via sklad

max:
	POP D			; povratni naslov
    CMP A, B
    JA max_a
    				; B je večje
    PUSH B
    JMP max_ret

max_a:
					; A je večje
    PUSH A
    
max_ret:
	PUSH D 			; povratni naslov
    RET

main:
	MOV SP, 0x0FFF	; zaradi funkcij inicializiramo kazalec na sklad 
    MOV A, 5		; prvi param
    MOV B, 7		; drugi param
    CALL max		; max(a,b)
    POP C			; C <- max (5, 7)	
	HLT