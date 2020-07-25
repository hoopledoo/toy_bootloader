; A boot sector that enters 32-bit protected mode
[org 0x7c00]
  
  mov bp, 0x9000	; set up stack
  mov sp, bp		

  mov bx, MSG_REAL_MODE
  call print_string

  call switch_to_pm	; we'll never return from here

  jmp $

%include "bios_utils/print_string.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 32]
; This is where we land after switching to Protected mode
BEGIN_PM:
 
  mov ebx, MSG_PROT_MODE
  call print_string_pm		; Use our 32-bit print routine

  jmp $		; hang.

; Global variables
MSG_REAL_MODE: 	db "Started in 16-bit Real Mode",0
MSG_PROT_MODE:	db "Successfully landed in 32-bit Protected Mode",0

; Bootsector padding
times 510-($-$$) db 0

; Bootsector magic bytes
dw 0xaa55
