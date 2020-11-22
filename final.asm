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
pepe	dd	?
_string0	db	"metemos un texto.",'$',19 dup (?)
_string1	db	"Prueba.txt LyC Tema 4!",'$',24 dup (?)
_string2	db	"La suma es: ",'$',14 dup (?)

.CODE
START:
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

MOV DX, OFFSET _string1
MOV AH, 9
INT 21H
MOV DX, OFFSET _string2
MOV AH, 9
INT 21H
DisplayFloat suma, 2


MOV AX,4c00h
int 21h

END