JMP main

main:
MOV A, 1 ; Set up the text mode
    OUT 7 ; through register VIDMODE

    MOVB CL, 'A' ; Start with the letter 'A'
    MOV D, 0 ; Pointer to the screen cells
loop:
CMPB CL, 'Z' ; Are we past the letter 'Z'?
    JA break ; If yes, finish
    CMPB DH, 16 ; Have we already filled up the first 15 lines?
    JB noscroll ; If not, no need to scroll
    MOV A, 0xA304 ; Get the vertical scroll information
    OUT 8 ; from VRAM
    IN 9 ; to register A
    ADD A, 16 ; Increase it by 16 pixels
    OUT 9 ; and write it back to VRAM
noscroll:
MOV A, D ; Activate the current screen cell
    OUT 8 ; in VRAM
    MOVB AH, CL ; Set up the current ASCII code
    MOVB AL, 255 ; Make it white
    OUT 9 ; Display the character
    INC C ; Next character
    ADD D, 256 ; Next line
    JMP loop
break:
HLT