include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
contador	dd	?
promedio	dd	?
actual	dd	?
suma	dd	?
_10.000000	dd	10.000000
_20.000000	dd	20.000000
_30.200001	dd	30.200001
_40.000000	dd	40.000000
@aux0	dd	?

.CODE
START:
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

FLD _10.000000
FCOMP _20.000000
FSTSW AX
SAHF
JE IF1
FLD _30.200001
FMUL _40.000000
FSTP @aux0

FLD @aux0
FSTP actual
IF1:


MOV AX,4c00h
int 21h

END