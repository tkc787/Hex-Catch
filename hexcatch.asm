#include <msp430.h>
;-------------------------------------------------------------------------------
		ORG	 0C000h 		; Program Start
;--------------------------------------------------------
RESET		mov	 	#400h , SP 			; Initialize stackpointer
StopWDT		mov	 	#WDTPW+WDTHOLD,&WDTCTL          ; Stop WDT
SetupP1		bis.b 	        #0xFF,&P1DIR 	                ; ALL P1 as output
                bic.b           #0xFF,P1OUT         
SetupP2		bis.b 	        #00011011b,&P2DIR 	        ; ALL P2 as output
                bic.b           #00011011b,P2OUT
                
; 40ms Delay goes somewhere around here                
                
                bis.b           #0x38,&P1OUT                    ;Setup 8-bit mode
                call            #SETENABLE                      ;Enable pulse
                bic.b           #0xFF,&P1OUT                    ;Clear P1
                
; 4.1ms delay goes here
;

;                bis.b           #0x06,&P1OUT                    ;Entry Mode Set
;                call            #SETENABLE                      ;Enable Pulse
;                bic.b           #0xFF,&P1OUT                    ;Clear

                bis.b           #0x01,&P1OUT                    ;Clear LCD
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
                
                bis.b           #0x10,&P1OUT                    ;Set Cursor
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
;
                bis.b           #0x0C,&P1OUT                    ;Display ON
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
;                
                bic.b           #0x2,&P2OUT               ;EnableIR
                call            #FirstLine
                bis.b           #0x2,&P2OUT               ;Enable Data Register               
                call            #DiffTextPrint
                
;                xor.b           #0x2,&P2OUT               ;Enable Instruction Register
;                call            #SecondLine                
;                xor.b           #0x2,&P2OUT               ;Enable Data Register
                
CounterInit     mov.b           #10, R11
                mov.b           #0x2F,R12       
Print0_9        bic.b           #0x2,&P2OUT
                call            #SecondLine
                bis.b           #0x2,&P2OUT
                call            #EasyLevelDelay                
                call            #LCDNumberPrint
                dec             R11
                jnz             Print0_9
                
                mov.b           #6, R11
                mov.b           #0x40, R12
PrintA_F        bic.b           #0x2,&P2OUT
                call            #SecondLine
                bis.b           #0x2,&P2OUT
                call            #EasyLevelDelay                
                call            #LCDNumberPrint
                dec             R11
                jnz             PrintA_F                
                jmp             CounterInit

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
;		Subroutine Set LCD First Line
;--------------------------------------------------------
FirstLine       bis.b           #0x80,&P1OUT                    ;Set first Character of first line
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear                
                ret                
;--------------------------------------------------------
;		Subroutine Set LCD Second Line
;--------------------------------------------------------
SecondLine      bis.b           #0xC0,&P1OUT                    ;Set first Character of Second line
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
                ret
;--------------------------------------------------------
;		Subroutine NumberPrint
;-------------------------------------------------------- 
LCDNumberPrint  add.b           #1b,R12
                mov.b           R12, P1OUT
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
;		Subroutine HardLevelDelay
;--------------------------------------------------------    
HardLevelDelay  mov             #20000, R14
                dec             R14
                nop
                nop
                jnz             HardLevelDelay
                ret
 
;--------------------------------------------------------
;		Subroutine HardLevelDelay
;--------------------------------------------------------    
MedLevelDelay   mov             #20000, R14
                dec             R14
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                jnz             MedLevelDelay
                ret
;--------------------------------------------------------
;		Subroutine EasyLevelDelay
;--------------------------------------------------------    
EasyLevelDelay  mov             #20000, R14
L1              nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                dec             R14
                jnz             L1
                ret                 
 
;--------------------------------------------------------
;		Subroutine Enable Pulse
;-------------------------------------------------------- 
SETENABLE       xor.b           #1,&P2OUT
                mov             #2000, R15    
DELAY		dec	        R15 			        ; Decrement R15
		jnz	        DELAY                                              ; Delay over?
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