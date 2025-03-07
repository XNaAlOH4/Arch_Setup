nasm -felf64 get_name.s -o get_name.o
#gcc -nostdlib -lc get_name.o -o getname
ld get_name.o -o gname -lc --dynamic-linker /usr/lib64 #-lc --rpath /usr/lib64/ld-linux-x86-64.so.2
