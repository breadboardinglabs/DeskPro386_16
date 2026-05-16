PAL16L8                                               PAL DESIGN SPECIFICATION
D4-SCMDD  108394-001                                 PAUL R. CULLEY    01/09/87
Command encode and decode logic
Copyright 1986,1987 COMPAQ COMPUTER Houston, Texas

/CMD /DCMD  LM_IO LW_R  LD_C /RFSH  /BHLDA NCI1 NCI2 GND
/OE  /IOWC /MRDC /MWTC /IORC  MHLDA  M_IO  D_C  W_R  VCC

IF (/BHLDA* OE) MRDC =
  CMD  * LM_IO * /LW_R         ; PROCESSOR MEMORY READ
+ DCMD * MRDC                  ; SHORT READ HOLD

IF (/BHLDA* OE) MWTC =
  CMD * LM_IO * LW_R * LD_C    ;PROCESSOR MEMORY WRITE

IF (/BHLDA* OE) IORC =
  CMD  * /LM_IO * /LW_R * LD_C ;PROCESSOR I/O READ
+ DCMD * IORC                  ;SHORT READ HOLD

IF (/BHLDA* OE) IOWC =
  CMD * /LM_IO * LW_R * LD_C   ;PROCESSOR I/O WRITE

IF (BHLDA* OE) /M_IO = MWTC + MRDC ;NON CPU MEMORV OPERATION
IF (BHLDA* OE) /D_C  = RFSH        ;NON CPU REFRESH OPERATION
IF (BHLDA* OE) /W_R = MWTC         ;NON CPU WRITE OPERATION

/MHLDA =
  /BHLDA                           ;SAME A BHLDA EXCEPT
+ /MHLDA * /M_IO                   ;WHEN GOING HOLD, WAIT FOR M_IO TO GO HIGH

FUNCTION TABLE
/OE   /DCMD /CMD   LM_IO LD_C   LW_R /RFSH /BHLDA 
/MRDC /MWTC /IORC /IOWC  MHLDA  M_IO  D_C   W_R

;              /
;  /   L     / B   / / / / M
;  D / M L L R H   M M I I H M
;  C C - D W F L   R W O O L - D W
;O M M I - - S D   D T R W D I - -
;E D D O C R H A   C C C C A O C R
-------------------------------------------------------------------------
 L H L L L L L H   H H H H L Z Z Z ; INTA
 L H L L L H L H   H H H H L Z Z Z ;
 L H L L H L L H   H H L H L Z Z Z ; IORC
 L L L L H L L H   H H L H L Z Z Z ; IORC
 L L H L H L L H   H H L H L Z Z Z ; IORC
 L H L L H H L H   H H H L L Z Z Z ; IOWC
 L H L H L L L H   L H H H L Z Z Z ; CODE MRDC
 L H L H L H L H   H H H H L Z Z Z ;
 L H L H H L L H   L H H H L Z Z Z ; MRDC DATA
 L L L H H L L H   L H H H L Z Z Z ; MRDC DATA
 L L H H H L L H   L H H H L Z Z Z ; MRDC DATA
 L H L H H H L H   H L H H L Z Z Z ; MWTC
 L H H H H H L H   H H H H L Z Z Z ;
 H H H H H H L H   Z Z Z Z X Z Z Z ;
 H H H H H H L L   Z Z Z Z X Z Z Z ;
 L H H H H H L L   H H Z Z H H L H ; RFSH
 L H H H H H L L   L H Z Z H L L H ; RFSH MRDC
 L H H H H H H L   L H Z Z H L H H ; MRDC
 L H H H H H H L   H L Z Z H L H L ; MWTC
 H H L H H L H H   Z Z Z Z L L H H ;
 H H L H H L H L   Z Z Z Z L L H H ;
 H H H H H H H L   Z Z Z Z H H H H ;
-------------------------------------------------------------------------

DESCRIPTION
This PAL decodes the processor status lines and generates the normal command
output signals. These signals are floated during non processor commands.

In addition, the PAL decodes the non processor operations and feeds them to 
the cpu status bus during HOLDA.

Rev A of the PAL adds the input DCMD* and OE*. DCMD* is used to provide a 
short data hold time for read operations by extending MRDC and IORC by one 
PAL delay (10 ns). OE* is added to disable all outputs for testing.
Rev D of the PAL removes INTA and adds MHLDA for use in the DP3E D4-processor
board (with 387).

; HLDA M_IO D_C W_R
;  L    L    L   L    ; CPU INTERRUPT ACK
;  L    L    L   H    ; CPU NEVER PRODUCES THIS CODE
;  L    L    H   L    ; CPU I/O READ
;  L    L    H   H    ; CPU I/O WRITE
;  L    H    L   L    ; CPU MEMORY CODE READ
;  L    H    L   H    ; CPU HALT OR SHUTDOWN
;  L    H    H   L    ; CPU MEMORY DATA READ
;  L    H    H   H    ; CPU MEMORY DATA WRITE
;  H    L    L   L    ; NON CPU REFRESH WRITE (SHOULD NOT HAPPEN)
;  H    L    L   H    ; NON CPU REFRESH READ
;  H    L    H   L    ; NON CPU MEMORY WRITE
;  H    L    H   H    ; NON CPU MEMORY READ
;  H    H    L   X    ; NON CPU REFRESH CYCLE (BEFORE OR AFTER)
;  H    H    H   X    ; NON CPU NO CYCLE PRESENT
