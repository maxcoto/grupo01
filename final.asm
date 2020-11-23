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
_1.000000	dd	1.000000
_2.000000	dd	2.000000
_3.000000	dd	3.000000
_4.000000	dd	4.000000
@aux0	dd	?

.CODE
START:
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

FLD _1.000000
FCOMP _2.000000
FSTSW AX
SAHF
JAE FINIF
FLD _3.000000
FLD _4.000000
FADD
FSTP @aux0

FLD @aux0
FSTP actual
FINIF:


MOV AX,4c00h
int 21h

END