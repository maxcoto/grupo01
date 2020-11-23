include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h
.DATA
@cont	dd	?
@aux	dd	?
@uno	dd	1
@cero	dd	0
contador	dd	?
promedio	dd	?
actual	dd	?
suma	dd	?
_cte0	dd	2.000000
_string0	db	"actual es mayor que 2",'$',21 dup (?)
_string1	db	"312",'$',3 dup (?)
_cte1	dd	1.000000
_string2	db	"actual es mayor que 2",'$',21 dup (?)
_string3	db	"no es mayor que 2",'$',17 dup (?)
_cte2	dd	1.000000
_string4	db	"actual es mayor que 2",'$',21 dup (?)
_string5	db	"no es mayor que 2",'$',17 dup (?)
.CODE
START:
MOV EAX,@DATA
MOV DS, AX
MOV ES, AX
INICIOWHILE0:
FLD promedio
FCOMP _cte0
FSTSW AX
SAHF
JE FINWHILE0
MOV DX, OFFSET _string0
MOV AH, 9
INT 21H
MOV DX, OFFSET _string1
MOV AH, 9
INT 21H
FLD actual
FCOMP _cte1
FSTSW AX
SAHF
JNA FINIF0
MOV DX, OFFSET _string2
MOV AH, 9
INT 21H
JMP FINELSE0
FINIF0:
MOV DX, OFFSET _string3
MOV AH, 9
INT 21H
FINELSE0:
FLD actual
FCOMP _cte2
FSTSW AX
SAHF
JNA FINIF1
MOV DX, OFFSET _string4
MOV AH, 9
INT 21H
JMP FINELSE1
FINIF1:
MOV DX, OFFSET _string5
MOV AH, 9
INT 21H
FINELSE1:
JMP INICIOWHILE0
FINWHILE0:
MOV EAX,4c00h
int 21h
END START