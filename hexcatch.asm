#include <msp430.h>
;-------------------------------------------------------------------------------
		ORG	 0C000h 		; Program Start
;--------------------------------------------------------
RESET		mov	 	#400h , SP 			; Initialize stackpointer
StopWDT		mov	 	#WDTPW+WDTHOLD,&WDTCTL          ; Stop WDT
SetupP1		bis.b 	        #0xFF,&P1DIR 	                ; ALL P1 as output
                bic.b           #0xFF,P1OUT         
SetupP2		bis.b 	        #00000011b,&P2DIR 	        ; ALL P2 as output
                bic.b           #00000011b,P2OUT
                
; 40ms Delay goes somewhere around here                
                
                bis.b           #0x38,&P1OUT                    ;Setup 8-bit mode
                call            #SETENABLE                      ;Enable pulse
                bic.b           #0xFF,&P1OUT                    ;Clear P1
                
; 4.1ms delay goes here
;

                bis.b           #0x06,&P1OUT                    ;Entry Mode Set
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear

                bis.b           #0x01,&P1OUT                    ;Clear LCD
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
                
                bis.b           #0x10,&P1OUT                    ;Set Cursor
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
;
                bis.b           #0x0E,&P1OUT                    ;Display ON
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
;                

                call            #FirstLine
                xor.b           #0x2,&P2OUT               ;Enable Data Register               
                call            #DiffTextPrint
                
                xor.b           #0x2,&P2OUT               ;Enable Instruction Register
                call            #SecondLine                
                xor.b           #0x2,&P2OUT               ;Enable Data Register
                
                call            #NamePrint
                
                jmp             $       
                
                
;--------------------------------------------------------
;		Subroutine Set LCD First Line
;--------------------------------------------------------
FirstLine       bis.b           #0x80,&P1OUT                    ;Set first Character of first line
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
                ret                
;--------------------------------------------------------
;		Subroutine Set LCD Second Line
;--------------------------------------------------------
SecondLine      bis.b           #0xC1,&P1OUT                    ;Set first Character of Second line
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear                
                ret
;--------------------------------------------------------
;		Subroutine Call Name
;-------------------------------------------------------- 
NamePrint       mov             #2000, R15
                call            #Wait
                ;-------------------------T
                mov.b           #0x54,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------A
                bis.b           #0x61,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT 
                ;-------------------------R
                bis.b           #0x72,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ;-------------------------I
                bis.b           #0x69,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ;-------------------------K
                bis.b           #0x6B,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ret
                
;--------------------------------------------------------
;		Subroutine Call Difficulty Text
;-------------------------------------------------------- 
DiffTextPrint   mov             #2000, R15
                call            #Wait
                ;-------------------------S
                mov.b           #0x53,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT 
                ;-------------------------l
                bis.b           #0x6C,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ;-------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ;-------------------------c
                bis.b           #0x63,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                
                ;-------------------------t
                bis.b           #0x74,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                
                ;-------------------------M
                bis.b           #0x4D,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                
                ;-------------------------o
                bis.b           #0x6F,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                
                ;-------------------------d
                bis.b           #0x64,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                
                ;-------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT

                ;-------------------------:
                bis.b           #0x3A,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT  

                ret                
                
;--------------------------------------------------------
;		Subroutine Enable Pulse
;-------------------------------------------------------- 
SETENABLE       xor.b           #1,&P2OUT
                mov             #2000, R15
DELAY		dec	        R15 			        ; Decrement R15
		jnz	        DELAY 			        ; Delay over?
CLEARENABLE     xor.b           #1,&P2OUT
                ret
;--------------------------------------------------------
;		Subroutine Wait
;-------------------------------------------------------- 
Wait		dec	        R15 			        ; Decrement R15
		jnz	        Wait 			        ; Delay over?
		ret	                                        ; Go
;--------------------------------------------------------
;		Interrupt Vectors
;--------------------------------------------------------
		ORG 	0FFFEh 			; MSP430 RESET Vector
		DW	RESET 			;
		END