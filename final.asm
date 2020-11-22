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
_10	dd	10
_20	dd	20
_30	dd	30
_40	dd	40
_50	dd	50
_60	dd	60
_70	dd	70
@aux0	dd	?
@aux1	dd	?
@aux2	dd	?
@aux3	dd	?
@aux4	dd	?
@aux5	dd	?

.CODE
START:
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

FLD _70
FCOMP _70
FSTSW AX
SAHF
JE IF1
FLD _70
FMUL _70
FSTP @aux0

FLD @aux0
FADD
FSTP @aux1

FLD _70
FADD
FSTP @aux2

FLD _70
FDIV @aux2
FSTP @aux3

FLD @aux1
FSUB @aux3
FSTP @aux4

FLD _70
FADD
FSTP @aux5

FLD @aux5
FSTP actual


MOV AX,4c00h
int 21h

END