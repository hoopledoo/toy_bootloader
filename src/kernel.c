void main()
{
  char* VGA_Buffer = (char *)0xb8000;
  *VGA_Buffer = 'H';
  *VGA_Buffer+=2;
  *VGA_Buffer = 'i';
  *VGA_Buffer+=2;
  *VGA_Buffer = '!';
}
