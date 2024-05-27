JMP main
JMP isr

vsync: DW 0

isr:
PUSH A
MOV [vsync], 1
    MOV A, 4
    OUT 2
    POP A
IRET

wait_frame:
PUSH A
wait_frame_loop:
MOV A, [vsync]
    CMP A, 0
    JE wait_frame_loop
    MOV [vsync], 0
    POP A
    RET

random_dx_dy:
PUSH A
IN 10
    AND A, 0x0303
    ADD A, 0x0101
    CMPB DH, 128
    JB rnd_no_dx
    XORB AH, 0xFF
    INCB AH
rnd_no_dx:
CMPB DL, 128
    JB rnd_no_dy
    XORB AL, 0xFF
    INCB AL
rnd_no_dy:
MOV D, A
    POP A
    RET

main:
MOV SP, 0x0FFF

MOV A, 1
    OUT 7

    MOV A, 0xA306 ; Sprite 1
    OUT 8
    MOV A, 0xFFFF ; Krogec bele barve
    OUT 9

    ; Naključna postavitev (x, y); x, y \in [0, 255]
    MOV A, 0xA308
    OUT 8
    IN 10
    CMPB AH, 240
    JNA skip_x_adjust
    MOVB AH, 240
skip_x_adjust:
CMPB AL, 240
    JNA skip_y_adjust
    MOVB AL, 240
skip_y_adjust:
OUT 9

    MOV A, 4
    OUT 0
    STI

    MOV D, 0x01FF ; dx = 1, dy = -1

    ; Animacijska zanka
loop:

MOV A, 0xA308
    OUT 8
    IN 9

    ; Predvidimo naslednjo pozicijo
    MOV B, A
    ADDB BH, DH
    ADDB BL, DL

    ; Trk z desnim robom?
    CMPB BH, 240
    JB no_x_collision
    NOTB DH ; dx = -dx
    INCB DH
    CALL random_dx_dy
no_x_collision:
CMPB BL, 240
    JB no_y_collision
    XORB DL, 0xFF
    INCB DL
    CALL random_dx_dy
no_y_collision:

    ADDB AH, DH ; x = x + dx
    ADDB AL, DL ; y = y + dy
    OUT 9

CALL wait_frame
JMP loop

    HLT