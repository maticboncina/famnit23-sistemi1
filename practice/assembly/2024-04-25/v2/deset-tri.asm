JMP main

s: DB "A string long enough to go beyond the right border"
DB 0

main:
MOV A, 1 ; Set up the text mode
    OUT 7 ; through register VIDMODE

    MOV A, 0xA300 ; Background color information
    OUT 8 ; in VRAM
    MOV A, 3 ; Blue color index
    OUT 9 ; Make background blue
    MOV C, s ; Pointer to string
    MOV D, 0 ; Pointer to screen cells

loop:
MOV A, D ; Activate the screen cell
    OUT 8 ; through register VIDADDR
    MOVB AH, [C] ; Get a character
    CMPB AH, 0 ; The end of the string?
    JE break ; If yes, break the loop
    MOVB AL, 252 ; Set it's color to yellow
    OUT 9 ; Display the character
    INC C ; Next character
    ADD D, 2 ; Next screen cell
    JMP loop
break:
    MOV A, 0xA302 ; Horizontal scroll information
    OUT 8 ; in VRAM
    MOV A, 650 ; Scroll horizontally by 650 pixels (each character is 16 px)
    OUT 9 ; by overwriting the existing value
HLT