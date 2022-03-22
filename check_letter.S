;;; Morse code encoder - check_letter.S
;;; University of Surrey UG COM1031 coursework
;;; Group 28 -  Matthew Reid, Duncan Nam, Nicholas Adams, Demir Eser

;;;	This subroutine converts a morse character (expressed as binary) and a signal count
;;; into the position of the character in the digit_table

;;; Input:
;;; r25: morse character written in binary. 1 corresponds to dash. 0 corresponds to dot.
;;; r21: number of signals in character
;;;
;;; Output:
;;; r25: position in digit_table of character
;;;

#define __SFR_OFFSET 0
#include <avr/io.h>
.global check_letter
.section .text
check_letter:
	cpi r25, 0x0 ; Compares register 25 to 0
	brne hex_1_test ; If they are not equal, branch for further tests

	cpi r21, 1 ; It's E
	breq LETTER_E ; Branch for letter E if equal
	cpi r21, 2 ; It's I
	breq LETTER_I ; Branch for letter I if equal
	cpi r21, 3 ; It's S
	breq LETTER_S ; Branch for letter S if equal
	cpi r21, 4 ; It's H
	breq LETTER_H ; Branch for letter H if equal
	cpi r21, 5 ; It's 5
	breq LETTER_5 ; Branch for number 5 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_E:
		ldi r25, 4 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_I:
		ldi r25, 8 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_S:
		ldi r25, 18 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_H:
		ldi r25, 7 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_5:
		ldi r25, 31 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_1_test:
	cpi r25, 0x1 ; Compares register 25 to the hex value 1
	brne hex_2_test ; If they are not equal, branch for further tests

	cpi r21, 0 ; It's an empty character
	breq EMPTY_CHAR ; Branch for empty char if equal
	cpi r21, 1 ; It's T
	breq LETTER_T ; Branch for letter T if equal
	cpi r21, 2 ; It's A
	breq LETTER_A ; Branch for letter A if equal
	cpi r21, 3 ; It's U
	breq LETTER_U ; Branch for letter U if equal
	cpi r21, 4 ; It's V
	breq LETTER_V ; Branch for letter V if equal
	cpi r21, 5 ; It's 4
	breq LETTER_4 ; Branch for number 4 if equal
	rjmp error ; It's ERROR. no corresponding character.
	EMPTY_CHAR:
		ldi r25, 37 ; Load the integer value of the character into register 25
		rjmp finish ; Finished, now return
	LETTER_T:
		ldi r25, 19 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_A:
		ldi r25, 0 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_U:
		ldi r25, 20 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_V:
		ldi r25, 21 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_4:
		ldi r25, 30 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_2_test:
	cpi r25, 0x2 ; Compares register 25 to the hex value 2
	brne hex_3_test ; If they are not equal, branch for further tests

	cpi r21, 2 ; It's N
	breq LETTER_N ; Branch for letter N if equal
	cpi r21, 3 ; It's R
	breq LETTER_R ; Branch for letter R if equal
	cpi r21, 4 ; It's F
	breq LETTER_F ; Branch for letter F if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_N:
		ldi r25, 13 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_R:
		ldi r25, 17 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_F:
		ldi r25, 5 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_3_test:
	cpi r25, 0x3 ; Compares register 25 to the hex value 3
	brne hex_4_test ; If they are not equal, branch for further tests

	cpi r21, 2 ; It's M
	breq LETTER_M ; Branch for letter M if equal
	cpi r21, 3 ; It's W
	breq LETTER_W ; Branch for letter W if equal
	cpi r21, 5 ; It's 3
	breq LETTER_3 ; Branch for letter 3 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_M:
		ldi r25, 12 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_W:
		ldi r25, 22 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_3:
		ldi r25, 29 ; Load the integer value of the number into register 25
		rjmp finish ; Finished, now return

hex_4_test:
	cpi r25, 0x4 ; Compares register 25 to the hex value 4
	brne hex_5_test ; If they are not equal, branch for further tests

	cpi r21, 3 ; It's D
	breq LETTER_D ; Branch for letter D if equal
	cpi r21, 4 ; It's L
	breq LETTER_L ; Branch for letter L if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_D:
		ldi r25, 3 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_L:
		ldi r25, 11 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_5_test:
	cpi r25, 0x5 ; Compares register 25 to the hex value 5
	brne hex_6_test ; If they are not equal, branch for further tests

	cpi r21, 3 ; It's K
	breq LETTER_K ; Branch for letter K if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_K:
		ldi r25, 10 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_6_test:
	cpi r25, 0x6 ; Compares register 25 to the hex value 6
	brne hex_7_test ; If they are not equal, branch for further tests

	cpi r21, 3 ; It's G
	breq LETTER_G ; Branch for letter G if equal
	cpi r21, 4 ; It's P
	breq LETTER_P ; Branch for letter P if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_G:
		ldi r25, 6 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_P:
		ldi r25, 15 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_7_test:
	cpi r25, 0x7 ; Compares register 25 to the hex value 7
	brne hex_8_test ; If they are not equal, branch for further tests

	cpi r21, 3 ; It's O
	breq LETTER_O ; Branch for letter O if equal
	cpi r21, 4 ; It's J
	breq LETTER_J ; Branch for letter J if equal
	cpi r21, 5 ; It's 2
	breq LETTER_2 ; Branch for letter 2 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_O:
		ldi r25, 14 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_J:
		ldi r25, 9 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return
	LETTER_2:
		ldi r25, 28 ; Load the integer value of the number into register 25
		rjmp finish ; Finished, now return

hex_8_test:
	cpi r25, 0x8 ; Compares register 25 to the hex value 8
	brne hex_9_test ; If they are not equal, branch for further tests

	cpi r21, 4 ; It's B
	breq LETTER_B ; Branch for letter B if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_B:
		ldi r25, 1 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_9_test:
	cpi r25, 0x9 ; Compares register 25 to the hex value 9
	brne hex_A_test ; If they are not equal, branch for further tests

	cpi r21, 4 ; It's X
	breq LETTER_X ; Branch for letter X if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_X:
		ldi r25, 23 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_A_test:
	cpi r25, 0xA ; Compares register 25 to the hex value A
	brne hex_B_test ; If they are not equal, branch for further tests

	cpi r21, 4 ; It's C
	breq LETTER_C ; Branch for letter C if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_C:
		ldi r25, 2 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_B_test:
	cpi r25, 0xB ; Compares register 25 to the hex value B
	brne hex_C_test ; If they are not equal, branch for further tests

	cpi r21, 4 ; It's Y
	breq LETTER_Y ; Branch for letter Y if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_Y:
		ldi r25, 24 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_C_test:
	cpi r25, 0xC ; Compares register 25 to the hex value C
	brne hex_D_test ; If they are not equal, branch for further tests

	cpi r21, 4 ; It's Z
	breq LETTER_Z ; Branch for letter Z if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_Z:
		ldi r25, 25 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_D_test:
	cpi r25, 0xD ; Compares register 25 to the hex value D
	brne hex_F_test ; If they are not equal, branch for further tests

	cpi r21, 4 ; It's Q
	breq LETTER_Q ; Branch for letter Q if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_Q:
		ldi r25, 16 ; Load the integer value of the letter into register 25
		rjmp finish ; Finished, now return

hex_F_test:
	cpi r25, 0xF ; Compares register 25 to the hex value F
	brne hex_10_test ; If they are not equal, branch for further tests

	cpi r21, 5 ; It's 1
	breq LETTER_1 ; Branch for letter 1 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_1:
		ldi r25, 27 ; Load the integer value of the number into register 25
		rjmp finish ; Finished, now return

hex_10_test:
	cpi r25, 0x10 ; Compares register 25 to the hex value 10
	brne hex_18_test ; If they are not equal, branch for further tests

	cpi r21, 5 ; It's 6
	breq LETTER_6 ; Branch for letter 6 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_6:
		ldi r25, 32 ; Load the integer value of the number into register 25
		rjmp finish ; Finished, now return

hex_18_test:
	cpi r25, 0x18 ; Compares register 25 to the hex value 18
	brne hex_1C_test ; If they are not equal, branch for further tests

	cpi r21, 5 ; It's 7
	breq LETTER_7 ; Branch for letter 7 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_7:
		ldi r25, 33 ; Load the integer value of the number into register 25
		rjmp finish ; Finished, now return

hex_1C_test:
	cpi r25, 0x1C ; Compares register 25 to the hex value 1C
	brne hex_1E_test ; If they are not equal, branch for further tests

	cpi r21, 5 ; It's 8
	breq LETTER_8 ; Branch for letter 8 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_8:
		ldi r25, 34 ; Load the integer value of the number into register 25
		rjmp finish ; Finished, now return

hex_1E_test:
	cpi r25, 0x1E ; Compares register 25 to the hex value 1E
	brne hex_1F_test ; If they are not equal, branch for further tests

	cpi r21, 5 ; It's 9
	breq LETTER_9 ; Branch for letter 9 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_9:
		ldi r25, 35 ; Load the integer value of the number into register 25
		rjmp finish ; Finished, now return

hex_1F_test:
	cpi r25, 0x1F ; Compares register 25 to the hex value 1F
	brne error ; If this isn't equal, then ERROR

	cpi r21, 5 ; It's 0
	breq LETTER_0 ; Branch for letter 0 if equal
	rjmp error ; It's ERROR. no corresponding character.
	LETTER_0:
		ldi r25, 26 ; Load the integer value of the number into register 25
		rjmp finish ; Finished, now return

error: ; Only runs if it can't identify what the character is
	ldi r25, 36 ; 36 is the error character

finish:
	ret ; Return back to whatever called me
