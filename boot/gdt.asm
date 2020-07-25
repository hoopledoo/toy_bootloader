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
  
