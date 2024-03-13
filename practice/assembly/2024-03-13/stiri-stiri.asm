JMP main

x: DW 7
y: DW 5

main:
	; if (x < y) x = x + 1
    ; if (x >= y) do not x = x + 1;
	MOV A, [x]
    CMP A, [y]
	JB doit
    JMP continue
doit:
	INC A
   	MOV [x], A
continue:
	HLT
    