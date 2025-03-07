[bits 64]

extern opendir
extern readdir
extern atoi
extern printf

global _start

section .text
_start:

	; Use rbx as a pointer to DIR struct
	; rcx as ndx
	
	sub rsp, 16
	mov qword [rsp+8], 0

	mov rdi, root
	call opendir wrt ..plt

	mov rdi, rax
	mov rbx, rdi

	mov rax, [rsp+16]

	cmp rax, 2
	jge give_name
list_dir:
	call readdir wrt ..plt

	mov [rsp], rax

	cmp rax, 0
	je end

	; Dont print if it is . or ..

	mov rax, [rsp]
	add rax, 8+8+2+1
	
	cmp byte [rax], '.'
	jne print_entry
	cmp byte [rax+1], 0
	je next_entry
	cmp byte [rax+1], '.'
	jne print_entry
	cmp byte [rax+2], 0
	je next_entry

print_entry:
	mov rsi, [rsp+8]
	mov rdx, [rsp]
	add rdx, 8+8+2+1
	mov rdi, dir_list
	xor rax, rax

	call printf wrt ..plt

	mov rax, [rsp+8]
	inc rax
	mov [rsp+8], rax
next_entry:
	mov rdi, rbx
	jmp list_dir

give_name:
	add rsp, 16
	mov rdi, [rsp+8+8]
	call atoi wrt ..plt

	mov [rsp], rax

	mov rcx, rax
	mov [rsp+8], rbx
	mov rdi, rbx
	xor rbx, rbx
next_name:
	call readdir wrt ..plt

	add rax, 8+8+2+1
	
	cmp byte [rax], '.'
	jne next_name_inc
	cmp byte [rax+1], 0
	je next_name
	cmp byte [rax+1], '.'
	jne next_name_inc
	cmp byte [rax+2], 0
	je next_name
next_name_inc:
	mov rdi, [rsp+8]

	inc rbx
	cmp [rsp], rbx
	jge next_name

	;setup the string to print to in [rsp], destructive cause we just exit after

	xor rdx, rdx
	inc rdx
	mov rsi, rsp
fill_name_loop:
	mov byte bl, [rax]
	mov byte [rsi], bl
	inc rsi
	inc rdx
	inc rax
	cmp byte [rax], 0
	jne fill_name_loop

	mov byte [rsi], 10

	;dec rsi
	mov rsi, rsp; string to write
	mov rax, 1; write
	mov rdi, 1; stdout
	syscall

end:
	mov rax, 60
	xor rdi, rdi
	mov rdi, 1
	syscall

section .data
dir_list: db "%d: %s", 10, 0
root: db "./", 0
