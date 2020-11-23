include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h
.DATA
@cont	dd	?
@aux	dd	?
contador	dd	?
promedio	dd	?
actual	dd	?
suma	dd	?
nombre	dd	?
_cte0	dd	80.000000
_string0	db	"Prueba.txt LyC Tema 4!",'$',22 dup (?)
_string1	db	"Ingrese entero actual: ",'$',23 dup (?)
_cte1	dd	0.000000
_cte2	dd	2.500000
_cte3	dd	92.000000
_cte4	dd	1.000000
_cte5	dd	0.342000
_cte6	dd	256.000000
_cte7	dd	52.000000
_cte8	dd	4.000000
_string2	db	"La suma es: ",'$',12 dup (?)
_cte9	dd	2.000000
_cte10	dd	0.000000
_string3	db	"actual es > 2 y <> 0",'$',20 dup (?)
_string4	db	"no es mayor que 2",'$',17 dup (?)
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
.CODE
START:
MOV EAX,@DATA
MOV DS, AX
MOV ES, AX
FLD _cte0
FSTP nombre
MOV DX, OFFSET _string0
MOV AH, 9
INT 21H
MOV DX, OFFSET _string1
MOV AH, 9
INT 21H
GetFloat actual
FLD _cte1
FSTP contador
FLD _cte2
FLD nombre
FADD
FSTP @aux0
FLD @aux0
FSTP suma
INICIOWHILE0:
FLD contador
FCOMP _cte3
FSTSW AX
SAHF
JA FINWHILE0
FLD contador
FLD _cte4
FADD
FSTP @aux1
FLD @aux1
FSTP contador
FLD contador
FDIV _cte5
FSTP @aux2
FLD actual
FMUL contador
FSTP @aux3
FLD @aux3
FSTP @aux
FLD 0
FSTP @cont
FLD @aux
FCOMP _cte6
FSTSW AX
SAHF
JNE FINIF0
FLD @cont
FLD 1
FADD
FSTP @aux4
FINIF0:
FLD nombre
FMUL suma
FSTP @aux5
FLD @aux
FCOMP @aux5
FSTSW AX
SAHF
JNE FINIF1
FLD @cont
FLD 1
FADD
FSTP @aux6
FINIF1:
FLD @aux
FCOMP _cte7
FSTSW AX
SAHF
JNE FINIF2
FLD @cont
FLD 1
FADD
FSTP @aux7
FINIF2:
FLD @aux
FCOMP _cte8
FSTSW AX
SAHF
JNE FINIF3
FLD @cont
FLD 1
FADD
FSTP @aux8
FINIF3:
FLD contador
FMUL @cont
FSTP @aux9
FLD @aux2
FLD @aux9
FADD
FSTP @aux10
FLD @aux10
FSTP actual
FLD suma
FLD actual
FADD
FSTP @aux11
FLD @aux11
FSTP suma
JMP INICIOWHILE0
FINWHILE0:
MOV DX, OFFSET _string2
MOV AH, 9
INT 21H
DisplayFloat suma, 2
FLD actual
FCOMP _cte9
FSTSW AX
SAHF
JNA FINIF4
FLD actual
FCOMP _cte10
FSTSW AX
SAHF
JE FINIF4
MOV DX, OFFSET _string3
MOV AH, 9
INT 21H
JMP FINELSE4
FINIF4:
MOV DX, OFFSET _string4
MOV AH, 9
INT 21H
FINELSE4:
MOV EAX,4c00h
int 21h
END START