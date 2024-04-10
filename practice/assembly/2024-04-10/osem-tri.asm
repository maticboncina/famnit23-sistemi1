JMP main
JMP isr

isr:
; push registers
    PUSH A
    PUSH B
    ; driver za timer
    ; povečamo trenutno izpisani ASCII
    MOVB AL, [0x1000] ; trenutni znak -> A
    CMPB AL, '9'
    JE dontdoit
    INCB AL ; naslednji ASCII znak
    MOVB [0x1000], AL ; izpišemo
dontdoit:
    ; umaknemo zahtevo za prekinitev
    MOV A, 2 ; številka za prekinitev
    OUT 2
    ; restore registers
    POP B
    POP A
IRET

main:
MOV SP, 0x0FFF
    MOV A, 2 ; IRQ keyboard = 1
    OUT 0 ; IRQMASK
    MOVB [0x1000], '0'
    MOV A, 5000
    OUT 3
    STI ; Set Interupts M = 1

HLT