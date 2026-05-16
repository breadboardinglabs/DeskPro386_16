PAL16L8                                               PAL DESIGN SPECIFICATION
D4-SPPI 105659-001                                   PAUL R. CULLEY    12/10/85
Peripheral interface decode logic
Copyright Compaq Computer Houston, Texas

XA4     /PPICS  /XIORC   XA3   XA9     XA0    XA8   /XIOWC /INTA    GND
RESCMOS /CMOSWR /NMICLK /PBWR /CMOSRD /KEYCS /CIORD /PBRD   CMOSAWR VCC

NMICLK = PPICS *  XA4 * /XA3 * /XA0 * XIOWC   ; NMI register write (70h)

CMOSRD = PPICS *  XA4 * /XA3 *  XA0 * XIORC   ; CMOS data read (71h)

CMOSWR = PPICS *  XA4 * /XA3 *  XA0 * XIOWC   ; CMOS data write (71h)

KEYCS  = PPICS * /XA4 * /XA3 * /XA0           ; 8042 (60h, 64h)

PBWR   = PPICS * /XA4 * /XA3 *  XA0 * XIOWC   ; Port B write (61h)

PBRD   = PPICS * /XA4 * /XA3 *  XA0 * XIORC   ; Port B read (61h)

CIORD  = /XA9  * /XA8 * XIORC                 ; 0-FFH
       + INTA                                 ; or Interrupt ack

/CMOSAWR = /NMICLK * /RESCMOS                 ; Inverted NMICLK
         + /XIOWC  * /RESCMOS                 ; CMOS address write (70h)


FUNCTION TABLE

/XIORC  /XIOWC   /INTA    XA9     XA8    XA4   XA3   XA0   /PPICS RESCMOS
/NMICLK  CMOSAWR /CMOSWR /CMOSRD /KEYCS /PBWR /PBRD /CIORD
;                  R   N C C C
;X X             P E   M M M M K     C
;I I I           P S   I O O O E P P I
;O O N X X X X X I C   C S S S Y B B 0
;R W T A A A A A C M   L A W R C W R R
;C C A 9 8 4 3 0 S O   K W R D S R D D
----------------------------------------------------------------------------
 H H H H H H L H H H   H H H H H H H H
 H H H L L L L L L L   H L H H L H H H        ;8042 SELECT
 H H L H H H L H H L   H L H H H H H L        ;BUFFER ENABLE ON INTA
 H L H L L H L L L L   L H H H H H H H        ;CMOS ADDRESS WRITE
 H H H L L H L L L L   H L H H H H H H        ;CMOS ADDRESS WRITE
 H L H L L H L H L L   H L L H H H H H        ;CMOS WRITE
 L H H L L H L H L L   H L H L H H H L        ;CMOS READ
 L H H L L L L H L L   H L H H H H L L        ;PORT B READ
 L H H L L L L H H L   H L H H H H H L        ;BUFFER ENABLE
 L H H H L L L H H L   H L H H H H H H        ;BUFFER DISABLE
 L H H L H L L H H L   H L H H H H H H        ;BUFFER DISABLE
 H L H L L L L H L L   H L H H H L H H        ;PORT B WRITE (NO BUF ENABLE)
 H L H L L L H H L L   H L H H H H H H        ;
 H L H L L H H H L L   H L H H H H H H        ;
----------------------------------------------------------------------------


DESCRIPTION
This PAL is used in the D4 (386) processor board to decode addresses within the
range 60h to 7Fh for I/O. It also generates the signal that controls the
direction of the I/O data buffer XD<7..0>.
