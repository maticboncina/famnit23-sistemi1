JMP main

x: DW 5

main:
	MOV A, [x]
    CMP A, 100
    JAE check2
    JMP continue
    
check2:
	CMP A, 200
    JB doit
    JMP continue
    
doit:
	SHR A, 1
    MOV [x], A
    
continue:
	HLT