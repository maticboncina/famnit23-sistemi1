JMP main

s:
DB "A string long enough to go beyond the right border."
DB 0

main:
	MOV A, 0x1
    OUT 0x7
    MOV A, 0xa300
    OUT 0x8
    MOV A, 3
    OUT 0x9
    MOV C, s
    MOV D, 0
loop:
	MOV A, D
    OUT 8
    MOVB AH, [C]
    CMPB AH, 0
    JE break
    MOVB AL, 252
    OUT 9
    INC C
    ADD D, 2
    JMP loop
break:
	MOV A, 0xa302
    OUT 0x8
    MOV A, 650
    OUT 0x9
	HLT