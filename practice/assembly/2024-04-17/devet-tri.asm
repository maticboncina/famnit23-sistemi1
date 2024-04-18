JMP main

main:
    MOV A, 3
    OUT 0x7
    MOV A, 2
    OUT 0x7
    
    MOV B, 0
    MOV C, 0x00ff
loop:
    MOV A, B
    OUT 0x8
    MOV A, 11100000b
    OUT 0x9
    MOV A, C
    OUT 0x8
    MOV A, 11111100b
    OUT 0x9
    
    ADD B, 257
    ADD C, 255
    
    CMP B, 255
    JNE loop
end:    
    HLT