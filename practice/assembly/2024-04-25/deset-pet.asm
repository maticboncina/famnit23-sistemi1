JMP main

main:
	MOV A, 1
    OUT 0x7
    MOVB CL, 'A'
    MOV D, 0
loop:
	CMPB CL, 'Z'
    JA break
    CMPB DH, 16
    JB noscroll
    MOV A, 0xa304
    OUT 0x8
    IN 0x9
    ADD A, 16
    OUT 0x9
noscroll:
	MOV A, D
    OUT 0x8
    MOVB AH, CL
    MOVB AL, 255
    OUT 0x9
    INC C
    ADD D, 256
    JMP loop
break:
	HLT