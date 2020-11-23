c:\GnuWin32\bin\flex lexico.l
pause
c:\GnuWin32\bin\bison.exe -dyv sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o TPFinal.exe
pause
pause
TPFinal.exe prueba.txt
del lex.yy.c
pause

