JMP main

s: 
	DB "Hello world!"
	DB 0

main:
	MOV A, 0x1
    OUT 0x7
    MOV C, s
    MOV D, 0
loop:
	MOV A, D
    OUT 0x8
    MOVB AH, [C]
    CMPB AH, 0
    JE exit
    MOVB AL, 252
    OUT 9
    INC C
    ADD D, 2
    JMP loop
exit: 
	HLT