flex -d lexico.l
sleep 1
bison sintactico.y
sleep 1
gcc lex.yy.c sin.yy.c -o compilador.c
sleep 1
./compilador.c prueba.txt
rm lex.yy.c
rm sin.yy.c
rm compilador.c
