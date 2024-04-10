JMP main
JMP isr

isr:
; push registers
    PUSH A
    PUSH B
    ; driver za tipkovnico
    IN 5 ; KBDSTATUS -> A
    MOV B, A ; KBDSTATUS -> B
    IN 6 ; KBDDATA -> A
    AND B, 1 ; maskiramo keydown
    CMP B, 1
    JE print
    MOVB [0x1000], 0
    JMP finish
print:
MOVB [0x1000], AL
finish:
; umaknemo zahtevo po prekinitvi
    MOV A, 1 ; IRQ tipkovnice
    OUT 2
    ; restore registers
    POP B
    POP A
IRET

main:
MOV SP, 0x0FFF
    MOV A, 1 ; IRQ keyboard = 1
    OUT 0 ; IRQMASK
    STI ; Set Interupts M = 1

HLT