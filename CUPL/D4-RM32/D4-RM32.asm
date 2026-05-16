PAL16L8                                               PAL DESIGN SPECIFICATION
D4-RM32   108053-001                                    PAUL R. CULLEY 04/02/86
D4 PAGE RAM BOARD M32 decode logic Copyright Compaq Computer Houston, Texas 1986

A31   A23   A22   A21   A20   A19   A18   A17   FA20   GND
/2M  /M32A /M32B /ROM /512K /640K  /1M   /8M   /M32C   VCC

IF (/A22 * /A21) M32A = 
  /A31*/A23*/A22*/A21*/A20*/A19*/A18                   ;000000-03FFFF 256K
+ /A31*/A23*/A22*/A21*/A19*/A18*/FA20                  ;000000-03FFFF 256K
+ /A31*/A23*/A22*/A21*/A20*/A19* A18* 512K             ;040000-07FFFF 256K
+ /A31*/A23*/A22*/A21*/A20* A19*/A18*/A17* 640K        ;080000-09FFFF 128K
+ /A31*/A23*/A22*/A21*/A20* A19* A18* A17* ROM         ;0E0000-0FFFFF 128K
+ /A31*/A23*/A22*/A21* A20* 1M                         ;100000-1FFFFF 1M
+ /A31* A23*/A22*/A21* 8M                              ;800000-9FFFFF 2M

IF (A22 * /A21) M32B = 
  /A31*/A23* A22*/A21* 8M                              ;400000-5FFFFF 2M
+  A31* A23* A22*/A21*/A20*/A19*/A18*/A17              ;DIAG 8000000h 128K

IF (A21) M32C =
  /A31* A23* A22* A21* A20*/A19* A18* /512K            ;F40000-F7FFFF 256K
+ /A31* A23* A22* A21* A20* A19*/A18*/A17*/640K        ;F80000-F9FFFF 128K
+ /A31* A23* A22* A21* A20* A19*/A18* A17              ;FA0000-FBFFFF 128K
+ /A31* A23* A22* A21* A20* A19* A18                   ;FC0000-FFFFFF 256K
+ /A31*/A23* A22* A21* 8M                              ;600000-7FFFFF 2M
+ /A31*/A23*/A22* A21* 2M                              ;200000-3FFFFF 2M

FUNCTION TABLE
A31 A23 A22 A21 A20 A19 A18 A17 FA20 /512K /640K /1M /2M /8M /ROM /M32A /M32B /M32C
;                              / / /
;                F / /       / M M M
;A A A A A A A A A 5 6 / / / R 3 3 3
;3 2 2 2 2 1 1 1 2 1 4 2 8 B O 2 2 2
;1 3 2 1 0 9 8 7 0 2 0 M M M M A B C
-----------------------------------------------------------~-------------
 H H H L L L L L L L L L L L L Z L Z DIAG
 H L H L H L L L L L L L L L L Z H Z OFF
 H L H H L L L L H H L L L L L Z Z H OFF
 H L L L L L L L H L L L L L L H Z Z OFF
 L L L L L L L L H L L L L L L L Z Z 256K
 L L L L H L L L L L L L L L L L Z Z 256K
 L L L L L L H L L L L L L L L L Z Z 512K
 L L L L L H L L L L L L L L L L Z Z 640K
 L L L L L H H H L L L L L L L L Z Z 128K AT 0E0000h
 L H H H H L H L L H L L L L L Z Z L 256K AT F40000h
 L H H H H H L L L H H L L L L Z Z L 128K AT F80000h
 L H H H H H L H L L L L L L L Z Z L 128K AT FA0000h
 L H H H H H H L L L L L L L L Z Z L 256K AT FC0000h
 L L L L H H H H H L L L L L L L Z Z 1M AT 100000h
 L L L H L L L L L L L L L L L Z Z L 2M AT 200000h
 L L H L L L L L L L L L L L L Z L Z 2M AT 400000h
 L L H H L L L L L L L L L L L Z Z L 2M AT 600000h
 L H L L L L L L L L L L L L L L Z Z 2M AT 500000h
 L H L L L L L L L L L L L H L H Z Z 2M AT 800000h OFF
 L L L H L L L L L L L L H L L Z Z H 2M AT 200000h OFF
 L L L L H L L L H L L H L L L H Z Z 1M AT 100000h OFF
-----------------------------------------------------------~-------------

DESCRIPTION
This PAL is used in the D4 (386) memomy board to decode addresses within the
memory space and assert the M32* signal. It does all the decoding for all the 
expected options according to the following jumper settings.

512K 640K                              1M
H    H 256K     000000-03FFFFh         H       NO EXTENDED MEMORY
L    H 512K     000000-07FFFFh         L       1024K   100000-1FFFFFh
L    L 640K     000000-9FFFFFh         
H    L ****     ILLEGAL
8M 2M
H  H   OK
H  L   2048K    200000-3FFFFFh
L  H   6144K    400000-9FFFFFh (NOTE: The 8 Meg board asserts both 8M and 2M
L  L  8192K     200000-9FFFFFh strobes)

When FA20 is low, the address line A20 should be considered to be low.
When FA20 is high, A20 is decoded as usual.

The above set of m32 outputs are wire ORed to form the signal M32*. The
actual equation for M32 is shown below.
M32 = /A31*/A23*/A22*/A21*/A20*/A19*/A18            ;000000-03FFFF 256K
+     /A31*/A23*/A22*/A21*     /A19* /A18*    /FA20 ;000000-03FFFF 256K
+     /A31*/A23*/A22*/A21*/A20*/A19* A18*      512K ;040000-07FFFF 256K
+     /A31*/A23*/A22*/A21*/A20* A19*/A18*/A17* 640K ;080000-09FFFF 128K
+     /A31*/A23*/A22*/A21*/A20* A19* A18* A17* ROM  ;0E0000-0FFFFF 128K
+     /A31* A23* A22* A21* A20*/A19* A18*     /512K ;F40000-F7FFFF 256K
+     /A31* A23* A22* A21* A20* A19*/A18*/A17*/640K ;F80000-F9FFFF 128K
+     /A31* A23* A22* A21* A20* A19*/A18* A17       ;FA0000-FBFFFF 128K
+     /A31* A23* A22* A21* A20* A19* A18            ;FC0000-FFFFFF 256K
+     /A31*/A23*/A22*/A21* A20*                1M   ;100000-1FFFFF 1M
+     /A31*/A23*/A22* A21*                     2M   ;200000-3FFFFF 2M
+     /A31*/A23* A22*/A21*                     8M   ;400000-5FFFFF 2M
+     /A31*/A23* A22* A21*                     8M   ;600000-7FFFFF 2M
+     /A31* A23*/A22*/A21*                     8M   ;800000-9FFFFF 2M
+     A31*  A23* A22*/A21*/A20*/A19*/A18*/A17       ;DIAG 80C0000h 128K
