PAL16L8                                               PAL DESIGN SPECIFICATION
D4-SADI 105645-001                                      PAUL R. CULLEY 02/13/86
Address to byte enable conversion and read latch enable logic
Copyright 1986 COMPAQ COMPUTER Houston, Texas

A1    A0   /BHE  /CX16  NC2  /CMD   LW-R  HLDA  NC1  GND
TST  /BE0  /BE1  /BE2  /BE3   B0CK  B1CK  B2CK  B3CK VCC

IF (HLDA) BEO = /A1 * /A0

IF (HLDA) BE1 = /A1 * BHE

IF (HLDA) BE2 = A1 * /A0

IF (HLDA) BE3 = A1 * BHE

IF (/TST) /B0CK  =  /CMD
                 +   LW-R
                 +   A0
                 +   A1

IF (/TST) /B1CK  =  /CMD
                 + /BHE
                 + /CX16 * /A0
                 +  LW-R
                 +  A1

IF (/TST) /B2CK  =  /CMD
                 +  /A1
                 +   LW-R
                 +   A0

IF (/TST) /B3CK  =  /CMD
                 +  /BHE
                 +  /A1
                 +  /CX16 * /A0
                 +   LW-R

FUNCTION TABLE

TST   HLDA A1   A0 /BHE  /CX16 /CMD   LW-R
/BE3 /BE2 /BE1 /BE0 B3CK  B2CK  B1CK  B0CK
;  H       C   L           B B B B 
;T L     B X C W   B B B B 3 2 1 0 
;S D A A H 1 M -   E E E E C C C C 
;T A 1 0 E 6 D R   3 2 1 0 K K K K
-------------------------------------------------------------------------
 L H L L L H L L   H H L L L L L H
 L H L L H H L L   H H H L L L L H
 L H L H L H L L   H H L H L L H L
 L H H L L H L L   L L H H L H L L
 L H H L H H L L   H L H H L H L L
 L H H H L H L L   L H H H H L L L
 L L L L L L L L   Z Z Z Z L L H H
 L L L L H L L L   Z Z Z Z L L L H
 L L L H L L L L   Z Z Z Z L L H L
 L L H L L L L L   Z Z Z Z H H L L
 L L H L H L L L   Z Z Z Z L H L L
 L L H H L L L L   Z Z Z Z H L L L
 L L L L L L H L   Z Z Z Z L L L L
 L L H L L L H L   Z Z Z Z L L L L
 L L L L L L L H   Z Z Z Z L L L L
 L L H L L L L H   Z Z Z Z L L L L
 H L H L L L L H   Z Z Z Z Z Z Z Z
-------------------------------------------------------------------------


DESCRIPTION
This PAL contains the logic to back drive the 386 byte enables during the non 
CPU operations. It decodes the address inputs and drives the appropriate BEx 
lines whenever the 386 is in a HLDA state.

This PAL also contains the decoding logic to drive the read latches clock lines 
(74ALS573 fall through latch). These clock lines have positive true outputs 
and are enabled when the CPU executes a MRDC, IORC, or INTA command.
The basic equation is: BxCK = BSOx * CMD * /LW-R
