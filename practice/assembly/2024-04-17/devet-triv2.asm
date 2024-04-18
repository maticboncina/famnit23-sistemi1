MOV A, 2 ; vključimo grafo
OUT 7

MOV A, 3 ; clear display
OUT 7
MOV C, 0x0000 ; prvi rdeč pixel
MOV D, 0x00FF ; prva rumena pika
MOV B, 0

loop:
	CMP B, 255
    JE end
	; izrišemo rdečo piko
    MOV A, C
    OUT 8
    MOV A, 224
    OUT 9
    
    ; izrišemo rumeno piko
    MOV A, D
    OUT 8
    MOV A, 252
    OUT 9
    
    ; Nova vrstica
    ADD C, 257
    ADD D, 255
    INC B
    JMP loop

	end:
	HLT