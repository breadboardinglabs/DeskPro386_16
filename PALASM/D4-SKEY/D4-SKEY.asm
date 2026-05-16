PAL16R4                                                PAL DESIGN SPECIFICATION
D4-SKEY 108360-001                                          JOHN THAYER 9/18/86
8042 A20 LINE FIX PAL
COPYRIGHT COMPAQ COMPUTER HOUSTON, TEXAS 1986

CLK /RST A2 /CS D4_D6 D7 D5 D3 D2 GND
/OC D1 D0 /Q0 /Q1 A20 /WC8042 /FF_OR_D1 /WC VCC


Q0 := /RST * WC * CS              ;Q0 FOLLOWS WC, CLEARED ON RESET

Q1 :=                             ; SET IF IN STATE 00 OR 10 AND D1 COMMAND TO PORT 64H
    /RST * /Q0 * CS * WC * A2 * D7 * D4_D6 * /D5* /D3* /D2* /D1* D0
    ; KEEP SET IF STATE 11
    + /RST * Q0 * Q1
    ; IF STATE 10, KEEP SET TILL CS * WC
    + /RST * /Q0 * Ql * /CS
    + /RST * /Q0 * Q1 * /WC
    
/A20 := ; INVERSE OF A20 FUNCTION
        ; CLEAR IF STATE 10 AND 60 WRITE AND D1 IS LOW
        /RST * Q1 * /Q0 * /A2 * CS * WC * /D1
        ; OTHERWISE FEED BACK
        + /RST *  Q0 * /A20
        + /RST * /Q1 * /A20
        + /RST * /CS * /A20
        + /RST * /WC * /A20
        + /RST *  A2 * /A20
        
FF_OR_D1 = D7* D4_D6* D5* D3* D2* D1* D0
         + D7* D4_D6* /D5* /D3* /D2* /D1* D0
         
WC8042 := ; NO D1 WRITE YET: DON'T FILTER IF WRITE IS TO 60H 
         /RST* /Q0* /Ql * CS * WC * /A2 
         ; DONT FILTER IF WRITE IS TO 64H AND NOT <D1> OR <FF>
        + /RST * /Q0 * CS * WC * A2 * /FF_OR_D1

FUNCTION TABLE
/OC CLK RST CS WC A2 D4_D6 D7 D5 D3 D2 D1 D0
Q1 Q0 FF_OR_D1 A20 WC8042
;                                    
;                                F   W
;            D                   F   C
;            4                   O   8
;  C R       _                   R A 0
;O L S C W A D D D D D D D   Q Q D 2 4
;C K T S C 2 6 7 5 3 2 1 0   1 0 1 0 2
---------------------------------------------------~----------------------
; PDF Text needs to be manually entered.
---------------------------------------------------~----------------------
