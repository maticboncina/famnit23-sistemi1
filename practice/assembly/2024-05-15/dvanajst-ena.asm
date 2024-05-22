JMP main

ghost:
DB "\x00\x00\x03\xC0\x0F\xF0\x1F\xF8\x33\xCC\x21\x84\x2D\xB4\x6D\xB6"
DB "\x73\xCE\x7F\xFE\x7F\xFE\x7F\xFE\x7F\xFE\x7B\xDE\x31\x8C\x00\x00"

s: DB "ABBA"
DB 0

main:
MOV A, 1
    OUT 7
MOV C, s
    MOV D, 0
print_loop:
MOVB BL, [C]
    CMPB BL, 0
    JE break
    MOV A, D
    OUT 8
    MOVB AH, BL
    MOVB AL, 255
    OUT 9
    INC C
    ADD D, 2
JMP print_loop
break:

MOV C, ghost
    MOV D, 0x8820
    MOV B, 16
ghost_loop:
CMP B, 0
    JE ghost_break
    MOV A, D
    OUT 8
    MOV A, [C]
    OUT 9
    ADD C, 2
    ADD D, 2
    DEC B
    JMP ghost_loop
ghost_break:
HLT
