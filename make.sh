yacc -d fe.y
flex fe.l
g++ y.tab.c lex.yy.c impl.c father.h -ll -o a.out `pkg-config --cflags gtk+-3.0` `pkg-config --libs gtk+-3.0`
