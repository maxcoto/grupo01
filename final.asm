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
_2.000000	dd	2.000000
_string0	db	"actual es mayor que 2",'$',23 dup (?)
_string1	db	"no es mayor que 2",'$',19 dup (?)
_2.000000	dd	2.000000
_string2	db	"actual es mayor que 2",'$',23 dup (?)
_string3	db	"no es mayor que 2",'$',19 dup (?)

.CODE
START:
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

FLD actual
FCOMP _2.000000
FSTSW AX
SAHF
JNA FINIF0
MOV DX, OFFSET _string0
MOV AH, 9
INT 21H
JMP FINELSE0
FINIF0:

MOV DX, OFFSET _string1
MOV AH, 9
INT 21H
FINELSE0:
FLD actual
FCOMP _2.000000
FSTSW AX
SAHF
JNA FINIF1
MOV DX, OFFSET _string2
MOV AH, 9
INT 21H
JMP FINELSE1
FINIF1:

MOV DX, OFFSET _string3
MOV AH, 9
INT 21H
FINELSE1:


MOV AX,4c00h
int 21h

END