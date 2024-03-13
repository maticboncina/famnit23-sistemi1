JMP main

x: DW 7
y: DW 5
z: DW 0

main:
	MOV A, [x]
    CMP A, [y] ; compare
	JB body
    MOV [z], A
	JMP continue
body:
	MOV A, [y]
    MOV [z], A
    
continue:
	HLT