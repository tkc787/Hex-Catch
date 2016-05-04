#include <msp430.h>
;-------------------------------------------------------------------------------
		ORG	 0C000h 		; Program Start
;-------------------------------------------------------------------------------
RESET		mov	 	#400h , SP 		; Initialize stackpointer
StopWDT		mov	 	#WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
; Code For Setting PIN input and outputs
SetupP1		bis.b 	        #0xFF,&P1DIR 	        ; ALL P1 as output for LCD
                bic.b           #0xFF,P1OUT         
SetupP2		bis.b 	        #00000011b,&P2DIR 	; ALL P2 as output
                bic.b           #00000011b,P2OUT
		bis.b	        #00011000b,&P2IE	; Enable Interupt on 
                                                        ; P2.4 and P2.3                                                                
                bis.b           #0x38,&P1OUT            ;Setup 8-bit mode
                call            #SETENABLE              ;Enable pulse
                bic.b           #0xFF,&P1OUT            ;Clear P1

                bis.b           #0x01,&P1OUT            ;Clear LCD
                call            #SETENABLE              ;Enable Pulse
                bic.b           #0xFF,&P1OUT            ;Clear
                
                bis.b           #0x10,&P1OUT            ;Set Cursor
                call            #SETENABLE              ;Enable Pulse
                bic.b           #0xFF,&P1OUT            ;Clear
;
                bis.b           #0x0C,&P1OUT            ;Display ON
                call            #SETENABLE              ;Enable Pulse
                bic.b           #0xFF,&P1OUT            ;Clear
                jmp             Game

;-------------------------------------------------------------------------------
; 		GameOver State 
;               Logic that prints the game over texts and restarts the game
;------------------------------------------------------------------------------- 
GameOver	call            #ClrLine2             
                bis.b           #0x47,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------a
                bis.b           #0x61,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------m
                bis.b           #0x6D,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
		;--------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------O
                bis.b           #0x4F,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
		;--------------------------w
                bis.b           #0x76,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------r
                bis.b           #0x72,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT             
                mov             #20,R15        
GameOverLoop    call            #Delay
                dec             R15
                jnz             GameOverLoop        
                jmp             RESET
;-------------------------------------------------------------------------------
; 		Victory State
;               Displays you win message in LCD and resets game
;-------------------------------------------------------------------------------   
Victory		call            #ClrLine2
                ;--------------------------Y
                bis.b           #0x59,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------o
                bis.b           #0x6F,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------u
                bis.b           #0x75,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------w
                bis.b           #0x77,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------i
                bis.b           #0x69,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------n
                bis.b           #0x6E,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------!
                bis.b           #0x21,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                mov             #10,R6
                mov             #20,R15        
VictoryLoop     call            #Delay
                dec             R15
                jnz             VictoryLoop
                jmp             RESET
;-------------------------------------------------------------------------------
; 		Game Initial State
;               Logic that configures the registers that will be used in
;               the rest of the code and initiates Difficulty toggle
;               Return 0 to R6
;               Return 7 to R7--Default Reference Value--
;               Return 0 to R15--Counter for difficulty toggle--
;               Return Multiplier to R4
;-------------------------------------------------------------------------------
Game            clr             R6
                mov             #7,R7                ; Initial Game Setup
                clr             R8                   
                clr             R5                   
                mov             #0xFF,R9             ; Clr Game Start Flag
                clr             R11                  ;Setup Win Lose Value
                clr             R15
                eint                                 
LSelect         mov             #1,R6
                bic.b           #0x2,&P2OUT          ;EnableIR
                call            #FirstLine
                bis.b           #0x2,&P2OUT          ;Enable Data Register
                call            #DiffTextPrint
DefaultDiff     call            #ClrLine2
                call            #EasyText
                mov             #4, R4               ; Set Easy Level Multiplier
                inc             R15                
MainLoop        cmp             #1, R9
                jne             MainLoop
;-------------------------------------------------------------------------------
; 		Level0 Transistor
;               Configure R6 as a status flag for button usage, configures R10
;               with the losing difference, sets R9 as active game flag
;               displays current state namein the LCD.
;-------------------------------------------------------------------------------
LTRANSISTOR     mov             #1,R6
                mov             #4,R10
                mov             #0,R9
                call            #ClrLine2                
                call            #ClrLine1
		;---------------------------T
                bis.b           #0x54,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------a
                bis.b           #0x61,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
		;---------------------------r
                bis.b           #0x72,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------i
                bis.b           #0x69,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------K
                bis.b           #0x6B,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                               
                call            #GameCounter
                call            #GameController
                cmp             #1,R11
                jeq             ToL1
                call            #GameOver
ToL1            jmp             LNAND
;-------------------------------------------------------------------------------
; 		Level1 NAND
;               Configure R6 as a status flag for button usage, configures R10
;               with the losing difference, sets R9 as active game flag
;               displays current state namein the LCD.
;-------------------------------------------------------------------------------
LNAND           mov             #1,R6
                mov             #4,R10
                mov             #0,R9
                call            #ClrLine1           
		;--------------------------N
                bis.b           #0x4E,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------A
                bis.b           #0x41,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------N
                bis.b           #0x4E,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------D
                bis.b           #0x44,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                
                call            #GameCounter
                call            #GameController
                cmp             #1,R11
                jeq             ToL2        
                call            #GameOver                
ToL2            jmp             LFLIPFLOP
;-------------------------------------------------------------------------------
; 		Level2 FLIP FLOP
;               Configure R6 as a status flag for button usage, configures R10
;               with the losing difference, sets R9 as active game flag
;               displays current state namein the LCD.
;-------------------------------------------------------------------------------
LFLIPFLOP       mov             #1,R6
                mov             #3,R10
                mov             #0,R9
                call            #ClrLine1            
		;--------------------------F
                bis.b           #0x46,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------l
                bis.b           #0x6C,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------i
                bis.b           #0x69,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------p
                bis.b           #0x70,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------space
                bis.b           #0x10,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT	
		;--------------------------F
                bis.b           #0x46,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------l
                bis.b           #0x6C,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------o
                bis.b           #0x6F,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------p
                bis.b           #0x70,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT

                call            #GameCounter
                call            #GameController
                
                cmp             #1,R11
                jne             LNAND
                jmp             LCOUNTER               
;-------------------------------------------------------------------------------
; 		Level3 REGISTER
;               Configure R6 as a status flag for button usage, configures R10
;               with the losing difference, sets R9 as active game flag
;               displays current state namein the LCD.
;-------------------------------------------------------------------------------
LREGISTER       mov             #1,R6
                mov             #3,R10
                mov             #0,R9
                call            #ClrLine1          
		;--------------------------R
                bis.b           #0x52,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------g
                bis.b           #0x67,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------i
                bis.b           #0x69,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------s
                bis.b           #0x73,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT		
		;--------------------------t
                bis.b           #0x74,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------r
                bis.b           #0x72,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                
                call            #GameCounter
                call            #GameController
                cmp             #1,R11
                jne             LFLIPFLOP
                jmp             LCOUNTER                
;-------------------------------------------------------------------------------
; 		Level4 COUNTER
;               Configure R6 as a status flag for button usage, configures R10
;               with the losing difference, sets R9 as active game flag
;               displays current state namein the LCD.
;-------------------------------------------------------------------------------
LCOUNTER         mov            #1,R6
                 mov            #3,R10
                 mov            #0,R9
                call            #ClrLine1                 
		;--------------------------C
                bis.b           #0x43,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------o
                bis.b           #0x6F,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------u
                bis.b           #0x75,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------n
                bis.b           #0x6E,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------t
                bis.b           #0x74,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT		
		;--------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------r
                bis.b           #0x72,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT

                call            #GameCounter
                call            #GameController
                cmp             #1,R11
                jne             LREGISTER
                jmp             LALU                
;-------------------------------------------------------------------------------
; 		Level5 ALU
;               Configure R6 as a status flag for button usage, configures R10
;               with the losing difference, sets R9 as active game flag
;               displays current state namein the LCD.
;-------------------------------------------------------------------------------
LALU            mov             #1,R6
                mov             #2,R10
                mov             #0,R9
                call            #ClrLine1                
		;--------------------------A
                bis.b           #0x41,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------L
                bis.b           #0x4C,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------U
                bis.b           #0x55,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                
                call            #GameCounter
                call            #GameController
                cmp             #1,R11
                jne             LREGISTER
                jmp             LCPU                
;-------------------------------------------------------------------------------
; 		Level6 CPU
;               Configure R6 as a status flag for button usage, configures R10
;               with the losing difference, sets R9 as active game flag
;               displays current state namein the LCD.
;-------------------------------------------------------------------------------
LCPU            mov             #1,R6
                mov             #0,R10
                mov             #0,R9
                call            #ClrLine1                
		;--------------------------C
                bis.b           #0x43,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------P
                bis.b           #0x50,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------U
                bis.b           #0x55,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                
                call            #GameCounter
                call            #GameController
                cmp             #1,R11
                jne             LCOUNTER
                jmp             LMCU                
;-------------------------------------------------------------------------------
; 		Level7 MCU
;               Print MCU text in LCD
;-------------------------------------------------------------------------------
LMCU            nop
		;--------------------------M
                bis.b           #0x4D,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------C
                bis.b           #0x43,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
		;--------------------------U
                bis.b           #0x55,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                call            #Victory                
;-------------------------------------------------------------------------------
; 		Interrupt Service Rutine
;               Performs logic for verifying if either red or white button 
;               was pressed the counter and selecting defficulty
;               while in toggle difficulty mode. 
;               Returns a 0 to R6 meaning that red button was pressed and
;               game counter should stop. Also stores the number currently
;               displayed in the LCD in R5 for GameController subroutine use
;-------------------------------------------------------------------------------
PBISR		call            #Delay
RedButton       bit.b           #00010000b,&P2IFG
                jnc             WhiteBtn
                clr             R6
                mov             #1,R9
;                mov             R8,R5
                clr             R15              
                jmp             INTEROUT
WhiteBtn        call            #SelectButton
INTEROUT        bic.b	        #00011000b,&P2IFG	; clear interrupt flag        
                reti				        ; return from ISR
;-------------------------------------------------------------------------------
; 		Select Button Logic
;               Logic for toggling between difficulties. Sets R6 to 0 for 
;-------------------------------------------------------------------------------                
SelectButton    clr             R6
                cmp             #0,R9
                jne             StartToggle
DoReset         call            #RESET         
StartToggle     cmp             #0,R15
                jeq             TextPrint1 
                cmp             #1,R15
                jeq             TextPrint2
                cmp             #2,R15
                jeq             TextPrint3                
TextPrint1      call            #ClrLine2
                call            #EasyText
                mov             #8, R4                    ; Set Easy Level Multiplier
                inc             R15
                jmp             IFELOUT        
TextPrint2      call            #ClrLine2
                call            #MediumText
                mov             #2, R4                   ; Set Medium Level Multiplier                                
                inc             R15
                jmp             IFELOUT 
TextPrint3      call            #ClrLine2
                call            #HardText
                mov             #1, R4                   ; Set Hard Level Multiplier        
                mov             #0,R15
                jmp             IFELOUT                 
IFELOUT         ret   
;-------------------------------------------------------------------------------
;		Subroutine GameCounter
;               Logic for Incrementing the game counter and displayin the text
;               in the LCD. Receives R6 value as flag for breaking out of the
;               counter loop. Recieves a value stored in R4 which determines the
;               difficulty multiplier for the delay.
;               R4 value is set in the WhiteButton subroutine.
;               Returns value to be printed in LCD in R12
;-------------------------------------------------------------------------------
GameCounter     bic.b           #0x2,&P2OUT             ;Enable Instruction Register
                call            #SecondLine                
                bis.b           #0x2,&P2OUT             ;Enable Data Register       
                mov.b           #0, R8
                mov.b           #0x2F,R12
Print0_9        bic.b           #0x2,&P2OUT
                call            #SecondLine
                bis.b           #0x2,&P2OUT
                mov.b           R4,R13                           
                call            #LCDNumberPrint
                bit             R6,R6
                jz              LoopOut
                inc             R8              
                cmp             #10,R8
                jne             Print0_9               
                mov.b           #0x40, R12
PrintA_F        bic.b           #0x2,&P2OUT
                call            #SecondLine
                bis.b           #0x2,&P2OUT
                mov.b           R4,R13                                               
                call            #LCDNumberPrint
                bit             R6,R6
                jz              LoopOut 
                inc             R8                
                cmp             #12, R8                
                jne             PrintA_F                
                jmp             GameCounter 
LoopOut         dec             R5
                ret
;--------------------------------------------------------
;		Subroutine LCDNumberPrint
;               Receives byte value of text to be displayed in LCD
;-------------------------------------------------------- 
LCDNumberPrint  add.b           #1b,R12
                mov.b           R12, P1OUT
                call            #CounterDataEn
                bic.b           #0xFF,&P1OUT
PrintOut        ret
;--------------------------------------------------------
;		Subroutine Counter Data Enable
;-------------------------------------------------------- 
CounterDataEn   bis.b           #1,&P2OUT
                call            #LevelDelay
                bic.b           #1,&P2OUT
                ret       
;--------------------------------------------------------
;		Subroutine LevelDelay
;               Receives level multiplier in R13 and performs delay based on the
;               multiplier provided by the selected difficulty
;--------------------------------------------------------    
LevelDelay      mov             #10000, R14
DelayLoop       nop
                nop
                mov             R8,R5        
                bit             R6,R6
                jz              DelayLoopOut     
                dec             R14
                jnz             DelayLoop
                dec             R13                        ; Perform delay x times to achieve Diifculty Delay                
                jnz             LevelDelay   
DelayLoopOut    ret                
;--------------------------------------------------------
;		Subroutine GameController
;               Performs Absolute value logic and determines if player wins or 
;               loses in the current level
;               Receives default reference value in R7
;               Recieves user input value from R5
;               Return 1 to R11 if user wins else 0
;--------------------------------------------------------
GameController  cmp             R7,R5
                jnc             CMPELSE
                sub             R7,R5
                mov             R5,R9
                jmp             WINCHECK
CMPELSE         mov             R7,R9
                sub             R5,R9
WINCHECK        cmp             R10,R9
                jc              ZEROCHECK
                mov             #1,R11
                jmp             ControllerEnd
ZEROCHECK       cmp             R10,R9
                jne             LOSE
                mov             #1,R11
                jmp             ControllerEnd
LOSE            mov             #0,R11            
ControllerEnd   ret
;--------------------------------------------------------
;		Subroutine Set LCD to First Line
;--------------------------------------------------------
FirstLine       bis.b           #0x80,&P1OUT     ;Set first Character of first line
                call            #SETENABLE       ;Enable Pulse
                bic.b           #0xFF,&P1OUT     ;Clear                
                ret                

;--------------------------------------------------------
;		Subroutine Set LCD to Second Line
;--------------------------------------------------------
SecondLine      bis.b           #0xC0,&P1OUT                    ;Set first Character of Second line
                call            #SETENABLE                      ;Enable Pulse
                bic.b           #0xFF,&P1OUT                    ;Clear
                ret                
;--------------------------------------------------------
;		Subroutine Call EasyText
;-------------------------------------------------------- 
                ;-------------------------E
EasyText        bis.b           #0x45,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT             
                ;-------------------------a
                bis.b           #0x61,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT 
                ;-------------------------S
                mov.b           #0x73,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT   
                ;-------------------------y
                bis.b           #0x79,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ret

;--------------------------------------------------------
;		Subroutine Call MediumText
;-------------------------------------------------------- 

                ;-------------------------M
MediumText      bis.b           #0x4D,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT             
                ;-------------------------e
                bis.b           #0x65,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT 
                ;-------------------------d
                mov.b           #0x64,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT   
                ;-------------------------i
                bis.b           #0x69,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ;-------------------------u
                bis.b           #0x75,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ;-------------------------m
                bis.b           #0x6D,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ret                     
;--------------------------------------------------------
;		Subroutine Call HardText
;--------------------------------------------------------
                ;-------------------------H
HardText        bis.b           #0x48,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT             
                ;-------------------------a
                bis.b           #0x61,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT 
                ;-------------------------r
                mov.b           #0x72,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT   
                ;-------------------------d
                bis.b           #0x64,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT
                ret
;-------------------------------------------------------------------------------
; 		ClrLine1
;-------------------------------------------------------------------------------
ClrLine1        bic.b           #0x2,&P2OUT               ;Enable Instruction Register
                call            #FirstLine                
                bis.b           #0x2,&P2OUT               ;Enable Data Register
                call            #ClearLine
                bic.b           #0x2,&P2OUT               ;Enable Instruction Register
                call            #FirstLine                
                bis.b           #0x2,&P2OUT               ;Enable Data Register
                ret
;-------------------------------------------------------------------------------
; 		ClrLine2
;-------------------------------------------------------------------------------
ClrLine2        bic.b           #0x2,&P2OUT               ;Enable Instruction Register
                call            #SecondLine                
                bis.b           #0x2,&P2OUT               ;Enable Data Register
                call            #ClearLine
                bic.b           #0x2,&P2OUT               ;Enable Instruction Register
                call            #SecondLine                
                bis.b           #0x2,&P2OUT               ;Enable Data Register
                ret
;--------------------------------------------------------
;		Subroutine Clear Line
;--------------------------------------------------------
ClearLine       nop               
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT               
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                
                ;-------------------------space
                bis.b           #0x20,&P1OUT
                call            #SETENABLE
                bic.b           #0xFF,&P1OUT                               
                ret

;--------------------------------------------------------
;		Subroutine Call Difficulty Text
;-------------------------------------------------------- 
DiffTextPrint   nop
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
                mov             #2000, R14    
DELAY		dec	        R14 			        ; Decrement R15
		jnz	        DELAY                           ; Delay over?
CLEARENABLE     xor.b           #1,&P2OUT
                ret
;--------------------------------------------------------
;		Subroutine Delay
;-------------------------------------------------------- 
Delay		mov             #50000,R14
L2              dec	        R14 			        ; Decrement R15
		jnz	        L2 			        ; Delay over?
		ret	                                        ; Go
;--------------------------------------------------------
;		Interrupt Vectors
;--------------------------------------------------------
		ORG 	0FFFEh 			; MSP430 RESET Vector
		DW	RESET 			;
		ORG	0FFE6h			; interrupt vector 2
		DW	PBISR			; address of label PBISR                
		END