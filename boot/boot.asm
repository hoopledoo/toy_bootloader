; A boot sector that enters 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000	; this is the memory offset to which we'll
				; load our kernel (it also is built into 
				; a binary with this as the -Ttext)

  mov [BOOT_DRIVE], dl		; BIOS stores our boot drive in DL, so it's
				; good to remember it for later
  
  mov bp, 0x9000	; set up stack
  mov sp, bp		

  mov bx, MSG_REAL_MODE
  call print_string
  call print_newline

  call load_kernel

  call switch_to_pm	; we'll never return from here

  jmp $

%include "bios_utils/print_string.asm"
%include "bios_utils/switch_to_pm.asm"
%include "bios_utils/disk_load.asm"
%include "pm_utils/print_string_pm.asm"
%include "gdt.asm"

[bits 16]

; load_kernel
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string
  call print_newline

  mov bx, KERNEL_OFFSET		; Setup the parameters for our disk_load 
  mov dh, 4			; routine so we load the first 4 sectors
  mov dl, [BOOT_DRIVE]		; (excluding the boot sector) from the
  call disk_load		; boot disk (i.e. our kernel code)
				; to address KERNEL_OFFSET
  ret

[bits 32]
; This is where we land after switching to Protected mode
BEGIN_PM:
 
  mov ebx, MSG_PROT_MODE
  call print_string_pm		; Use our 32-bit print routine

  call KERNEL_OFFSET		; Now jump to the address of our 
				; loaded kernel code (0x1000)!

  jmp $		; hang.

; Global variables
BOOT_DRIVE:	db 0
MSG_REAL_MODE: 	db "Started in 16-bit Real Mode",0
MSG_PROT_MODE:	db "Successfully landed in 32-bit Protected Mode",0
MSG_LOAD_KERNEL:db "Loading kernel into memory...",0

; Bootsector padding
times 510-($-$$) db 0
; Bootsector magic bytes
dw 0xaa55
