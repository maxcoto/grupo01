include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h
.DATA
@cont	dd	?
@aux	dd	?
@uno	dd	1.0
@cero	dd	0.0
contador	dd	?
promedio	dd	?
actual	dd	?
suma	dd	?
_cte0	dd	2.000000
_cte1	dd	4.000000
_cte2	dd	10.000000
_cte3	dd	10.000000
_cte4	dd	10.000000
_cte5	dd	10.000000
_cte6	dd	10.000000
_cte7	dd	20.000000
_cte8	dd	30.000000
_cte9	dd	40.000000
_cte10	dd	10.000000
_cte11	dd	3.000000
_cte12	dd	7.000000
_cte13	dd	20.000000
_string0	db	"Resultado: ",'$',11 dup (?)
@aux0	dd	?
@aux1	dd	?
@aux2	dd	?
@aux3	dd	?
@aux4	dd	?
@aux5	dd	?
@aux6	dd	?
@aux7	dd	?
@aux8	dd	?
@aux9	dd	?
@aux10	dd	?
@aux11	dd	?
@aux12	dd	?
.CODE
START:
MOV EAX,@DATA
MOV DS, AX
MOV ES, AX
FLD _cte0
FLD _cte1
FADD
FSTP @aux0
FLD _cte2
FSTP @aux
FLD @cero
FSTP @cont
FLD @aux
FCOMP _cte3
FSTSW AX
SAHF
JNE FINIF0
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF0:
FLD @aux
FCOMP _cte4
FSTSW AX
SAHF
JNE FINIF1
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF1:
FLD @aux
FCOMP _cte5
FSTSW AX
SAHF
JNE FINIF2
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF2:
FLD @aux
FCOMP _cte6
FSTSW AX
SAHF
JNE FINIF3
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF3:
FLD @aux
FCOMP _cte7
FSTSW AX
SAHF
JNE FINIF4
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF4:
FLD @aux
FCOMP _cte8
FSTSW AX
SAHF
JNE FINIF5
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF5:
FLD @aux
FCOMP _cte9
FSTSW AX
SAHF
JNE FINIF6
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF6:
FLD @aux
FCOMP _cte10
FSTSW AX
SAHF
JNE FINIF7
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF7:
FLD _cte11
FLD _cte12
FADD
FSTP @aux9
FLD @aux
FCOMP @aux9
FSTSW AX
SAHF
JNE FINIF8
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF8:
FLD @aux
FCOMP _cte13
FSTSW AX
SAHF
JNE FINIF9
FLD @cont
FLD @uno
FADD
FSTP @cont
FINIF9:
FLD @aux0
FLD @cont
FADD
FSTP @aux12
FLD @aux12
FSTP actual
MOV DX, OFFSET _string0
MOV AH, 9
INT 21H
DisplayFloat actual, 2
MOV EAX,4c00h
int 21h
END START