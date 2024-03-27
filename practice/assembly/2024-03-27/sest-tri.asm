JMP main

add:
	POP D; return address
    POP A
    POP B
    ADD A, B
    PUSH A
    PUSH D ; ret address
    RET

main:
	MOV SP, 0x0FFF
    PUSH 5
    PUSH 3
    CALL add
    POP A
    HLT