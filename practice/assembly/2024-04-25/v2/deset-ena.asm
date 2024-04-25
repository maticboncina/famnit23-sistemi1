JMP main

s: DB "Hello world!"
DB 0

main:
MOV A, 1 ; Set up the text mode
    OUT 7 ; through register VIDMODE

    MOV C, s ; Pointer to string
    MOV D, 0 ; Pointer to screen cells

loop:
MOV A, D ; Activate the screen cell
    OUT 8 ; through register VIDADDR
    MOVB AH, [C]; Get a character
    CMPB AH, 0 ; The end of the string?

    JE exit ; if yes, terminate loop
    MOVB AL, 200; Set it's color to yellow
    OUT 9 ; Display the character
    INC C ; Next character
    ADD D, 2 ; Next screen cell
    JMP loop
exit:
HLT