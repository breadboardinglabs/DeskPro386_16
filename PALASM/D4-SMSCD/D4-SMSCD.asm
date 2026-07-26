PAL16R4                                               PAL DESIGN SPECIFICATION
D4-SMSCD 108397-001                                     PAUL R. CULLEY 01/12/87
Miscellaneous garbage logic
Copyright 1986, 1987 COMPAQ COMPUTER Houston, Texas

CLK  /M32  /BRDY   BALE   W_R  D_C  M_IO /BE0   PA31   GND
/OE  /LNCP /CLSTD /MYCYC /LOE /NAB /SHTD  387I /ADS    VCC

LOE :=
  MYCYC * BALE * /W_R * /LNCP       ; GOES ACTIVE AT ALE
+ LOE * /BRDY                       ; HOLD THROUGH TILL BRDY ACTIVE

SHTD :=
  MYCYC* BALE* M_IO* /D_C* W_R* BE0 ; DECODED SHUTDOWN OPCODE
  
MYCYC := 
  /CLSTD * ADS * /M_IO * /387I      ; WHEN NO 387 AND I/0
+ /CLSTD * ADS * /M_IO * /PA31      ; OR NOT NCP I/0 CYCLE
+ /CLSTD * ADS * M_IO * /M32        ; OR NOT 32 BIT MEMORY CYCLE
+ /CLSTD * ADS * M_IO * /D_C * W_R  ; OR HALT/SHUTDOWN CYCLE
+ /CLSTD * MYCYC                    ; HOLD TI LL NAB

NAB := CLSTD                        ; NEXT ADDRESS BUS

LNCP =
  MYCYC* BALE* PA31* /M_IO          ; NUMERIC COPROCESSOR OP
+ LNCP* /BALE                       ; HOLD TILL NEXT ALE OR HOLD
+ MYCYC* PA31* /M_IO* LNCP          ; DEGLITCH

FUNCTION TABLE
CLK  /OE    /M32   /BRDY  BALE   M_IO  D_C   W_R  /BE0  PA31 
/ADS /CLSTD  387I  /LNCP /MYCYC /LOE  /NAB  /SHTD
;                      /     /
;      /               C   / M     /
;    / B B M     / P / L 3 L Y / / S
;C / M R A - D W B A A S 8 N C L N H 
;L 0 3 D L I - - E 3 D T 7 C Y 0 A T 
;K E 2 Y E O C R 0 1 S D I P C E B D
-------------------------------------------------------------------------------
 C L H L H H H H H L L H H H X H H H RESET MTCYC BY IM32
 C L H L H H H H H L L H H H L H H H RESET MTCYC BY IM32
 C L H L H H H H H L H H H H L H H H HOLD MYCYC
 C L H L H H H H H L H L H H H H L H
 C L L L H H L H H L L L H H H H L H
 C L L L H H L H L L L H H H L H H H MYCYC BY HALT
 C L L L H H L H L L L L H H H H L L
 C L L L H L L L H L L H H H L H H H MYCYC BY I/O
 C L L L H L L L H L L L H H H L L H
 C L L L H L L L H H L H L L L H H H MYCYC BY 387 NOT INSTALLED
 L L L L L L L L H H L H L L L H H H
 C L L H L L L L H H L L L L H H L H
 C L L H L L L L H H L L L L H H L H
-------------------------------------------------------------------------------


DESCRIPTION
Rev D of this PAL is for the upgraded D3PE D4-processor board (with 387) and
is a new design.
This PAL contains the equations for the signal MYCYC (BUS state machine cycle),
SHTD <decoded shutdown status), LNCP (numeric processor access status), and
LOE (latch output enable). It also is the F/F for the NAB signal.