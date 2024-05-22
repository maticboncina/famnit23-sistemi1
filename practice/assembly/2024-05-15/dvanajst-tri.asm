JMP main

main:
MOV A, 1
    OUT 7

; Sprite 1
    MOV A, 0xA306 ; Sprite ADDR (znak, barva) access
    OUT 8
    MOVB AH, 'A'
    MOVB AL, 252
    OUT 9
    MOV A, 0xA308 ; Sprite ADDR (x, y) access
    OUT 8
    MOV A, 0x0303 ; (x ,y) koordinate -> VIDDATA
    OUT 9

; Sprite 2
MOV A, 0xA30A
    OUT 8
    MOVB AH, 'A'
    MOVB AL, 224
    OUT 9
    MOV A, 0xA30C
    OUT 8
    MOV A, 0x0606
    OUT 9

; Celica 0
MOV A, 0
    OUT 8
    MOVB AH, 'A'
    MOVB AL, 255
    OUT 9
HLT