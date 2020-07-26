[bits 16]
; We want to load DH sectors to ES:BS from drive DL
disk_load:
  push dx		; Store DX onto the stack so we can recall later
			; how many sectors were requested to be read
  mov ah, 0x02		; BIOS read sector function
  mov al, dh		; We want to read DH sectors
  mov ch, 0x00		; Cylinder = 0x00
  mov dh, 0x00		; head = 0x00
  mov cl, 0x02		; start reading from the second sector (i.e.
			; after the boot sector)
  int 0x13		; actually interrupt and cause the read through BIOS

  jc disk_error_1	; jump if error (if the carry flag is set)

  pop dx
  cmp dh, al		; make sure we read the amount we requested
  jne disk_error_2	; if we didn't print the error message

  mov bx, DISK_SUCCESS_MSG
  call print_string
  ret

disk_error_1:
  mov bx, DISK_ERROR_MSG_1
  call print_string
  jmp $

disk_error_2:
  mov bx, DISK_ERROR_MSG_2
  call print_string
  jmp $

; Variables
DISK_ERROR_MSG_1:	db "ERROR: failed on disk read interrupt",0
DISK_ERROR_MSG_2:	db "ERROR: failed to read the request # sectors",0
DISK_SUCCESS_MSG:	db "Disk read successful!",0
