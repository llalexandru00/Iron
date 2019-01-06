yacc -d fe.y
flex fe.l
g++ y.tab.c lex.yy.c impl.c mem/MemoryControl.cpp mem/Environment.cpp -ll -std=c++11 -o a.out `pkg-config --cflags gtk+-3.0` `pkg-config --libs gtk+-3.0`
