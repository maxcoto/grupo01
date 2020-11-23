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
_80.000000	dd	80.000000
_string0	db	"Prueba.txt LyC Tema 4!",'$',22 dup (?)
_string1	db	"Ingrese entero actual: ",'$',23 dup (?)
_0.000000	dd	0.000000
_2.500000	dd	2.500000
_92.000000	dd	92.000000
_1.000000	dd	1.000000
_0.342000	dd	0.342000
_256.000000	dd	256.000000
_52.000000	dd	52.000000
_4.000000	dd	4.000000
_0.342000	dd	0.342000
_256.000000	dd	256.000000
_52.000000	dd	52.000000
_4.000000	dd	4.000000
_string2	db	"La suma es: ",'$',12 dup (?)
_2.000000	dd	2.000000
_0.000000	dd	0.000000
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
@aux12	dd	?
@aux13	dd	?
@aux14	dd	?
@aux15	dd	?
@aux16	dd	?
@aux17	dd	?
@aux18	dd	?
@aux19	dd	?
@aux20	dd	?

.CODE
START:
MOV AX, @DATA
MOV DS, AX
MOV ES, AX

MOV DX, OFFSET _string0
MOV AH, 9
INT 21H
MOV DX, OFFSET _string1
MOV AH, 9
INT 21H
GetFloat actual
FLD _0.000000
FSTP contador
FLD _2.500000
FLD nombre
FADD
FSTP @aux0

FLD @aux0
FSTP suma
INICIOWHILE0
FLD contador
FCOMP _92.000000
FSTSW AX
SAHF
JA FINWHILE0
FLD contador
FLD _1.000000
FADD
FSTP @aux1

FLD @aux1
FSTP contador
FLD contador
FDIV _0.342000
FSTP @aux2

FLD actual
FMUL contador
FSTP @aux3

FLD @aux3
FSTP @aux
FLD 0
FSTP @cont
FLD @aux
FCOMP _256.000000
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
FCOMP _52.000000
FSTSW AX
SAHF
JNE FINIF2
FLD @cont
FLD 1
FADD
FSTP @aux7

FINIF2:
FLD @aux
FCOMP _4.000000
FSTSW AX
SAHF
JNE FINIF3
FLD @cont
FLD 1
FADD
FSTP @aux8

FINIF3:
FLD contador
FMUL ninguna
FSTP @aux9

FLD @aux2
FLD @aux9
FADD
FSTP @aux10

FLD @aux10
FSTP actual
FLD contador
FDIV _0.342000
FSTP @aux11

FLD actual
FMUL contador
FSTP @aux12

FLD @aux12
FSTP @aux
FLD 0
FSTP @cont
FLD @aux
FCOMP _256.000000
FSTSW AX
SAHF
JNE FINIF4
FLD @cont
FLD 1
FADD
FSTP @aux13

FINIF4:
FLD nombre
FMUL suma
FSTP @aux14

FLD @aux
FCOMP @aux14
FSTSW AX
SAHF
JNE FINIF5
FLD @cont
FLD 1
FADD
FSTP @aux15

FINIF5:
FLD @aux
FCOMP _52.000000
FSTSW AX
SAHF
JNE FINIF6
FLD @cont
FLD 1
FADD
FSTP @aux16

FINIF6:
FLD @aux
FCOMP _4.000000
FSTSW AX
SAHF
JNE FINIF7
FLD @cont
FLD 1
FADD
FSTP @aux17

FINIF7:
FLD contador
FMUL ninguna
FSTP @aux18

FLD @aux11
FLD @aux18
FADD
FSTP @aux19

FLD @aux19
FSTP actual
FLD suma
FLD actual
FADD
FSTP @aux20

FLD @aux20
FSTP suma
JMP INICIOWHILE0
FINWHILE0:
MOV DX, OFFSET _string2
MOV AH, 9
INT 21H
DisplayFloat suma, 2
FLD actual
FCOMP _2.000000
FSTSW AX
SAHF
JNA FINIF8
FLD actual
FCOMP _0.000000
FSTSW AX
SAHF
JE FINIF8
MOV DX, OFFSET _string3
MOV AH, 9
INT 21H
JMP FINELSE8
FINIF8:

MOV DX, OFFSET _string4
MOV AH, 9
INT 21H
FINELSE8:


MOV AX,4c00h
int 21h

END