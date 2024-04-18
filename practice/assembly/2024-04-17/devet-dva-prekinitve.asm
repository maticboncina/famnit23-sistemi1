JMP main
JMP isr
terminate: DW 0 ; 0 - false, 1 - true

isr:
    ; Push registers
    PUSH A

    ; Tell loop to stop
    MOV [terminate], 1

    ; Move IRQ = 1 
    MOV A , 1 ; IRQ = 1
    OUT 2 ; IRQEOI 

    ; Pop registers

    POP A
    IRET ;return interrupt

main:
MOV SP, 0x0FFF
; Allowing interrupts for keyboard (IRQ = 1)
MOV A, 1
OUT 0 ; Allowing interrupt in IRQ mask


MOV A, 2 ; BITMAP MODE = 2
OUT 7 ; Turning BITMAP on vidmode
STI ; M = 1  ( able to send interrupts )

; Deleting address
MOV A, 3 ; Clear
OUT 7 ; Da bide na pochetok crn ekrna

; Levo od register e Y, desno od register e X


loop:
    ;MOV A, (RND)
    IN 10 ; RNDGEN -> A (random number)
    OUT 8

    IN 9 ; VIDDATA -> A reading the pixel color
    CMP A, 0 ; is the pixel black 
    JNE loop

    ; MOV A, (RND)
    IN 10; RNDGEN -> A  random number
    OUT 9
    MOV A, [terminate]
    CMP A, 0 ; if terminate is 0 then continue the loop
    JE loop 
    HLT