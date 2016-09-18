#include <stdio.h>
#include <string.h>
#include <iostream>
using namespace std;
//For example, if all characters in the string “aeiou” are deleted from the string “We are students.”, the
//result is “W r stdnts.”.

static void DeleteCharacters(char* pString, char* pCharsToBeDeleted) {
	
	int hashTable[256];
	
	const char* pTemp = pCharsToBeDeleted;
	char* pSlow = pString;
	char* pFast = pString;
	
	if(pString == NULL || pCharsToBeDeleted == NULL)
		return;
	memset(hashTable, 0, sizeof(hashTable));
	while (*pTemp != '\0') {
		hashTable[*pTemp] = 1;
		++ pTemp;
	}
	while(*pFast!='\0'){
		if(hashTable[*pFast]!=1){
			*pSlow=*pFast;
			pSlow++;
		}
		++pFast;
	}
	*(pSlow)='\0';
}



int main() {
char firstString[]={"We are students"};
char secondString[]={"aeiou"};
printf("%s\n",firstString );
DeleteCharacters(firstString, secondString);

printf("%s\n",firstString );

	return 0;
}