JMP main

x: DW 3
y: DW 5
z: DW 2
    
main:
	MOV A, [z]  ; A <- z
    MUL 3		; A <- 3*z
    MOV B, A	; B <- 3*z
    MOV A, [x]	; A <- x
    ADD A, [y]	; A <- x + y
    DIV 2		; A <- (x+y) / 2
    SUB B, A	; B <- 3*z - (x+y)/2
    MOV [z], B	; z <- 3*z - (x+y)/2
    
	HLT
    
    
; mul 3 == a <- a * 3
; div 3 == a <- a / 3
; spremenljivke vedno v oglate oklepaje