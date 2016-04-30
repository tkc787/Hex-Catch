#include <msp430.h>
;-------------------------------------------------------------------------------
		ORG	 0F800h 		; Program Start
;--------------------------------------------------------
RESET		mov	 #0280h , SP 		; Initialize stackpointer
StopWDT		mov	 #WDTPW+WDTHOLD,&WDTCTL ; Stop WDT
		bis.b	 #01000001b,&P1DIR	; P1.0 as output
		bic.b	 #01000001b,&P1OUT		; Red LED off                
                bic.b    #00011000b,&P2DIR     
                bis.b    #00011000b,&P2OUT      ; Enable P2.3 and P2.4 as Input 
		bis.b	 #00011000b,&P2IE	; Enable Interupt on P2.4                
		eint    			;
HERE		jmp	 HERE			; wait
;-------------------------------------------------------------------------------
; 		P2.4 Interrupt Service Routine
;-------------------------------------------------------------------------------
PBISR		cmp.b   #00010000b,&P2IFG
                jne     ToggleGreen
                bic.b	#00010000b,&P2IFG	; clear interrupt flag
                call    #Delay
		xor.b	#1,&P1OUT		; toggle Red
                jmp     Next
ToggleGreen     bic.b	#00001000b,&P2IFG	; clear interrupt flag
                call    #Delay
		xor.b	#01000000b,&P1OUT       ; toggle Greens
Next            nop                
		reti				;return from ISR

;--------------------------------------------------------
;		Subroutine EasyLevelDelay
;--------------------------------------------------------    
Delay           mov             #50000, R14
L1              nop
                nop
                dec             R14
                jnz             L1
                ret      
;--------------------------------------------------------
;		Interrupt Vectors
;--------------------------------------------------------
		ORG 	0FFFEh 			; MSP430 RESET Vector
		DW	RESET 			; address of label RESET
		ORG	0FFE6h			; interrupt vector 2
		DW	PBISR			; address of label PBISR
		END