-----------INITIALIZATION SUBROUTINE----------
To be called at starting starts at 0x000
Terminates at 0x0022
----------------------------------------------
INIT:MVI A,92
OUT 03
MVI A,80
OUT 07
MVI D,08
LXI H,0000
MVI B,00
MVI C,41
loop_init:MOV M,C
INX H
MOV M,B
INX H
MOV M,B
INR C
DCR D
JNZ loop_init
CALL DELAY
-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x

-----------------EMERGENCY INTERRUPT---------------
This subroutine will be activated by the pressing of 19 simultaneously
and it will be writen at the location of TRAP i.e. 0x0024
Terminates at 0x003F
----------------------------------------------------
TRAP:RIM 
JP wait1
IN 00
RLC
RLC
RLC
RLC
MOV B,A
wait2:RIM
JP wait2
IN 00
ADD B
CMA
CPI 37
JMP SKIP // since the display is called by rst 7.5 we need to account for
JMP DISP // that line i.e.0x003C
JNZ TRAP
JMP COUNT
-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x
-----------------SECURITY--------------------------
This subroutine will verify the security codes
----------------------------------------------------
SECURITY:LXI H,0018
wait1:RIM 
JP wait1
IN 00
RLC
RLC
RLC
RLC
MOV B,A
wait2:RIM
JP wait2
IN 00
ADD B
CMA
CMP M
RNZ
INX H
DCR D
JNZ wait1
JMP COUNT
-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x
-----------------COUNT-----------------------------
This subroutine will count the votes
----------------------------------------------------
COUNT:LXI H,0000
wait3:RIM
JP wait3
IN 01
MVI B,08
loop_rot:ORI 00
CN cntup
INX H
INX H
INX H
RLC
DCR D 
JNZ loop_rot
JMP count
cntup:INX H
MOV C,M
INX H
MOV B,M
PUSH H
LXI H 0001
DAD D
XCHG
POP H
MOV M,B
DCX H
MOV M,C
INX H
INX H
RET 
-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x
-----------------DELAY-----------------------------
This subroutine will initialize the delay
----------------------------------------------------
DELAY:mvi a, 
out 0B
mvi a, ff
out c0
mvi a,ff
out c0
mvi a, 
out 0B
mvi a, B2
out c1
mvi a, C4
out c1
mvi a,
out 0B
mvi a, 36
out c2
mvi a, 00
out c2
jmp COUNT
-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x
-----------------DISPLAY-----------------------------
This subroutine will Display the results
----------------------------------------------------
DISP:LXI H,1021
MOV A,M
OUT 04
PUSH H
LXI H,1001
REP:MVI C,08
MVI D,02
MVI B,80
LOOP1:MOV A,M
ANI 0F
ADD B
OUT 02
MOV A,B
RRC
MOV B,A
MOV A,M
ANI F0
RRC
RRC
RRC
RRC
ADD B
OUT 02
MOV A,B
RRC
MOV B,A
INX H
DCR D
JNZ LOOP1
RIM
CP REPEAT
INX H
XCHG
POP H
INX H
OUT 04
PUSH H
XCHG
DCR C
JNZ REP
JMP DISP
REPEAT:DCX H
JMP REP
-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x


