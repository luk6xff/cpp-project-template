#include <stdio.h>
 
int main ()
{
  unsigned int x = 0x76543210;
  unsigned char *c = (unsigned char*) &x;
 
  if (*c == 0x10)
  {
    printf ("Underlying architecture is little endian. \n");
  }
  else
  {
     printf ("Underlying architecture is big endian. \n");
  }
  
  if ((*(c++)) == 0x32)
  {
  	
    printf ("Underlying architecture is little endian. 0x%x\n", *c);
  }
  else
  {
     printf ("Underlying architecture is big endian. 0x%x\n", *c);
  }
 
  return 0;
}
