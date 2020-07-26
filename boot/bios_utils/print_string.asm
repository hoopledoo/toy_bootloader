; We will receive the pointer to the string in bx
print_string:  
  pusha		; save off all registers  

loop:
  mov al, [bx]	; Extract the low 4-bits pointed to by bx
		; which will be the next character in the string
  cmp al, 0	; if it's 0, we've reached the null-terimator
  je done_print

  mov ah, 0x0e	; BIOS command code for teletype
  int 0x10	; cause the interrupt to print

  add bx, 1
  jmp loop

done_print:
  popa		; recover all registers
  ret

; print a newline
print_newline:
  pusha

  mov al, 0x0a
  mov ah, 0x0e
  int 0x10
  mov al, 0x0d
  int 0x10

  popa
  ret	
