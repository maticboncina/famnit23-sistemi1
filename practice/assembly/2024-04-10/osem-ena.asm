JMP MAIN

main:
	IN 5
    CMP A, 0
    JE main
    MOV B, A
    IN 6 ; preveremi ASCII -> A
    AND B, 1 ; maskiramo keydown
    CMP B, 1 ; ali je keydown
    JE print
    MOVB [0x1000], 0
    JMP main
    
clear:
	MOVB [0x1000], AL
    JMP readkey
    
HLT