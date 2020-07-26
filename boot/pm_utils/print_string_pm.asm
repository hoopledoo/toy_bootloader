[bits 32]
; We will receive the string in ebx, and we need to print it
VGA_BUFFER equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print_string_pm:
  pusha
  mov edx, VGA_BUFFER

print_string_pm_loop:
  mov ax, [ebx]
  mov ah, WHITE_ON_BLACK

  cmp al, 0		; stop at null terminator
  je print_string_pm_done

  mov [edx], ax
  add ebx, 1		; advance to the next character to print
  add edx, 2		; advance to the next spot in the buffer

  jmp print_string_pm_loop

print_string_pm_done:
  popa
  ret
