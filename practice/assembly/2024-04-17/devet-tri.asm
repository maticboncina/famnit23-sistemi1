JMP main

main:
    MOV A, 3
    OUT 0x7
    MOV A, 2
    OUT 0x7
    
    MOV C, 0 ; rdeča
    MOV D, 0x00ff ; rumena
loop:
    MOVB CL, CH
    MOV A, C
    OUT 0x8
    MOV A, 11100000b
    OUT 0x9
    
    
    MOVB DH, CH
    MOV A, D
    OUT 0x8
    MOV A, 11111100b
    OUT 0x9
    
    INCB CH
    DECB DL
    
    CMPB CH,255
    JNE loop
end:    
    HLT