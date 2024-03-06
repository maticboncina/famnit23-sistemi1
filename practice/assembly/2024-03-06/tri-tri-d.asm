JMP main

main:
	MOV A, [x]
	ADD A, 3
	MOV [x], A
	HLT
    
ORG 0x0100
x: DW 0xABCD