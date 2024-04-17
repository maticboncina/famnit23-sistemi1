; vključimo grafično kartico 
MOV A, 2 ; bitmap mode 2
OUT 7

; pobrišemo zaslon
MOV A, 3
OUT 7

loop:
	; aktiviramo VRAM naslov 0x7f7f
    ; MOV A, 0x7F7F
	IN 10
	OUT 8
    
    ; kaj se na tem zaslonu dogaja
    IN 9
    CMPB AL, 0
    JNE loop

	; zapišemo barvo 0x1F
	; MOV A, 0x001F
    IN 10 ; RNDGEN -> A
	OUT 9
    
    ; ali je uporabik pritisnih tipko
    IN 5
    CMP A, 0
    JE loop
	HLT