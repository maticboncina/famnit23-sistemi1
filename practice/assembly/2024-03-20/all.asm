JMP main

i: DW 0 

main:

while:
	MOV A, [i]
	CMP A, 10
    JAE break
    INC A
    MOV [i], A
	JMP while
    
break:
	HLT

-----------------------------------------------------------------

OPTIMISED PREVIOUS CODE:

JMP main

i: DW 0 

main:
	MOV A, [i]
while:
	CMP A, 10
    JAE break
    INC A
	JMP while
break:
    MOV [i], A
	HLT
	
-----------------------------------------------------------------
	
; for (int i=1, sum <10, sum++)

JMP main

sum: DW 0 

main:
	MOV A, [sum] ; A <- sum
    MOV C, 1 ; i = 1
for:
	CMP C, 10 ; i ~ 10
    JA break  ; i > 10
    ADD A, C  ; sum += i
    INC C     ; i++
	JMP for
break:
	MOV [sum], A
	HLT	
	
--------------------------------------------------------------

; !n

JMP main

f: DW 1
n: DW 5

main:
	MOV A, [f] ; A <- count
    MOV C, 2   ; i = 2
for:
	CMP C, [n] ; i ~ n
    JA break   ; i > n
    MUL C	   ; f = f*i
    INC C      ; i++
	JMP for
break:
	MOV [f], A
	HLT
	
--------------------------------------------------------------

; !n BREZ MUL

JMP main

f: DW 1
n: DW 5

main:
	MOV A, [f] ; A <- count
    MOV C, 2   ; i = 2
for:
	CMP C, [n] ; i ~ n
    JA break   ; i > n
    
    ;MUL C	   ; f = f*i
    MOV B, 0   ; fi = 0
    MOV D, 0   ; j = 0
for_mul:
  	CMP D, C   ; i ~ j
    JAE break_mul ; i >= j
    ADD B, A      ; fi += f
    INC D		  ; j++
    JMP for_mul
break_mul:
	MOV A, B
    INC C      ; i++
	JMP for
break:
	MOV [f], A
	HLT


