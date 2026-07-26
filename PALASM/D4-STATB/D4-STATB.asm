PAL20R8                                               PAL DESIGN SPECIFICATION
D4-STATB 108219-00l                                    PAUL R. CULLEY  07/17/86
Bus controller state machine logic 
Copyright COMPAQ COMPUTER Houston, Texas

CLK16 /MYCYC /CLAST /CX16 LMIO /LNOWS /BWAIT /M16 T00  T01  T10 GND 
/OE    T31   /BRDY  /TS0 /CMD  /WDEN  /T40  /T41  CK8 /ALE /RST VCC

;The following functions are clocked by CLK16*
TS0  := 
  /RST* /CLAST*  T41* /BWAIT             ;START NEXT CYCLE WHEN DONE WITH
+ /RST* /CLAST* /CK8*  LNOWS* CMD        ; PREV CYCLE AND MORE IN GROUP
+ /RST* CLAST*   T41* /BWAIT*      MYCYC ;START NEXT CYCLE WHEN DONE WITH
+ /RST* CLAST*  /CK8* LNOWS*  CMD* MYCYC ; PREV CYCLE AND NEW CPU REQUEST 
                                         ; IS PENDING

CMD  := 
  /RST*  CMD* /LNOWS* /T41                ;HOLDS UNTIL ENDED BY END OF
+ /RST*  CMD* /LNOWS* BWAIT               ; WAIT
+ /RST*  CMD*  CK8                        ; OR NOWS AND CK8 LOW
+ /RST* /CMD*  ALE* M16* LMIO             ;STARTS AFTER ALE UNLESS
+ /RST* /CMD* T00                         ; CMDLY (THEN AFTER T00)

WDEN :=
  /RST*  TS0                              ;STARTS WHEN ALE DOES AFTER TSO
+ /RST* /TS0* /ALE* /CMD* /T00* MYCYC     ;OR WHEN CPU SENDS NEW START REQUEST
+ /RST* ALE                               ;CONTINUES THROUGH T00
+ /RST* T00                               ;AND T01
+ /RST* CMD                               ;UNTIL AFTER CMD GOES AWAY

T41  :=
  /RST* T40                               ;STARTS WHEN T40 ENDS
+ /RST* T10* CX16 * /LNOWS* CMD           ;OR WHEN T10 ENDS ON 1/0 CYCLE
+ /RST* T41* BWAIT                        ;AND HOLDS TILL WAIT IS GONE

T40 :=
  T01* CX16* /LNOWS* /RST                 ;STARTS AFTER T01 IF 16 BIT
+ T31*       /LNOWS* /RST                 ;OR AFTER T31 OTHERWISE

/CK8 :=
   /RST*  TS0                              ;SET TO LOW DURING ALE AFTER TS0.
+  /RST* /TS0* /ALE* /CMD* /T00* MYCYC     ;WHEN CPU SENDS NEW START REQUEST
+  CK8                                     ; OTHERWISE, DIVIDE BY TWO

BRDY :=
  /RST* CLAST* T41* /BWAIT                 ;START NEXT CYCLE WHEN DONE
+ /RST* CLAST* /CK8* LNOWS* CMD            ; WITH PREV CYCLE AND NO MORE IN GROUP

ALE := 
  /RST* TS0                                ;ALE FOLLOWS TSO FOR INTERNAL USE
+ /RST* /TS0* /ALE* /CMD* /T00* MYCYC      ; WHEN CPU SENDS NEW START REQUEST

FUNCTION TABLE
CLK16 /OE /RST /M16 LMIO /LNOWS /BWAIT /CLAST /CX16 /MYCYC TS0 ALE T00 
T01 T10 T31 T40 T41 /BRDY /CMD /WDEN CK8
;        / / /   / 
;C       L B C /    M                  /   / 
;L   /   L N W L C  Y                  B / W 
;K / R M M 0 A A X  C T A T T T T T T  R C D C
;1 O S 1 I W I S 1  Y S L 0 0 1 3 4 4  D M E K
;6 E T 6 O S T T 6  C 0 E 0 1 0 1 0 1  Y D N 8
---------------------------------------------------~----------------------
 L H H X H X X X X  X Z Z X X X X Z Z  Z Z Z Z ;OE TEST
 C L L X H X H L X  H L L L L L L L L  H H H X ;RESET
 C L H X H X H L X  H L L L L L L L L  H H H X ;CLEAR RESET
 C L H X H H H L X  L L H L L L L L L  H H L L ;ALE
 C L H L H H H L L  L L L L L L L L L  H L L H ;CMD, T00, 16 BIT NORMAL CYCLE
 C L H L H H H H L  L L L H L L L L L  H L L L ;T01
 C L H H H H H H L  L L L L H L L H L  H L L H ;T40, NOT LAST CYCLE
 C L H H H H H H L  L L L L L L L L H  H L L L ;T41
 C L H H H H H H L  L H L L L L L L L  H H L H ;CND END, TS0 NEXT CYCLE
 C L H H H H H H L  L L H L L L L L L  H H L L ;ALE
 C L H L L H H H L  L L L L L L L L L  H H L H ;T00, CMDLY, 16 BIT CYCLE
 C L H L L H H L L  L L L H L L L L L  H L L L ;T01, CMD
 C L H L H H H L L  H L L L H L L H L  H L L H ;T40, LAST CYCLE
 C L H L H H L L L  L L L L L L L L H  H L L L ;T41, ADD A WAIT STATE
 C L H L H H L L L  L L L L L L L L H  H L L H ;T41, ADD A WAIT STATE
 C L H L H H L L L  L L L L L L L L H  H L L L ;T41, ADD A WAIT STATE
 C L H L H H H L L  L H L L L L L L L  L H L H ;TS0 NEXT CYCLE
 C L H L H H H L L  L L H L L L L L L  H H L L ;ALE
 C L H L H H H L L  L L L L L L L L L  H L L H ;CMD, T00, 16 BIT NO WAIT STATE
 C L H L H L H H L  L L L H L L L L L  H L L L ;T0l
 C L H L L L H H L  L H L L H L L L L  H H L H ;CMD END, TSO NEXT CYCLE
 C L H L L H H H L  L L H L L L L L L  H H L L ;ALE
 C L H L H H H H L  H L L L L L L L L  H L L H ;CMD, T00, 16 BIT NO WAIT STATE 
 C L H L H L H L L  L L L H L L L L L  H L L L ;T0l 
 C L H X H L H L L  L H L L H L L L L  L H L H ;REQ RECEIVED 
 C L H L H H H L H  L L H L L L L L L  H H L L ;ALE
 C L H H H H H L H  L L L L L L L L L  H H L H ;T00, 8 BIT NO WAIT CYCLE 
 C L H H H H H L H  L L L H L L L L L  H L L L ;T01, CMD 
 C L H L H H H L H  L L L L H L L L L  H L L H ;T01, CMD 
 C L H L H L H H H  L L L L L L L L L  H L L L ;T11 
 C L H L H L H H H  L H L L L H L L L  H H L H ;CMD END, TS0 NEXT CYCLE 
 C L H L H H H H H  L L H L L L L L L  H H L L ;ALE 
 C L H H H H H H H  L L L L L L L L L  H H L H ;T00, 8 BIT NO WAIT CYCLE 
 C L H H H H H H H  L L L H L L L L L  H L L L ;T01 
 C L H L H H H L H  H L L L H L L L L  H L L H ;T10, CMD 
 C L H L H H H L H  H L L L L H L L L  H L L L ;T11 
 C L H L H L H L H  L H L L L L L L L  L H L H ;REQ RECEIVED 
 C L H L H H H L H  L L H L L L L L L  H H L L ;ALE 
 C L H H H H H L H  L L L L L L L L L  H H L H ;CMD, TOO, 8 BIT NORMAL CYCLE 
 
 C L H H H H H L H  L L l H L L L L L  H L L L ;T01 
 C L H L H H H L H  L L L L H L L L L  H L L H ;T10 
 C L H L H H H L H  H L L L L H L L L  H L L L ;T11 
 C L H L H H H L H  H L L L L L L L L  H L L H ;T20,T21,T30 
 C L H L H H H L H  H L L L L L L L L  H L L L ;T31 
 C L H L H H H L H  H L L L L L H H L  H L L H ;T40 
 C L H L H H H L H  H L L L L L L L H  H L L L ;T41 
 C L H L H H H L H  H L L L L L L L L  L H L H ;CMD END 
 C L H L H H H L H  H L L L L L L L L  H H H L ;IDLE 
 C L H X H H H L H  L L H L L L L L L  H H L L ;ALE 
 C L H L H H H L H  L L L L L L L L L  H L L H ;CMD, T00, 16 BIT NORMAL CYCLE 
 C L H L H H H H H  L L L H L L L L L  H L L L ;T01 
 C L H L H H H H H  L L L L H L L L L  H L L H ;T10 
 C L H L H H H H L  L L L L L H L L H  H L L L ;T41 
 C L H H H H H H L  L H L L L L L L L  H H L H ;CMD END, TS0 NEXT CYCLE
--------------------------------------------------------------------------

DESCRIPTION
This PAL implements some of the bus controller state machine logic.
REV B adjusts the sampling time of the IO16* line by adding state Tl0 to the 
startup of T41. If the CX16* (IO16) line comes in after T00 then we shift 
to T41 instead of T40. REV B also tightens up the response from ADS* to ALE by 
one clock by shifting directly to ALE from MYCYC during the initial bus 
transaction. State TSO is still used between transactions.