;THIS PROGRAM INPUTS TEN INTEGERS AND THEN PRINTS THE LARGEST 
;INDEC expects an unsigned value to be typed at the keyboard 
;and it returns the unsigned value in AX taken from AX
;OUTDEC outputs an unsigned value to the screen
;taken from AX
;NEWLINE outputs a carriage return & linefeed to the screen

.model small

count	equ	10		;INTEGERS TO COMPARE
BDOS    EQU 21h
CR      EQU 0dh
LF      EQU 0ah

.stack 100h 
.data
	biggest	dw	0	;CURRENT LARGEST
.code
	mov	cx,count	;initialises loop
	mov	biggest,0	;sets largest to 0

next:	call	indec		;input a number
	call	newline		;output a newline
	cmp	ax,biggest	;compare with the current
	jbe	outnum		;< OR =
	mov	biggest,ax	;>, record new largest
outnum:	loop next		;loop for next number
	
	call	newline		;output a newline
	mov	ax,biggest	;set up for output
	call	outdec		;output the largest number
	call	newline		;output a new line

	mov ah,4cH
	int 21H			;terminates program

public INDEC, OUTDEC, NEWLINE

INDEC   PROC    NEAR    ;INPUT PROCEDURE
        PUSH    BX      ;SAVE REGISTERS
        PUSH    CX
        PUSH    DX
        XOR     BX,BX   ;CLEAR N
INDEC0: PUSH    BX      ;SAVE N
        CALL    GETC    ;GET NEXT CHARACTER
        POP     BX      ;RESTORE N
        CMP     AL,'0'  ;< 0?
        JB      INDEC2  ;YES
        CMP     AL,'9'  ;> 9?
        JA      INDEC2  ;YES
        SUB     AL,'0'  ;GET DECIMAL DIGIT
INDEC1: PUSH    AX      ;SAVE DIGIT
        MOV     AX,10   ;MULTIPLY N BY 10
        MUL     BX
        MOV     BX,AX
        POP     AX      ;RESTORE DIGIT
        XOR     AH,AH
        ADD     BX,AX   ;ADD IN DIGIT
        JMP     INDEC0  ;GET NEXT DIGIT
INDEC2: MOV     AX,BX   ;RETURN N IN AX
        POP     DX      ;RESTORE REGISTERS
        POP     CX
        POP     BX
        RET
INDEC   ENDP


OUTDEC  PROC            ;OUTPUT PROCEDURE
        PUSH    AX      ;SAVE REGISTERS
        PUSH    BX
        PUSH    CX
        PUSH    DX
        XOR     CL,CL   ;INITIALISE DIGIT COUNT
        MOV     BX,10   ;SET UP DIVISOR
OUTD1:  XOR     DX,DX   ;ZERO HIGH ORDER WORD OF DIVIDEND
        DIV     BX      ;DIVIDE BY 10
        PUSH    DX      ;SAVE REMAINDER ON STACK
        INC     CL      ;BUMP COUNT
        CMP     AX,0    ;ANYTHING LEFT?
        JA      OUTD1   ;YES, GET NEXT DIGIT
        XOR     CH,CH   ;ZERO HIGH ORDER BYTE OF COUNT
                        ;FOR LOOP
OUTD2:  POP     AX      ;GET A DIGIT FROM STACK
        ADD     AL,'0'  ;GET CHARACTER CODE FROM DIGIT
        PUSH    CX      ;SAVE CX
        CALL    PUTC    ;OUTPUT THE DIGIT
        POP     CX      ;GET CX BACK
        LOOP    OUTD2   ;LOOP TILL CL=0
        POP     DX      ;RESTORE REGISTERS
        POP     CX
        POP     BX
        POP     AX
        RET             ;RETURN TO CALLER
OUTDEC  ENDP


NEWLINE PROC    NEAR    ;NEWLINE OUTPUT PROCEDURE
        PUSH    AX      ;SAVE REGISTERS
        PUSH    BX
        PUSH    CX
        PUSH    DX
        MOV     AL,CR   ;GET CR CHARACTER
        CALL    PUTC    ;OUTPUT
        MOV     AL,LF   ;GET LF CHARACTER
        CALL    PUTC    ;OUTPUT
        POP     DX      ;RESTORE REGISTERS
        POP     CX
        POP     BX
        POP     AX
        RET             ;RETURN TO CALLER
NEWLINE ENDP


PUTC    PROC    NEAR    ;CHARACTER OUTPUT PROCEDURE
        PUSH    AX      ;SAVE REGISTERS
        PUSH    BX
        PUSH    CX
        PUSH    DX
        MOV     DL,AL
        MOV     AH,02H  ;CALL OS FUNCTION 2
        INT     BDOS
        POP     DX      ;RESTORE REGISTERS
        POP     CX
        POP     BX
        POP     AX
        RET             ;RETURN TO CALLER
PUTC    ENDP


GETC    PROC    NEAR    ;CHARACTER INPUT PROCEDURE
        PUSH    BX      ;SAVE REGISTERS
        PUSH    CX
        PUSH    DX
        MOV     DL,AL
        MOV     AH,01H  ;CALL OS FUNCTION 1
        INT     BDOS
        POP     DX      ;RESTORE REGISTERS
        POP     CX
        POP     BX
        RET             ;RETURN TO CALLER
GETC    ENDP

end