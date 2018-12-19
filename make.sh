yacc -d fe.y
lex fe.l
gcc y.tab.c lex.yy.c impl.c -ll -o a.out `pkg-config --cflags gtk+-3.0` `pkg-config --libs gtk+-3.0`