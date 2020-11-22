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
_string0	db	"La suma es: ",'$',14 dup (?)

.CODE
START:
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

GetFloat suma
MOV DX, OFFSET _string0
MOV AH, 9
INT 21H
DisplayFloat suma, 2


MOV AX,4c00h
int 21h

END