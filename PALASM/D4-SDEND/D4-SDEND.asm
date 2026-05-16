PAL16L8                                               PAL DESIGN SPECIFICATION
D4-SDEND 109390-001                                     PAUL R. CULLEY 12/09/80
DataBuffer enable logic 
Copyright COMPAQ COMPUTER Houston, Texas 1986

 A1     A0     /BHE  /CMD  /M32  /WDEN  LW-R  LD-C  LM-IO GND
/TST   /BDIRRD /B0EN /B1EN /B2EN /INTA /MWTC /MRDC /B3EN  VCC

IF (/TST) BDIRRD = /MRDC* /WDEN               ;OTHER WRITE TO LOCAL MEM

IF (/TST) B0EN = /A1* /A0* MWTC* /WDEN        ;OTHER WRITE TO LOCAL MEM
               + /A1* /A0* MRDC* /WDEN* M32   ;OTHER READ FROM LOCAL MEM
               + /A1* /A0* LD-C* LW-R* WDEN   ;CPU WRITE TO BUS

IF (/TST) B1EN = /A1* BHE* MWTC* /WDEN        ;OTHER WRITE TO LOCAL MEM
               + /A1* BHE* MRDC* /WDEN* M32   ;OTHER READ FROM LOCAL MEM
               + /A1* BHE* LD-C* LW-R* WDEN   ;CPU WRITE TO BUS

IF (/TST) B2EN = A1* /A0* MWTC* /WDEN         ;OTHER WRITE TO LOCAL MEM
               + A1* /A0* MRDC* /WDEN* M32    ;OTHER READ FROM LOCAL MEM
               + A1* /A0* LD-C* LW-R* WDEN    ;CPU WRITE TO BUS
               
IF (/TST) B3EN = A1* BHE* MWTC* /WDEN         ;OTHER WRITE TO LOCAL MEM
               + A1* BHE* MRDC* /WDEN* M32    ;OTHER READ FROM LOCAL MEM
               + A1* BHE* LD-C* LW-R* WDEN    ;CPU WRITE TO BUS
               
IF (/TST) INTA = CMD* /LM-IO* /LW-R* /LD-C    ;CPU INTERRUPT ACK

FUNCTION TABLE

TST A1 A0 /BHE /WDEN LM-IO LW-R LD-C /CMD /M32 /MWTC /MRDC 
/BDIRRD /B3EN /B2EN /B1EN /B0EN /INTA
;                         B
;        W L L L     M M  I B B B B I 
;T     B D M W D C M W R  R 3 2 1 0 N 
;S A A H E I - - M 3 T D  R E E E E T 
;T 1 0 E N O R C D 2 C C  D N N N N A
---------------------------------------------------~----------------------
 L L L L H H H H H L L H  L H H L L H
 L H L L H H H H H L L H  L L L H H H
 L L L L H L H L L L H L  H H H L L H
 L H L L H H L L L L H L  H L L H H H
 L L L L H L L H L H H H  L H H H H H
 L L L L L L L L L H H H  H H H H H L
 L L L L L L L L H H H H  H H H H H H
 L L L L L H H H H H H H  H H H L L H
 L H L L L H H H H H H H  H L L H H H
 H H L L L H H H H H H H  Z Z Z Z Z Z
---------------------------------------------------~----------------------

DESCRIPTION
This PAL developes the control signal to enable the data buffers on the system
board.
Rev A ensures turnon of the buffer enables for mem write after the direction 
is active by leaving the buffer turned around during the entire write cycle.
Rev D is for use with D3PE D4-processor board (with 387).