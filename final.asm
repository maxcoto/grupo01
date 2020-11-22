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
MOV AX, @DATA
MOV DS, AX
MOV ES, AX
FLD 20
FIMUL 30
FSTP @aux0

FLD 10
FIADD @aux0
FSTP @aux1

FLD 50
FIADD 60
FSTP @aux2

FLD 40
FIDIV @aux2
FSTP @aux3

FLD @aux1
FISUB @aux3
FSTP @aux4

FLD @aux4
FIADD 70
FSTP @aux5

mov ax,4c00h
int 21h

END