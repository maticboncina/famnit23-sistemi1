JMP main
JMP ISR

vsync: DW 0 ; 0 - ni vsync, 1 - vsync

ISR:
PUSH A

    ; VSYNC signal
    MOV [vsync], 1

; Umaknemo IRQ = 4
    MOV A, 4
    OUT 2

    POP A
IRET

; Funkcija, ki počaka na vsync
; wait_vsync(count)
; count (reg. C) - koliko sličic počakamo?
wait_vsync:
vsync_loop:
MOV A, [vsync]
    CMP A, 0
    JE vsync_loop
    MOV [vsync], 0
    DEC C
    CMP C, 0
    JNE vsync_loop
    RET

s: DB "The light at the end of the world"
DB 0

main:
MOV SP, 0x0FFF
    ; Vključimo grafično kartico
    MOV A, 1
    OUT 7
    ; Omogočimo prekinitev gr. kartice
    MOV A, 4 ; IRQ = 4, graf. kart.
    OUT 0 ; IRQMASK
    STI ; Omogočimo prekinitve

    ; Izpišemo besedilo
    MOV C, s
    MOVB DH, 7 ; Index vrstice 7
    MOVB DL, 32 ; Index vrstice 16

print_loop:
MOVB BL, [C] ; Preberemo črko
    CMPB BL, 0 ; Če je 0, smo na koncu niza
    JE print_break
    MOV A, D ; Naslov celice na zaslonu
    OUT 8 ; Aktiviramo celico
    MOVB AH, BL ; ASCII zank
    MOVB AL, 252 ; Rumena barva
    OUT 9 ; Izrišemo znak
    INC C ; Naslednji znak
    ADD D, 2 ; Naslednja celica
    JMP print_loop
print_break:

    ; Barva ozadja
    MOV A, 0xA300 ; Naslov ozadja
    OUT 8 ; Aktiviramo
    MOV A, 3 ; Modra barva
    OUT 9

    ; Animacija
loop:
; Premaknemo okno ua 1 piko v desno
    MOV A, 0xA302 ; Naslov horizontalnega drsnika
    OUT 8 ; Aktiviramo naslov -> VIDDATA pojavi vsebina
    IN 9 ; VIDDATA -> A
    ;INC A ; Povečamo za 1 piko
    ADD A, 2 ; Povečamo za 2 pike
    OUT 9 ; A -> VIDDATA

; Počakamo eno sličico
MOV C, 1
    CALL wait_vsync
    JMP loop

    HLT