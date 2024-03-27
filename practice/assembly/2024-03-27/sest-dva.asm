JMP main

main:
	MOV SP, 0x0FFF
    MOV C, 1
   
loop:
	CMP C, 100
    JA break
    PUSH C
    INC C
    JMP loop
    
break:
	HLT