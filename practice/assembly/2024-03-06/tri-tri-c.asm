JMP 0x0005

x: DW 0xABCD

main:
	MOV [0x0100], 0xABCD ;int x = 0xABCD
	ADD A, [0x0100]
	ADD A, 3
	MOV [0x0100], A
    
    MOV A, main
	HLT