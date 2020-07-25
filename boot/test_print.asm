; A boot sector that enters 32-bit protected mode
[org 0x7c00]
  
  mov bp, 0x9000	; set up stack
  mov sp, bp		

  mov bx, MSG_REAL_MODE
  call print_string

  jmp $

%include "bios_utils/print_string.asm"

; Global variables
MSG_REAL_MODE: 	db "Started in 16-bit Real Mode",0

; Bootsector padding
times 510-($-$$) db 0

; Bootsector magic bytes
dw 0xaa55
