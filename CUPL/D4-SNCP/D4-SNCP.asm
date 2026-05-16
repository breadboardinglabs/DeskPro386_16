PAL16L8                                               PAL DESIGN SPECIFICATION
D4-SNCP        105657-001                               PAUL R. CULLEY 05/07/86
Numeric Coproccessor error and busy logic 
Copyright 1986 Compaq Computer Houston, Texas

/TIMCS /XIOWC   XA0    /ERROR  /BUSYIN  TIMO  /NCPIN /NCPCS  /RESET    GND
XA3     RES287 /TIM2CS /TIM1CS  ONESHT  IRQ13  NC02   EN_ERR /BUSYOUT  VCC

;The following equation is the positive true output of the equation:
;RES287 = RESET + XIOWC * NCPCS * /XA3 * XA0  ; I/O write to F1h

IF (VCC) IRES287 =
  /RESET * /XIOWC               ;NOT I/O WRITE
+ /RESET * /NCPCS               ; NOT port FX
+ /RESET * XA3                  ; NOT address XXIXXXb
+ /RESET * /XA0                 ; NOT address XXXXXOb

IF (VCC) BUSYOUT =
   /RESET*  NCPIN* BUSYIN                 ; coprocessor busy
+  /RESET*  NCPIN* ERROR * EN_ERR* /TIMO  ; error before int ack
+  /RESET* /NCPIN* NCPCS * XA3 * XIOWC    ; When not installed and NCP accessed
+  /RESET* /NCPIN* ONESHT* /TIMO          ; When not installed till timeout

;The following equation is the positive true output of the equation:
; IRQ13 = ERROR* /BUSYIN* EN_ERR* NCPIN   ; Int when error and enabled

IF (VCC) /IRQ13 =
  /ERROR                                  ; No int if no error
+ BUSYIN                                  ; or busy
+/EN_ERR                                  ; or not enabled for err
+/NCPIN                                   ; No int if not installed

IF (VCC) /EN_ERR =
  /RESET* NCPIN* /EN_ERR * ERROR          ; Hold disabled till ERROR goes away
+ /RESET* NCPIN* /EN_ERR * BUSYIN         ; Hold disabled till BUSY goes away
+ XIOWC * NCPCS * /XA3 * /XA0             ; Disable on write to port 0F0h

IF (VCC) /ONESHT =
   NCPIN * /IRQ13                         ; One shot output when IRQ (installed)
+ /NCPIN * /ONESHT * /XIOWC               ; Goes high on NCP access when not
+ /NCPIN * /ONESHT * /XA3                 ;     installed
+ /NCPIN * /ONESHT * /NCPCS
+ /NCPIN * TIMO                           ; and stays high till timeout
+  RESET                                  ; Low at reset time

IF (VCC) TIM1CS = TIMCS * /XA3            ; Timer 1 at address 040h-047h, 050h-057h

IF (VCC) TIM2CS = TIMCS * XA3             ; Timer 2 at address 048h-04Fh, 058h-05Fh

FUNCTION TABLE
/NCPIN  /XIOWC   TIMO  /TIMCS  /NCPCS    XA3     XA0    /RESET /ERROR /BUSYIN
RES287  /BUSYOUT IRQ13  ONESHT /EN_ERR  /TIM1CS /TIM2CS
;                  /   / /     / / /
;/     / /     / / B   R B   O E T T
;N /   T N     R E U   E U I N N I I
;C I T I C     E R S   S S R E _ M M
;P O I M P X X S R Y   2 Y Q S E 1 2
;I W M C C A A E O I   8 O 1 H R C C
;N C O S S 3 0 T R N   7 U 3 T R S S
--------------------------------------------------------------------------------
 L H L H H H H L H H   H H L L L H H ;RESET
 L H L H H H H H H H   L H L L L H H ;NO RESET 
 L L L H L L H H H H   H H L L L H H ;RES287
 L L L H L H H H H L   L L L L L H H ;BUSYOUT,NORES287 BY XA3,NOINT BY ERROR
 L L L H H L H H L H   L L H H L H H ;IRQ13,BUSYOUT,NORES287 BY NCPCS
 L L H H H L H H L H   L H H H L H H ;BUSYOUT,NORES287 BY NCPCS
 L L H H H L H L L L   H H L L L H H ;NO INT BY BUSYIN
 L H H H L L H H H H   L H L L L H H ;NO RES287 BY IOWC
 L L H H L L L H H H   L H L L H H H ;LOCKERR,NO RES287 BY XA0
 L L H H L L L H H L   L L L L H H H ;LOCKERR,NO RES287 BY XA0
 L L H H H L L H H L   L L L L H H H ;LOCKERR,NO RES287 BY XA0
 L L H H H L L H L L   L L L L H H H ;HOLD LOCKERR,NO INT BY EN_ERR
 L L H H H L L H L H   L H L L H H H ;HOLD LOCKERR,NO INT BY EN_ERR
 L H H L H L H H H H   L H L L L L H ;TIM1CS
 L H H L H H H H H H   L H L L L H L ;TIM2CS
 H L L H L H L H H H   L L L H L H H ;NOT INSTALLED AND SELECTED
 H H L H H H H H L H   L L L H L H H ;NOT INSTALLED ERROR
 H H H H H H H H H L   L H L L L H H ;NOT INSTALLED BUSY
 H H L H L H H H H L   L H L L L H H 
 H H L H H L H H H L   L H L L L H H 
 H L L H H H H H H L   L H L L L H H 
 H H L H H L H H H L   L H L L L H H
 H L L H L L H H H L   H H L L L H H
--------------------------------------------------------------------------------
 
DESCRIPTION
This PAL is used in the Magnum processor board to handle the error logic for
the numeric coprocessor. It allows a greater measure of compatibility with
the previous products. It sets up the system to generate an interrupt when 
the error signal is recieved. It holds the interrupt until the service
routine does a write to port F0h. It also holds busy out active until the 
interrupt occurs or till the CPU times out from no activity. This is to
prevent any other numeric processor instructions from being executed until 
the error has been recognized. If the no activity timeout occurs, that means
the CPU hung up on the 287 interface due to different design of the 386.

In this case, the interrupt will have been recieved by the 386.
In addition, the timer chip selects are broken out to the seperate selects by the PAL logic.
