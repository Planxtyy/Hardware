;THIS PROGRAM INPUTS TEN INTEGERS AND THEN PRINTS THE LARGEST 
;INDEC expects an unsigned value to be typed at the keyboard 
;and it returns the unsigned value in AX taken from AX
;OUTDEC outputs an unsigned value to the screen
;taken from AX
;NEWLINE outputs a carriage return & linefeed to the screen

.model small

count	equ	10		;INTEGERS TO COMPARE

.stack 100h 
.data
	biggest	dw	0	;CURRENT LARGEST
.code
	extrn	outdec	: proc
	extrn	newline	: proc
	extrn	indec	: proc
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

end