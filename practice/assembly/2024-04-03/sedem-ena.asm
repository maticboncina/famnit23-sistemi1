JMP main
numbers:
	DW 1
    DW 2
    DW 3
    DW 4
    DW 5
    DW 6
    DW 7
    DW 8
    DW 9
    DW 10
    
main:
	MOV C, 0
    
loop:
	CMP C, 10
    JAE finish
    MOV D, numbers
    MOV A, C
    MUL 2
    ADD D, A
    MOV A, [D]
    MUL 10
    MOV [D], A
    INC C
    JMP loop

finish:
	HLT