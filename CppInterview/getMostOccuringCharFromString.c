#include <iostream>
using namespace std;
 
char getMostOccuringChar(char* pString) {
 if(pString == NULL)
 return 0;
 const int tableSize = 256;
 unsigned int hashTable[tableSize];
 for(unsigned int i = 0; i<tableSize; ++ i)
 	hashTable[i] = 0;
 while(*(pString++) != '\0')
 	hashTable[*(pString)] ++;
 
 int max=0;
 for(int i=0;i<255;i++){
 	if(hashTable[i]>hashTable[max])
    	max=i;
 }
 return (char)max;
 
}


int main(void){

	cout<<getMostOccuringChar("chaaaarpString");;
	
}
