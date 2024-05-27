JMP main
JMP isr

vSync: DB 0
posX: DB 150
posY: DB 230
ballPosX: DB 158
ballPosY: DB 212
ballLocked: DB 1
ballVelX: DB 0
ballVelXPos: DB 1
ballVelY: DB 6
ballVelYPos: DB 1
score: DW 0
moveSpeed: DB 4
keyA: DB 0
keyD: DB 0
keySpace: DB 0

isr:
    PUSH A ; The ISR will use register A.
    PUSH B ;
    IN 1              ; Which interrupt event occured?
    CMP A, 4          ; Was it vSync?
    JNE isrKeyboard
    MOVB [vSync], 1    ; If yes, set the vSync flag.
    MOV A, 4          ; vSync interrupt number.
    OUT 2             ; The vSync interrupt has been serviced.
    JMP iret

isrKeyboard:
    IN 5 ; Get the keyboard status .
    AND A, 1111b
    CMP A, 1 ; Is it the keydown event ?
    JE handleKeyDown ; If yes , print out the key code .
    CMP A, 2 ; Keyup event
    JE handleKeyUp

    ; če sta a in d pritisnjena !!hkrati!!, se ne zgodi nič.
    IN 6
    MOVB [keyA], 0 
    MOVB [keyD], 0
    MOVB [keySpace], 0
    JMP keysDone

; normal a in potem d za levo oz desno za obrano
handleKeyDown:
    MOVB BL, 1
    JMP comparison
    
handleKeyUp:
    MOVB BL, 0

comparison:
	IN 6 ; kateri gumbič (a/d)?
    CMP A, ' '
    JE handleSpace
    CMP A, 'a'
    JE handleA
    CMP A, 'd'
    JE handleD
    JMP keysDone

handleA:
    MOVB [keyA], BL
    JMP keysDone

handleD:
    MOVB [keyD], BL
    JMP keysDone

handleSpace:
	CMPB BL, 0
    JNE dontDoAction
    CALL doAction

dontDoAction:
    JMP keysDone

keysDone:
    MOV A, 1 ; Keyboard interrupt mask .
    OUT 2 ; Keyboard has been serviced .

iret:
    POP B
    POP A ; Restore the register A.
    IRET ; Return from ISR .

doAction: ; 
	PUSH A ; pushamo, da ne povozimo registra A
    MOV A, 0
    MOVB AL, [ballLocked] ; locked --> se premika z igralcem. Space jo spusti
    CMPB AL, 1
    JNE actionNotLocked 
	MOVB [ballLocked], 0 ;; resetiral, premaknil, smer pravi kot navzgor
    JMP actionDone

actionNotLocked:
	MOVB [ballLocked], 1
    MOVB [ballVelX], 0

actionDone:
    POP A
	RET

waitNextFrame:
    MOVB AL, [vSync]     ; Get the vSync value.
    CMPB AL, 0           ; If zero, read it again.
    JE waitNextFrame
    MOVB [vSync], 0     ; If non-zero, reset it and return.
    RET

tileDefinitions: ;; sprites motherfucker
; Racket left (0xF0)
    DB "\x00\x00\x09\x57\x12\x2B\x1A\x57\x0D\x2B\x00\x00\x00\x00\x00\x00"
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
; Racket right (0xF1)
	DB "\x00\x00\xEA\x90\xD4\x48\xEB\x18\xD4\xB0\x00\x00\x00\x00\x00\x00"
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
; Ball (0xF2)
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x03\xC0\x05\xA0\x0A\x50\x0D\xB0"
    DB "\x0D\xB0\x0A\x50\x05\xA0\x03\xC0\x00\x00\x00\x00\x00\x00\x00\x00"
; Box left (0xF3)
    DB "\xFF\xFF\x80\x00\xBF\xFF\xA0\x00\xA0\x00\xA0\x00\xA0\x00\xA0\x00"
    DB "\xA0\x00\xA0\x00\xA0\x00\xA0\x00\xA0\x00\xBF\xFF\x80\x00\xFF\xFF"
; Box right (0xF4)
    DB "\xFF\xFF\x00\x01\xFF\xFD\x00\x05\x00\x05\x00\x05\x00\x05\x00\x05"
    DB "\x00\x05\x00\x05\x00\x05\x00\x05\x00\x05\xFF\xFD\x00\x01\xFF\xFF"
; Nothing (0xF5)
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
; Nothing (0xF6)
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
; Nothing (0xF7)
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    DB "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

; -----------------------------------------------------------------------------
; Function: loadVramTiles()
; -----------------------------------------------------------------------------
loadVramTiles:
    MOV C, tileDefinitions
    MOV D, 0x9E00 ; Our custom tiles start at the VRAM address 0x9E00.

loadVramTilesLoop:
    CMP D, 0x9F40 ; Our custom tiles end at the VRAM address 0x9F3F.
    JE loadVramTilesReturn
    MOV A, D      ; Set the VRAM address
    OUT 8         ; through the VIDADDR I/O register.
    MOV A, [C]    ; Load a 16-bit word of the data.
    OUT 9         ; Store it to VRAM.
    ADD C, 2      ; Next 16-bit data.
    ADD D, 2      ; Next VRAM address.
    JMP loadVramTilesLoop

loadVramTilesReturn:
    RET

handleUserInput:
	MOVB AH, [posX]
    MOVB CH, 0
    MOVB CL, [moveSpeed]
    MOVB BL, [keyA]
    CMPB BL, 0
    JE skipA:
    SUBB AH, CL

skipA:
    MOVB BL, [keyD]
    CMPB BL, 0
    JE movFinal:
    ADDB AH, CL

movFinal:
	MOVB [posX], AH
    RET
    
drawPlayer: 
    MOV A, 0xA308
    OUT 8
    MOVB AH, [posX]
    MOVB AL, [posY]
    OUT 9 
    MOV A, 0xA30C
    OUT 8
    MOVB AH, [posX]
    ADDB AH, 16
    MOVB AL, [posY]
    OUT 9 
    RET
    
handleBall:
	MOV A, 0
    MOVB AL, [ballLocked]
    CMPB AL, 1
    JNE notLocked:
    MOVB AH, [posX]
    ADDB AH, 8
    MOVB [ballPosX], AH
    MOVB [ballPosY], 212
    JMP doneHandling

notLocked:
	MOVB BH, [ballVelXPos]
	MOVB AH, [ballPosX]
    CMPB BH, 1
    JE ballXPos
    SUBB AH, [ballVelX]
    JMP ballXDone

ballXPos:
	ADDB AH, [ballVelX]

ballXDone:
    MOVB BL, [ballVelYPos]
    MOVB AL, [ballPosY]
    CMPB BL, 1
	JNE ballYNeg
	SUBB AL, [ballVelY]
    JMP ballYDone

ballYNeg:
    ADDB AL, [ballVelY]

ballYDone:
    MOVB [ballPosX], AH
    MOVB [ballPosY], AL

doneHandling:
	RET
    
handleBallWallCollision:
	MOVB AL, [ballPosY]
    MOVB AH, [ballPosX]
    CMPB AL, 8
    JNB ballNAWall
    MOVB AL, 8
    MOVB [ballVelYPos], 0

ballNAWall:
	CMPB AL, 232
    JNA ballNBWall
    MOVB AL, 232
    MOVB [ballVelYPos], 1
    MOVB [ballVelY], 6
    MOVB [ballVelX], 0
    MOVB [ballLocked], 1

ballNBWall:
	CMPB AH, 8
    JNB ballNLWall
    MOVB AH, 8
    MOVB [ballVelXPos], 1

ballNLWall:
	CMPB AH, 232
    JNA ballNRWall
    MOVB AH, 232
    MOVB [ballVelXPos], 0

ballNRWall:
	MOVB [ballPosY], AL
    MOVB [ballPosX], AH
    RET

incScore:
	MOV A, [score]
    INC A
    CMPB AL, 9
    JNA skipFoldOver
    ADDB AH, 1
    MOVB AL, 0

skipFoldOver:
	MOV [score], A
	RET
    
handleBallPlayerBrickCollisions:
	; player collisiion
    MOVB AH, [ballPosX]
    MOVB AL, [ballPosY]
    MOVB BH, [posX]
    MOVB BL, [posY]
    SUBB BL, AL
    CMPB BL, 16
    JNB dontCheckFPlayer
    ADDB BH, 24
    CMPB AH, BH
    JA dontCheckFPlayer
    SUBB BH, 32
    CMPB AH, BH
    JB dontCheckFPlayer
    SUBB AH, BH
    CMPB AH, 5
    JNB checkSecondRacketStage
    MOVB [ballVelXPos], 0
   	MOVB [ballVelX], 6
    MOVB [ballVelY], 1
 	JMP stopCheckRacket

checkSecondRacketStage:
	CMPB AH, 11
    JNB checkThirdRacketStage
    MOVB [ballVelXPos], 0
   	MOVB [ballVelX], 4
    MOVB [ballVelY], 4
 	JMP stopCheckRacket

checkThirdRacketStage:
	CMPB AH, 15
    JNB checkFourthRacketStage
   	MOVB [ballVelX], 0
    MOVB [ballVelY], 6
 	JMP stopCheckRacket

checkFourthRacketStage:
	CMPB AH, 21
    JNB checkFifthRacketStage
    MOVB [ballVelXPos], 1
   	MOVB [ballVelX], 4
    MOVB [ballVelY], 4
 	JMP stopCheckRacket

checkFifthRacketStage:
	MOVB [ballVelXPos], 1
   	MOVB [ballVelX], 6
    MOVB [ballVelY], 1

stopCheckRacket:
	MOVB [ballVelYPos], 1

dontCheckFPlayer:
    ; brick collision
    ; left top corner
   	MOV A, 0
    MOVB AL, [ballPosY]
    DIV 16
    MOVB BL, AL
    MOVB AL, [ballPosX]
    DIV 16
    MUL 2
    MOVB AH, BL
    MOV B, A
    OUT 8
    IN 9
    CMP A, 0xF3FF
    JE leftUpCornerLeft
    CMP A, 0xF4FF
    JNE doneLeftUpCorner
    MOV A, B
    OUT 8
    MOV A, 0
    OUT 9
    MOV A, B
    SUB A, 2
    OUT 8
    MOV A, 0
    OUT 9
    JMP skipLeftUpCorner

leftUpCornerLeft:
    MOV A, B
    OUT 8
    MOV A, 0
    OUT 9
    MOV A, B
    ADD A, 2
    OUT 8
    MOV A, 0
    OUT 9

skipLeftUpCorner:
	CALL incScore
	MOV A, 0
    MOVB AL, [ballPosY]
    DIV 16
    MUL 16
    MOVB BL, AL
    MOVB AL, [ballPosY]
    SUBB AL, BL
    CMPB AL, 10
    JB leftUpCornerSideCol
    MOVB [BallVelYPos], 0

leftUpCornerSideCol:
	MOVB [BallVelXPos], 1

doneLeftUpCorner:
	; right up corner
    MOV A, 0
    MOVB AL, [ballPosY]
    DIV 16
    MOVB BL, AL
    MOVB AL, [ballPosX]
    ADDB AL, 16
    DIV 16
    MUL 2
    MOVB AH, BL
    MOV B, A
    OUT 8
    IN 9
    CMP A, 0xF3FF
    JE rightUpCornerLeft
    CMP A, 0xF4FF
    JNE doneRightUpCorner
    MOV A, B
    OUT 8
    MOV A, 0
    OUT 9
    MOV A, B
    SUB A, 2
    OUT 8
    MOV A, 0
    OUT 9
    JMP skipRightUpCorner

rightUpCornerLeft:
    MOV A, B
    OUT 8
    MOV A, 0
    OUT 9
    MOV A, B
    ADD A, 2
    OUT 8
    MOV A, 0
    OUT 9

skipRightUpCorner:
	CALL incScore
	MOV A, 0
    MOVB AL, [ballPosY]
    DIV 16
    MUL 16
    MOVB BL, AL
    MOVB AL, [ballPosY]
    SUBB AL, BL
    CMPB AL, 10
    JB rightUpCornerSideCol
    MOVB [BallVelYPos], 0

rightUpCornerSideCol:
	MOVB [BallVelXPos], 0

doneRightUpCorner:
	; bottom left corner
    MOV A, 0
    MOVB AL, [ballPosY]
    ADDB AL, 16
    DIV 16
    MOVB BL, AL
    MOVB AL, [ballPosX]
    DIV 16
    MUL 2
    MOVB AH, BL
    MOV B, A
    OUT 8
    IN 9
    CMP A, 0xF3FF
    JE leftBottomCornerLeft
    CMP A, 0xF4FF
    JNE doneLeftBottomCorner
    MOV A, B
    OUT 8
    MOV A, 0
    OUT 9
    MOV A, B
    SUB A, 2
    OUT 8
    MOV A, 0
    OUT 9
    JMP skipLeftBottomCorner

leftBottomCornerLeft:
    MOV A, B
    OUT 8
    MOV A, 0
    OUT 9
    MOV A, B
    ADD A, 2
    OUT 8
    MOV A, 0
    OUT 9

skipLeftBottomCorner:
	CALL incScore
	MOV A, 0
    MOVB AL, [ballPosY]
    ADDB AL, 16
    DIV 16
    MUL 16
    MOVB BL, AL
    MOVB AL, [ballPosY]
    ADDB AL, 16
    SUBB AL, BL
    CMPB AL, 10
    JB leftBottomCornerSideCol
    MOVB [BallVelYPos], 1

leftBottomCornerSideCol:
	MOVB [BallVelXPos], 1

doneLeftBottomCorner:
	; bottom right corner
    MOV A, 0
    MOVB AL, [ballPosY]
    ADDB AL, 16
    DIV 16
    MOVB BL, AL
    MOVB AL, [ballPosX]
    ADDB AL, 16
    DIV 16
    MUL 2
    MOVB AH, BL
    MOV B, A
    OUT 8
    IN 9
    CMP A, 0xF3FF
    JE rightBottomCornerLeft
    CMP A, 0xF4FF
    JNE stopCheckingBridoneRightBottomCorner
    MOV A, B
    OUT 8
    MOV A, 0
    OUT 9
    MOV A, B
    SUB A, 2
    OUT 8
    MOV A, 0
    OUT 9
    JMP skipRightBottomCorner

rightBottomCornerLeft:
    MOV A, B
    OUT 8
    MOV A, 0
    OUT 9
    MOV A, B
    ADD A, 2
    OUT 8
    MOV A, 0
    OUT 9
skipRightBottomCorner:
	CALL incScore
	MOV A, 0
    MOVB AL, [ballPosY]
    ADDB AL, 16
    DIV 16
    MUL 16
    MOVB BL, AL
    MOVB AL, [ballPosY]
    ADDB AL, 16
    SUBB AL, BL
    CMPB AL, 10
    JB rightBottomCornerSideCol
    MOVB [BallVelYPos], 1
rightBottomCornerSideCol:
	MOVB [BallVelXPos], 0
stopCheckingBridoneRightBottomCorner:
stopCheckingBrickColl:
    RET

drawBall: 
    MOV A, 0xA310
    OUT 8
    MOVB AH, [ballPosX]
    MOVB AL, [ballPosY]
    OUT 9 
    RET

drawDegub: 
    MOVB AH, [keyA]
    ADDB AH, 0x30
    MOVB AL, [keyD]
    ADDB AL, 0x30
    MOV [0x1000], A
    MOV A, [posX]
    ADDB AH, 0x30
    ADDB AL, 0x30
    MOV [0x1003], A
    MOV A, [posY]
    ADDB AH, 0x30
    ADDB AL, 0x30
    MOV [0x1006], A
    RET

handleRacketCollisions:
	; border collisions
    MOVB AH, [posX]
    CMPB AH, 5
    JNB colNotLeft
    MOVB AH, 5
colNotLeft:
	CMPB AH, 216
    JBE colNotRight
    MOVB AH, 216
colNotRight:
	MOVB [posX], AH
    RET
  
doMap:
    MOVB BH, 1
    MOVB BL, 1
    MOVB CL, 0
    doLoop:
    	CMPB BL, 5
        JA loopDone
        MOV A, 0
        MOVB AL, BH
        MUL 2
        MOVB AH, BL
        OUT 8
        CMPB CL, 1
        JE endBox
        MOV A, 0xF3FF
        OUT 9
        MOVB CL, 1
        JMP doneBox
    endBox:
    	MOV A, 0xF4FF
        OUT 9
        MOVB CL, 0
    doneBox:
        INCB BH
        CMPB BH, 15
        JB doLoop
        MOVB BH, 1
        ADDB BL, 1
        JMP doLoop
    loopDone:
    RET

drawScore:
	MOVB [0x1000], 'S'
    MOVB [0x1001], 'C'
    MOVB [0x1002], 'O'
    MOVB [0x1003], 'R'
    MOVB [0x1004], 'E'
    MOVB [0x1005], ':'
    MOV A, 0
    MOV A, [score]
    ADDB AH, 0x30
    ADDB AL, 0x30
    MOV [0x1007], A
    RET

main:
    MOV SP, 0x0FFF ; Initialize the stack pointer .
    MOV A, 5 ; Keyboard and vSync interrupt mask .
    OUT 0 ; Set the mask.
    STI ; Enable interrupts .

    MOV A, 1
    OUT 7 ; VIDMOVE -> text mode
    MOV A, 3
    OUT 7 ; clear display
;   CALL drawChar
	CALL loadVramTiles

	MOV A, 0xA300
    OUT 8
    MOV A, 0x0
    OUT 9

	MOV A, 0xA306
    OUT 8
    MOV A, 0xF0FF
    OUT 9
    
    MOV A, 0xA30A
    OUT 8
    MOV A, 0xF1FF
    OUT 9
    
    MOV A, 0xA30E
    OUT 8
    MOV A, 0xF2FF
    OUT 9

	CALL doMap
    
    gameLoop:
      	CALL handleUserInput
        CALL handleRacketCollisions
        CALL handleBall
        CALL handleBallWallCollision
        CALL handleBallPlayerBrickCollisions
        CALL drawScore
        CALL drawPlayer
        CALL drawBall
        CALL waitNextFrame     ; Wait for the vSync flag.
      	JMP gameLoop  
   
    HLT