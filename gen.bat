c:\GnuWin32\bin\flex lexico.l

pause 
c:\GnuWin32\bin\bison.exe --debug -dyv sintactico.y
pause 

c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Primera.exe
pause 

pause
Primera.exe prueba.txt

del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause 