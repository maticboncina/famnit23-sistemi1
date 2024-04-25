JMP main

main:
	MOV A, 0x1
    OUT 0x7
    MOVB CL, 0
    MOV D, 0
loop:
	MOV A, D
    OUT 0x8
    MOVB AH, CL
    MOVB AL, 255
    OUT 0x9
    INCB CL
    CMPB CL, 0
    JE break
    ADD D, 2
    MOV B, D
    AND B, 0x00ff
    CMP B, 32
    JB loop
    ADD D, 224
	JMP loop
break:
	HLT