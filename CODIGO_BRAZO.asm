;*******************************************************************************
;                                                                              *
;    Filename:	    BRAZO ----> CODIGO_BRAZO.asm		               *
;    Date:          xx.11.2018                                                 *
;    File Version:  1.0                                                        *
;    Author:        Miguel García						       *
;		    Josué Asturias					       *
;    Company:       UVG                                                        *
;    Description:   BRAZO 3 ADC, 4 SERVOS		                       *
;                                                                              *
;*******************************************************************************
; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

#include "p16f887.inc"
    errorlevel -302
; CONFIG1
; __config 0xE0F4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
 
;*******************************************************************************
;	VARIABLES
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
GPR_VAR			    UDATA
var_delay		    RES 1
bandera_ADC		    RES 1
bandera_servo 		    RES 1
WREG_MEM		    RES 1
STATUS_MEM		    RES 1
CCPR1L_x		    RES 1
CCPR2L_x		    RES 1
CCPR3L_x    		    RES 1		    
CCPR4L_x		    RES 1
		    
	    
		    
;*******************************************************************************
; Reset Vector
;*******************************************************************************
RES_VECT  CODE    0x0000            
    GOTO    START                   ; ir al inicio del prorgama
;*******************************************************************************
;  INTERRUPCIONES:
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ISR_VECT       CODE    0x0004           ; interrupt vector location
    BCF	    INTCON, INTE
GUARDAR:
    MOVWF   WREG_MEM	    ; guarda WREG para que se guarde lo que estaba
    SWAPF   STATUS, 0	    ; guarda STATUS en W (pero con nibbles cambiados)
    MOVWF   STATUS_MEM	    ; guarda W en STATUS_MEM (para quedarse como estaba STATUS
ISR:	    
    ;BTFSC   INTCON, T0IF
    BTFSC   INTCON, INTF
    CALL    INT_RB0
      
REGRESAR_ISR
    SWAPF   STATUS_MEM, 0   ; Pasa STATUS a W
    MOVWF   STATUS	    ; Guarda W en STATUS y lo deja como antes de entrar a ISR
    SWAPF   WREG_MEM, 1	    ; le da la vuelta a WREG_MEM
    SWAPF   WREG_MEM, 0	    ; le da la vuelta otra vez y lo guarda en W
    BSF	    INTCON, INTE
    RETFIE		    ; regresa de la interrupción
; -----------------------------------------------------------------------------
; Atención de interrupción TMR0
INT_RB0
    BCF	    INTCON, INTF
    INCF    PORTD, F
    BTFSC   bandera_servo, 0
    CALL    SERVO1
    BTFSC   bandera_servo, 1
    CALL    SERVO2
    BTFSC   bandera_servo, 2
    CALL    SERVO3
    BTFSC   bandera_servo, 3
    CALL    SERVO4
    RLF	    bandera_servo
    BTFSS   bandera_servo, 4
    GOTO    ADIOS_servo
    CLRF    bandera_servo
    BSF	    bandera_servo, 0
ADIOS_servo:
    BTFSS   PORTD, 2
    RETURN
    CLRF    PORTD
    RETURN

SERVO1
    MOVF    CCPR2L_x, W
    MOVWF   CCPR1L
    RETURN
SERVO2
    MOVF    CCPR3L_x, W
    MOVWF   CCPR1L
    RETURN
SERVO3
    MOVF    CCPR4L_x, W
    MOVWF   CCPR1L
    RETURN
SERVO4
    MOVF    CCPR1L_x, W
    MOVWF   CCPR1L
    RETURN
    
;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************
;*******************************************************************************
MAIN_PROG CODE                      
START

;------------------------------------------------- SETUP ------------------------ 
SETUP:
    CLRF    bandera_servo
    BSF	    bandera_servo, 0	; 0:SM1,  1:SM3, 2:SM2,  3:SM4
    CLRF    CCPR1L_x
    MOVLW   .60
    MOVWF   CCPR1L_x
    CLRF    CCPR2L_x
    CLRF    CCPR3L_x
    CLRF    CCPR4L_x
    CLRF    bandera_ADC
    BSF	    bandera_ADC, 0	; 0:AN4, 1:AN5, 2:AN6, 3:AN7
    CALL    CONFIG_PUERTOS      ; 1
    CALL    CONFIG_OSC		; 1
    CALL    CONFIG_ADC		; 1
    ;CALL    CONFIG_TMR0		; 1
    CALL    CONFIG_SERIAL	; 0
    CALL    CONFIG_ISR		; 1
    CALL    CONFIG_PWM		; 1
    
    banksel PORTA
    GOTO    INICIO
    
CONFIG_PUERTOS		;------------------------------------PUERTOS------------
    BCF	    STATUS, 6
    BCF	    STATUS, 5    ; BANCO 0 ---------------------------------------
    CLRF    PORTD
    CLRF    PORTA
    CLRF    PORTB
    CLRF    PORTE
    CLRF    PORTC
    BSF	    STATUS, 5    ; BANCO 1 ---------------------------------------
    CLRF    TRISD	 ;   Salidas SELECT demux SERVOS (RD <0:1>
    CLRF    TRISC	 ;   Salidas para PWM
    MOVLW   B'00011101'
    MOVWF   TRISB	 ;   entrada para RB0/INT , RB2(botón abrir), RB3(botón cerrar)
    MOVLW   B'00000010'
    MOVWF   TRISA	 ;   ENTRADA para pot en RA5 (AN4)
    MOVLW   B'0110'	 
    MOVWF   TRISE	 ;   Entrada para potenciómentro en RE <0:2>
    BCF	    OPTION_REG, 7;   Pull-up habilitada
    MOVLW   B'00011100'	
    MOVWF   WPUB	 ;   resistencia en RB2
    BSF	    STATUS, 6	 ; BANCO 3 ---------------------------------------
    MOVLW   B'11010010'	 ;   Pot en AN: <1,4,6,7>   
    MOVWF   ANSEL
    CLRF    ANSELH
;    MOVLW   B'00100000'	 ;   Pot en AN13
;    MOVWF   ANSELH
    RETURN
    
CONFIG_OSC ;--------------------------------------- OSCILADOR ------------------
    Banksel TRISA	 ; BANCO 1 ------------------------------------   
    BSF	    OSCCON, 6
    BCF	    OSCCON, 5
    BCF	    OSCCON, 4	 ;    Oscilador a 1MHz
    RETURN
    
CONFIG_ADC ;--------------------------------------    ADC ----------------------
    Banksel PORTA	 ; BANCO 0  -----------------------------------
    BCF ADCON0, 7
    BCF	ADCON0, 6	 ;    A/D conversion Clock Fosc/2 (por el OSC de 1MHz)
    BSF ADCON0, ADON
    BCF	ADCON0, 1
    Banksel TRISA	 ; BANCO 1  -----------------------------------
    BCF	ADCON1, ADFM
    BCF	ADCON1, VCFG1	 ; referencia en Vss   
    BCF	ADCON1, VCFG0	 ; referencia en Vdd
    RETURN

; ----------------------------------------------------- PWM --------------------    
CONFIG_PWM
    banksel TRISA
    MOVLW   B'00000100'
    MOVWF   TRISC
    MOVLW   .255
    MOVWF   PR2
    banksel PORTA
    BSF CCP1CON,CCP1M3
    BSF CCP1CON,CCP1M2
    BCF CCP1CON,CCP1M1
    BCF CCP1CON,CCP1M0		    ; MODO PWM
    BCF CCP1CON,P1M0
    BCF CCP1CON,P1M1
    BCF	    CCP2CON, 3
    BCF	    CCP2CON, 2
    BCF	    CCP2CON, 1
    BCF	    CCP2CON, 0
    MOVLW   B'00111101'
    MOVWF   CCPR1L	
    BSF	    CCP1CON, 5
    BSF	    CCP1CON, 4
    
    BSF	    T2CON, 0
    BCF	    T2CON, 1		    ; Prescaler 4
    
    BCF	    PIR1, TMR2IF
    BSF	    T2CON, TMR2ON	    
    BTFSS   PIR1, TMR2IF
    GOTO    $-1
    BCF	    PIR1, TMR2IF
    
    BANKSEL TRISC		    
    BCF	    TRISC, 2
    RETURN
;------------------------------------------------------- ISR --------------------    
CONFIG_ISR
    banksel TRISA
    ;BSF	    INTCON, T0IE
    ;BCF	    INTCON, T0IF
    BCF	    OPTION_REG, INTEDG
    banksel PORTA
    BCF	    INTCON, INTF
    BSF	    INTCON, INTE
    BSF	    INTCON, GIE
    RETURN

CONFIG_TMR0 ;------------------------------------------- TMR0 -------------------
    banksel TRISA
    BCF	    OPTION_REG, T0CS
    BCF	    OPTION_REG, PSA
    BCF	    OPTION_REG, 2
    BCF	    OPTION_REG, 1
    BSF	    OPTION_REG, 0
    RETURN
    
CONFIG_SERIAL
    BANKSEL TXSTA
    BCF	    TXSTA, 4		    ; ASINCRÓNO

;Configura el baud rate
    BSF	    TXSTA, BRGH		    ; LOW SPEED
    BANKSEL BAUDCTL
    BSF	    BAUDCTL, BRG16	    ; 8 BITS BAURD RATE GENERATOR
    BANKSEL SPBRG
    MOVLW   .25	    
    MOVWF   SPBRG		    ; CARGAMOS EL VALOR DE BAUDRATE CALCULADO
    CLRF    SPBRGH
;----------------------
    BANKSEL RCSTA
    BSF	    RCSTA, SPEN		    ; HABILITAR SERIAL PORT
    BCF	    RCSTA, RX9		    ; SOLO MANEJAREMOS 8BITS DE DATOS
    BSF	    RCSTA, CREN		    ; HABILITAMOS LA RECEPCIÓN 
    BANKSEL TXSTA
    BSF	    TXSTA, TXEN		    ; HABILITO LA TRANSMISION
    RETURN
    
;OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO-----MAIN LOOP-----OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

INICIO:
ADCs:
    CALL    SELEC_ADC_CH
    CALL    DELAY_x
    BSF	    ADCON0, 1
    BTFSC   ADCON0, 1
    GOTO    $-1
    BCF	    PIR1, ADIF
    RRF	    ADRESH, W
    ANDLW   B'01111111'
    BTFSC   bandera_ADC, 2
    MOVWF   CCPR2L_x
    BTFSC   bandera_ADC, 3
    MOVWF   CCPR3L_x
    BTFSC   bandera_ADC, 4
    MOVWF   CCPR4L_x
    RLF	    bandera_ADC
    BTFSS   bandera_ADC, 5
    GOTO    BOTON_abrir
    MOVLW   B'00000001'
    MOVWF   bandera_ADC
BOTON_abrir:
    BTFSC   PORTB, 2
    GOTO    BOTON_cerrar
    INCF    CCPR1L_x, F
    MOVLW   B'01111111'
    SUBWF   CCPR1L_x, W
    BTFSS   STATUS, C
    GOTO    COM_SERIAL
    MOVLW   B'01111111'
    MOVWF   CCPR1L_x
    GOTO    COM_SERIAL
BOTON_cerrar:
    BTFSC   PORTB, 3
    GOTO    COM_SERIAL
    DECF    CCPR1L_x, F
    MOVLW   B'00111100'
    XORWF   CCPR1L_x, W
    BTFSS   STATUS, Z
    GOTO    COM_SERIAL
    MOVLW   B'00111101'
    MOVWF   CCPR1L_x
    
COM_SERIAL:
    MOVLW   .200		    ; ENVÍA 250 POR EL TX
    MOVWF   TXREG
    BTFSS   PIR1, TXIF
    GOTO    $-1
    

    
    MOVF   CCPR1L_x, W
    MOVWF   TXREG
    BTFSS   PIR1, TXIF
    GOTO    $-1

    MOVF    CCPR2L_x, W
    MOVWF   TXREG
    BTFSS   PIR1, TXIF
    GOTO    $-1    
       
    MOVF    CCPR3L_x, W
    MOVWF   TXREG
    BTFSS   PIR1, TXIF
    GOTO    $-1    
    
    MOVF    CCPR4L_x, W
    MOVWF   TXREG
    BTFSS   PIR1, TXIF
    GOTO    $-1     
    
    GOTO    INICIO
    

;****************************************************** Seleccionar ADC ***********************************
SELEC_ADC_CH
    BTFSC   bandera_ADC, 0
    CALL    CANAL_ref
    BTFSC   bandera_ADC, 1
    CALL    CANAL_ref
    BTFSC   bandera_ADC, 2
    CALL    CANAL_1
    BTFSC   bandera_ADC, 3
    CALL    CANAL_6
    BTFSC   bandera_ADC, 4
    CALL    CANAL_7
    RETURN

CANAL_ref
    BSF	    ADCON0, 5    ; 11
    BSF	    ADCON0, 4	 ; 1
    BSF	    ADCON0, 3	 ; 1
    BCF	    ADCON0, 2	 ; 0
    RETURN
CANAL_1 
    BCF	    ADCON0, 5	 ; 0
    BCF	    ADCON0, 4	 ; 0
    BCF	    ADCON0, 3	 ; 0
    BSF	    ADCON0, 2	 ; 1
    RETURN
CANAL_6 
    BCF	    ADCON0, 5	 ; 0
    BSF	    ADCON0, 4	 ; 1
    BSF	    ADCON0, 3	 ; 1
    BCF	    ADCON0, 2	 ; 0
    RETURN
CANAL_7 
    BCF	    ADCON0, 5	 ; 0
    BSF	    ADCON0, 4	 ; 1
    BSF	    ADCON0, 3    ; 1
    BSF	    ADCON0, 2	 ; 1
    RETURN
;******************************************************** DELAY **********************  
DELAY_x
    MOVLW   .255
    MOVWF   var_delay
    DECFSZ  var_delay
    goto    $-1
    RETURN
    
DELAY_Z
    MOVLW   .100
    MOVWF   var_delay
    DECFSZ  var_delay
    goto    $-1
    MOVLW   .1
    MOVWF   var_delay
    DECFSZ  var_delay
    goto    $-1
    RETURN  
    
 
;*************************************************************************************    
    END

 
