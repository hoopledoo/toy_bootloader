; we start out in 16-bit mode
[bits 16]

switch_to_pm:

  cli 			; We must switch off interrupts until we have
			; set up the protected mode interrupt vector
			; otherwise interrupts will run riot
  lgdt [gdt_descriptor]	; Load our global descriptor table, which defines
			; the protected mode segments (e.g. for code & data)

  mov eax, cr0		; To make the switch to protected mode, we set
  or eax, 0x1		; the first bit of CR0 a control register
  mov cr0, eax	

  jmp CODE_SEG:init_pm	; Here we make a far jump to a new segment
			; with our 32-bit code. This also forces the CPU
			; to flush its cache of pre-fetched and real-mode
			; decoded instructions, which could cause problems

[bits 32]
; Initialize registers and the stack once in PM
init_pm:
  
  mov ax, DATA_SEG	; Now in PM, our old segments are meaningless,
  mov ds, ax		; so we point our segment registers to the
  mov ss, ax		; data segment we defined in our GDT
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000	; Update our stack position so it is right
  mov esp, ebp		; at the top of the free space

  call BEGIN_PM		; Finally, call our well-known label in the 32-bit
			; portion of our boot assembly

