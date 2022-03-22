;;; Morse code encoder - group_28.S
;;; University of Surrey UG COM1031 coursework
;;; Group 28 -  Matthew Reid, Duncan Nam, Nicholas Adams, Demir Eser

;;  desired clock cycles = clock frequency x delay required / (prescalar * 256) - the 256 is to skip the low bype of the 16bit timer
CPU_FREQ = 16000000
TICKS_PER_SEC = CPU_FREQ / (256 * 1024)

DECISION_LIMIT = TICKS_PER_SEC / 5 		; 200ms
TIMEOUT = 2 * TICKS_PER_SEC / 5	   		; 400ms
;;; include all port definitions
#define __SFR_OFFSET 0
#include <avr/io.h>

;;; Button is connected to PIN 8, PORTB Bit 0, because that doubles as the ICP1 for timer1.
BUTTON = 0

;;; Input:
;;; ICP1: PORTB Bit 0, standard button input
;;;
;;; Output:
;;; PORTD, Bits 1-7: seven segment display connected to these pins.

	;;; include all symbol definitions for the seven segement display:
	#include "7segment.S"
	#inclide "check_letter.S"
	.section .text
	.global main

;;; this is the entry point to the user code, called from init.S. We
;;; do the setup of ports, timer and interrupts, then we go to an
;;; eternal loop because all the work is done in the interrupt service
;;; routines.
main:
	ldi r24, ALL_SEGS
	out DDRD, r24 ; make pins of PORTD output (except pin 0)   ;

	;; setup for the button, DDRB0 is automatically an input.
	sbi PORTB, BUTTON ; switch on the pull-up.
										; Released button is 1, depressed button read as 0.

	;; set up the timer ([ATmega328p], Section 15.11.1 (p126))

	clr r24
	sts TCCR1A, r24 ; setting timer output mode: no output
									; pin used, normal counting up.

	ldi r24, TIMEOUT	; time in 16ms ticks to detect a TIMEOUT,
										; about 400ms.
										; long and short button presses.
	sts OCR1AH, r24		; move into high byte of compare match
										; register A

	clr r24			; low byte of compare match is just 0.
	sts OCR1AL, r24   ; note 16bit registers always have to
										; be written high byte first, see
										; [ATmega328p], Chapter 15.3, p 106

	;; enable input capture interrupt (to time button presses) and
	;; compare match interrupt (the TIMEOUT to decide if long-press or
	;; to display the character)
	ldi r24, _BV(ICIE1) | _BV(OCIE1A)
	sts TIMSK1, r24

	;; enable noise canceller, set prescaler to 1024, and start
	;; timer in CTC mode, [ATmega328p] section  15.11.2, p128

	ldi r24,  _BV(ICNC1) | _BV(CS12) | _BV(CS10) | _BV(WGM12)
	sts TCCR1B, r24

	clr r19			; reset overflow flag to defined state
	clr r21			; reset the signal count buffer (redundant)
	clr r25			; reset the buffer storing the inputs (redundant)
	clr r27			; clear the character to be displayed (redundant)

	sei					; enable interrupts globally.

	rcall clear_display ; clear the seven segment display before starting

infinite_loop:
	rjmp infinite_loop 	; wait for the interrupts to occur -- forever.
;; end of setup


;;; This interrupt service routine is called whenever timer1 has
;;; counted up to match the value stored in OCA1, ie when more than
;;; TIMEOUT time has elapsed since the last button press or release.

	.global timer1_compa_isr  ; export symbol to overwrite weak
														; definition in init.S

;;; This is the start of the interrupt service routine: push all registers you use in the ISR for a local state.
timer1_compa_isr:
	push r24	; because we use it in the ISR: button release or press
						;  in this ISR, we reused r24 to update the ports
	in r24, SREG		; save the status register.
	push r24

	;; check whether we are waiting for a button press or release:
	lds r24, TCCR1B		; load in the register holding the state of the ICP1 / PORTB0 button
	sbrs r24, ICES1 	; skip next line if waiting for positive edge (ie for button release)
	rjmp awaiting_press

awaiting_release:
	;;  make sure also an overly long press is always recognised
	;;  as a long press, irrespective of a timer overrun:
	ser r19 ; using r19 as a flag to indicate a
					; timer overflow has occured. Must maintain this state between interrupts
	rjmp 1f

awaiting_press:
	;; if we are waiting for a button press, then more time than
	;; 400ms has elasped since the last release -- in this case
	;; we draw the character to the seven segment display

; render begins
		cpi r21, 0x0					; check if an input has been received and counted
		breq no_char_change		; if not, just draw the character stored in r27
			rcall check_letter	; if so, get the position of the character in the digit_table
			rcall get_digit 		; save the corresponding character data to r27
			clr r21							; clear the count buffer
			clr r25							; clear the input buffer
	no_char_change:
		out PORTD, r27 				; transfer stored character into PORTD to display it
; render ends

	1:
	pop r24
	out SREG, r24 	; restore status register in reverse order of pushing
	pop r24

	reti


;;; This interrupt service routine times the duration of button
;;; presses. It is also involved in timing button releases as it
;;; always resets timer1 when called.
;;; It is called whenever the signal at ICP1 (PORTB0) changes in a
;;; certain direction. If we are called for a negative edge (button
;;; has just been depressed), we go on waiting for a positive edge
;;; (button will be released) and vice-versa.

	.global timer1_cpt_isr

timer1_cpt_isr:

	push r17		; use it to check the button release or press, and update the next status
	push r24	 	; we use this register to update the ports

	push r8			; use it to store the timer count

	in r8, SREG 		; save the status register.
	push r8


	lds r8, ICR1L		; get the timer count when the capture event happened.
	lds r8, ICR1H   ; we discard the low part, only
									; interested in the high part, but
									; reading low byte is necessary to get
									; a correct high byte in ICR1H, see
									; documentation [ATmega328p] Section 15.11.7 p131
	mov r17,r19			;  If there is no timer-overflow (ie a
									;  very long button press and
	or r17,r8				;  ICR1H is still zero, then
									;  less than 16ms have elapsed since
									;  last release or press.
	breq  end_isr 	;  End the interrupt

	clr r17
	sts TCNT1H, r17 	; reset timer, first writing the high byte to the latch
	sts TCNT1L, r17		; then the low byte -- Section 16.3 of [328] again.

	;; check whether the input was a button press or release:
	lds r17, TCCR1B		; load in the register holding the state of the ICP1 / PORTB0 button
	sbrs r17, ICES1 	; skip next line if waiting for positive edge (ie for button release)
	rjmp pressed

released:
	;;  make sure also an overly long press is always recognised
	;;  as a long press, irrespective of a timer overrun:

	andi r17, ~(_BV(ICES1)) ; we have had positive edge, so next
													; time looking for negative edge


	tst r19 	; Did we have a timer overflow
						; (ie more than TIMEOUT time since the
						; last released of the button?
	brne long_press		; if yes, then signal is a long
										; press in any case

	;; is the signal longer than DECISION_LIMIT?
	ldi r24, DECISION_LIMIT
	cp r8,r24
	brcs short_press	; if it is shorter jump to label short

long_press:
	lsl r25 		; Logical Shift Left the input buffer;											 e.g. 00101 => 01010
	inc r25 		; increment the input buffer to make the right-most bit a 1; e.g. 01010 => 01011
	rjmp press_common_code		; end updating ports

short_press:
	lsl r25			; Logical Shift Left the input buffer;											 e.g. 00101 => 01010
	rjmp press_common_code		; end updating ports

pressed:
	ori r17, _BV(ICES1)	; next time detect positive edge, ie a
											; button release.
	sts TCCR1B, r17 		; write r17 to TCCR1B to activate the
											; change in edge detection.
	rcall clear_display	; button just pressed, so clear the seven segment display
	rjmp  end_isr			 	; End the interrupt

press_common_code:
	inc r21						; increment the counter buffer, so we know how many signals are in the character
	sts TCCR1B, r17 	; write r17 to TCCR1B to activate the
										; change in edge detection.
	clr r19						; clear overflow flag in case it was set

end_isr:
	pop r8
	out SREG, r8 	; restore status register
	pop r8
	pop r24
	pop r17
	reti

;;; subroutines to be RCALLed as needed
clear_display:
	push r25  			; to use r25 as a local register, save it to stack
	ldi r25, 37			; load the position of the empty character in the digit_table into r25

	rcall get_digit ; save the empty character data to r27
	out PORTD, r27	; transfer stored character into PORTD to display it

	pop r25 				; restore r25 to original state, remove from stack
	ret							; return to caller
