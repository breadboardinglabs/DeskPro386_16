PAL20R4                                               PAL DESIGN SPECIFICATION
D4-SADOD 108393-001                                     PAUL R. CULLEY 01/09/87
Bus enable to address converter and cycle end logic
COPYRIGHT 1986, 1987 COMPAQ COMPUTER HOUSTON, TEXAS

CALE   ALE /BE3   /BE2  /BE1 /BE0  LM-IO T00   T10  /LM16  /IO16  GND
BHLDA /CMD /CLAST /CLSTD A1   A0  /BHE  /ALST /CX16 /DCMD /RST   VCC

;The following 4 outputs are clocked by ALE, output only when /HLDA is true
/A1  := /RST* /BE3* /BE2
      + /RST* /A1*  /A0* /CX16* /CLAST
      + /RST* BE1*         CLAST

/A0  := /RST* BE0*         CLAST
      + /RST* BE2* /BE1*   CLAST
      + /RST* BE2* A0*    /CLAST
      + /RST* CX16*       /CLAST

BHE  := /RST* /A0* /CX16* /CLAST
      + /RST* BE1*         CLAST
      + /RST* BE3

ALST := /RST* /CX16 * /BE2  * /CLAST
      + /RST* /BE2  * /BE0  *  CLAST
      + /RST* /BE3  * /BE1  *  CLAST
      + /RST* /BE3  *  A0   * /CLAST
      + /RST* /CX16 *  A1   * /A0 * /CLAST
      + /RST*  CX16 * /BE3  * /CLAST

;Cycle LAST PRESET input for internal F/F (Cleared by rising edge of ALE) 
;This is pulsed only once to set F/F and generate the NAB* signal
CLSTD =  ALST*        T00                ;Active during the last cycle of set
      +  LM-IO* LM16* T00* /BE2
      +  LM-IO* LM16* T00*  A1
      + /LM-IO* IO16* T10* /BE2* /ALST
      + /LM-IO* IO16* T10*  A1*  /ALST
      + RST                              ;and during RESET

CLAST =  ALST* T00                       ;Active during the last cycle of set
      +  LM-IO* LM16* T00* /BE2
      +  LM-IO* LM16* T00*  A1
      + /LM-IO* IO16* T10* /BE2* /ALST
      + /LM-IO* IO16* T10* A1*   /ALST
      +  RST                             ;and during RESET
      +  CLAST* /ALE                     ;HOLDS ACTIVE TILL ALE

CX16  = /RST*  LM-IO* T00* LM16           ;CPU MEM OP
      + /RST* /LM-IO* T10* IO16           ;CPU I/O OP
      + /RST*        /ALE* CX16           ;CPU HOLD

DCMD = CMD                                ; DELAYED COMMAND

FUNCTION TABLE

CALE BHLDA /RST /BE3 /BE2 /BE1 /BE0 LM-IO ALE T00 T10 /LM16 /IO16 /CMD
/DCMD /CLAST A1  A0  /BHE /ALST /CLSTD /CX16
;  B           L                C           C
;C H           M       L I    D L        A  L C 
;A L R B B B B - A T T M O C  C A      B L  S X 
;L D S E E E E I L 0 1 1 1 M  M S  A A H S  T 1 
;E A T 3 2 1 0 O E 0 0 6 6 D  D T  1 0 E T  D 6
------------------------------------------------------------------------------
 C L L H H H H H H H L H H H  H L  H H H H  L H ;RESET

 C L L H H H H H L H L H H L  L L  H H H H  L H ;
 C L H L L L L H L L L H H H  H L  L L L H  H H ;32 BIT ON 8 BUS
 C L H L L L L H H H H H H H  H H  L H L H  H H ;
 C L H L L L L H H H H H H H  H H  H L L H  H H ;
 C L H L L L L H H L L H H H  H H  H H L L  H H ;
 L L H L L L L H L H H H H H  H L  H H L L  L H ;
 C L H H L L L H L H H H H H  H L  L L L H  H H ;24 BIT ON 8 BUS
 C L H H L L L H H H H H H H  H H  L H L H  H H
 C L H H L L L H H L L H H H  H H  H L H L  H H 
 L L H H L L L H L H H H H H  H L  H L H L  L H
 C L H L L L H H L H H H H H  H L  L H L H  H H ;24 BIT ON 8 BUS HIGH
 C L H L L L H H H.H H H H H  H H  H L L H  H H
 C L H L L L H H H L L H H H  H H  H H L L  H H
 L L H L L L H H L H H H H H  H L  H H L L  L H
 C L H H H L L H L H H H H H  H L  L L L H  H H ;16 LOW ON 8 BUS
 C L H H H L L H H L L H H H  H H  L H L L  H H
 L L H H H L L H L H H H H H  H L  L H L L  L H
 C L H H L L H H L H H H H H  H L  L H L H  H H ;16 MED ON 8 BUS
 C L H H L L H H H L L H H H  H H  H L H L  H H
 L L H H L L H H L H H H H H  H L  H L H L  L H
 C L H L L H H H L H H H H H  H L  H L L H  H H ;16 HIGH ON 8 BUS
 C L H L L H H H H L L H H H  H H  H H L L  H H
 L L H L L H H H L H H H H H  H L  H H L L  L H
 C L H H H H L H H H H H H H  H L  L L H L  L H ;8 LOW ON 8 BUS
 C L H H H L H H H H H H H H  H L  L H L L  L H ;8 HIGH ON 8 BUS
 C L H H L H H H H H H H H H  H L  H L H L  L H ;8 LOW ON 8 BUS HIGH WORD
 C L H L H H H H L H H H H H  H L  H H L L  L H ;8 HIGH ON 8 BUS HIGH WORD
 C L H L L L L H l H L L H H  H L  L L L H  H L ;32 BIT ON 16 BUS

 L L H L L L L H L L L L H H  H L  L L L H  H L ;
 L L H L L L L H H L L L H H  H H  L L L H  H H ;
 L L H L L L L H L H L L H H  H H  L L L H  H L ;
 C L H L L L L H L L L L H H  H H  H L L H  H L ;
 L L H L L L L H H H H L H H  H L  H L L H  L L ;
 C L H H L L L L L H H H L H  H L  L L L H  H L ;24 BIT ON 16 BUS 
 L L H H L L L L H H H H L H  H H  L L L H  H L ;
 L L H H L L L L L H H H L H  H H  L L L H  H L ;
 C L H H L L L L L L L H L H  H H  H L H L  H L
 L L H H L L L L L H H H L H  H L  H L H L  L L
 C L H L L L H L L H H L L H  H L  L H L H  H L ;24 BIT ON 16 BUS HIGH
 L L H L L L H L H H H L L H  H H  L H L H  H L
 L L H L L L H L L H H L L H  H H  L H L H  H L
 C L H L L L H L L L L L L H  H H  H L L H  H L
 L L H L L L H L H H H L L H  H L  H L L H  L L
 C L H H H L L H H H H L H H  H L  L L L H  L L ;16 LOW ON 16 BUS
 L L H H H L L H L H H L H H  H L  L L L H  L L ;
 C L H H L L H H L H H L H H  H L  L H L H  H L ; 16 MED ON 16 BUS 
 L L H H L L H H H H H L H H  H H  L H L H  H L
 L L H H L L H H L H H L H H  H H  L H L H  H L
 C L H H L L H H L L L L H H  H H  H L H L  H L
 L L H H L L H H H H H L H H  H L  H L H L  L L
 C L H L L H H H H H H L H H  H L  H L L H  L L ;16 HIGH ON 16 BUS
 C L H H H H L H H H H L H H  H L  L L H L  L L ;8 LOW ON 16 BUS
 C L H H H L H H H H H L H H  H L  L H L L  L L ;8 HIGH ON 16 BUS
 C L H H L H H H H H H L H H  H L  H L H L  L L ;8 LOW ON 16 BUS HIGH WORD
 C L H L H H H L H H H L L H  H L  H H L L  L L ;8 HIGH ON 16 BUS HIGH WORD
 L L H L H H H L L H H L L H  H L  H H L L  L L ;
 L L H L H H H L L L L H L H  H L  H H L L  H L ;
 C L H H H L L L L L H H L H  H L  L L L H  L L ;16 LOW ON 16 BUS
 L L H H H L L L H L H H L H  H L  L L L H  L L
 L H H H H L L L H L L H L H  H H  Z Z Z Z  H H
-----------------------------------------------------------------------------

DESCRIPTION
This PAL converts the CPUs bus enable lines to address lines and cycles from 
one to the next when multiple cycles are required. It also determines_when 
the last cycle is in progress to develop the Cycle LAST signal. 
Rev A of this device changes the CX16* equation to go away on ALE. The input 
T01 is changed to T10 and IO16* is changed to LM-IO as part of an overall 
change to delay the sampling of IO16* by one clock. Rev A can be used in any 
D4-PROCESSOR from rev X5 up.
Rev D is for the D4-Processor Enhanced (387 version)
-----------------------------------------------------------------------------
