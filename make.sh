ca65 boot.a65 -o boot.o
ca65 bitmap.a65 -o bitmap.o
ca65 window.asm -o window.o
ca65 patwin.asm -o patwin.o
ca65 string.asm -o string.o
ld65 boot.o bitmap.o driver.o window.o patwin.o string.o -o tracker.prg -C link.config -Ln labels.txt
