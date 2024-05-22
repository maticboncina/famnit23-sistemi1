JMP main

main:
MOV A, 1
    OUT 7
   
    MOV C, 100
   
print_loop:
CMP C, 0
    JE break
    IN 10 ; RNDGEN -> A
    AND A, 0x0F1E ; MASK za screen
    OUT 8
    IN 9 ; Če ni prazno, try again
    CMP A, 0
    JNE print_loop
    MOVB AH, 'A'
    MOVB AL, 224
    OUT 9
    DEC C
JMP print_loop
break:

    ; CHANGE THE COLOR TO PURPLE
    MOV A, 0xA2A0
    OUT 8
    MOV A, 0xFF00
    OUT 9
    MOV A, 0xA2A1
    OUT 8
    MOV A, 0x00FF
    OUT 9
   
HLT