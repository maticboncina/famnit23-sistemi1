; Solved with ChatGPT, because I lost the files. May not be correct.

MOV AL, 120 
; Move 120 into AL

MOV BL, 180 
; Move 180 into BL

ADD AL, BL ; Adds the content of BL to AL
; AL now contains the result of 120 + 180 in 8-bit, which will be 44 due to overflow (300 - 256)

MOV AH, 0 ; Clear AH to use AX as a 16-bit register
MOV BH, 0 ; Clear BH to use BX as a 16-bit register
ADD AX, BX ; Adds the content of BX to AX
; AX now contains the result of 120 + 180 without overflow, which is 300