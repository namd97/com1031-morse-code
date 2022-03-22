;;; Morse code encoder - get_digit.S
;;; University of Surrey UG COM1031 coursework
;;; Group 28 -  Matthew Reid, Duncan Nam, Nicholas Adams, Demir Eser

;;; import all symbol definitions for the seven segment display.
#include "7segment.S"

;;; This subroutine converts a number from 0x0 to 0x25 to its digit
;;; representation on the 7-segment-display

;;; Input:
;;; r25: morse character to display
;;; r21: number of signals in character
;;;
;;; Output:
;;; r27: 7-segment representation of the digit
;;;

	.global get_digit

get_digit:
	push r30		; save Z reg lo
	push r31		; save Z reg hi

	andi r25, 0x3F						; make sure r25 is between 0 and 0x3F = 0111111 = 63
	ldi r30, lo8(digit_table)	; make Z point to the table with the higher digits
	ldi r31, hi8(digit_table)

	add r30, r25	   ; the number in r25 is the offset into the table
	brcc 1f		       ; if no overflow from Z low, continue at 1
	inc r31		       ; else add overflow to Z high byte
1:
	lpm r27, Z			; load seven seg representation from the table (in prog memory)

	pop r31					; restore used registers.
	pop r30

	ret							; return from subroutine

;;; This table stores the 7-segment representations for the letters,
;;; numbers, error symbol, and the empty symbol into program memory:
digit_table:
// A-Z = 0-25. 0-9 = 26-35. ERROR = 36. EMPTY = 37
	.byte CHAR_A, CHAR_B, CHAR_C, CHAR_D, CHAR_E, CHAR_F, CHAR_G, CHAR_H, CHAR_I, CHAR_J, CHAR_K, CHAR_L, CHAR_M, CHAR_N, CHAR_O, CHAR_P, CHAR_Q, CHAR_R, CHAR_S, CHAR_T, CHAR_U, CHAR_V, CHAR_W, CHAR_X, CHAR_Y, CHAR_Z, CHAR_0, CHAR_1, CHAR_2, CHAR_3, CHAR_4, CHAR_5, CHAR_6, CHAR_7, CHAR_8, CHAR_9, CHAR_ERROR, CHAR_EMPTY
