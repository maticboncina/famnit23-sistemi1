JMP main

x: DW 7
y: DW 5

main:
	MOV A, [x]
    SUB A, [y]
	HLT