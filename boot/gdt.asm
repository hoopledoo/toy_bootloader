; Here we'll lay out the Global Descriptor Table
gdt_start:

gdt_null:	; mandatory null entry
  dd 0x0	; we're storing off 2 double-words
  dd 0x0	; where a double word is 32-bits

; recall that the gdt descriptor structure is weird, as follows:
; bits 0-15 	= segment limit	[0-15]
; bits 16-31 	= base address	[0-15]
; bits 32-39	= base address	[16-23]
; bits 40-43	= type
; bit  44	= Descriptor type (0 = system, 1 = code or data)
; bits 45-46	= Descriptor privilege level
; bit  47	= Segment present (updated by MMU)
; bits 48-51	= segment limit [16-19]
; bit  52 	= available for use by system software
; bit  53 	= 64-bit flag (we'll use 0)
; bit  54	= default operation size (0 = 16-bit, 1 = 32-bit)
; bit  55	= Granularity
; bits 56-63	= base address	[24-31]

gdt_code:	; the code segment descriptor
  ; base=0x0, limit=0xfffff,
  ; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
  ; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
  ; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
  dw 0xffff	; segment limit bits 0-15
  dw 0x0	; base address bits [0-15]
  db 0x0	; base address bits [16-23]
  db 10011010b	; 1st flags, type flags (ordered this way for endianness)
  db 11001111b	; 2nd flags, limit bits [16-19] 
  db 0x0	; base address bits [24-31]

gdt_data:	; the data segment descriptor
  ; same as the code segment, except for the type flags:
  ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
  dw 0xffff	; segment limit bits 0-15
  dw 0x0	; base address bits [0-15]
  db 0x0	; base address bits [16-23]
  db 10010010b	; 1st flags, type flags (ordered this way for endianness)
  db 11001111b	; 2nd flags, limit bits [16-19] 
  db 0x0	; base address bits [24-31]

gdt_end:	; The reason for putting a label at the end of the GDT
		; is so we can have the assembler calculate
		; the size of the GDT for the GDT descriptor (below)

; GDT descriptor
gdt_descriptor:
  dw gdt_end-gdt_start-1 	; the size of our GDT, always less one
  dd gdt_start			; store the start address of GDT

; Define some handy constants for the GDT segment descriptor offsets, which
; are what segment registers must contain when in protected mode. For example,
; when we set DS = 0x10 in PM, the CPU knows that we mean it to use the 
; segment described at offset 0x10 (i.e. 16 bytes) in our GDT, which in our
; case is the DATA segment (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code-gdt_start
DATA_SEG equ gdt_data-gdt_start
