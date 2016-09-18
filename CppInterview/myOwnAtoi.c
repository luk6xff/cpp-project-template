//atoi function implementation - author: Lukasz Uszko

#include <iostream>
#include <cctype>
#include <assert.h>
using namespace std;

int atoi( const char * str ) {
	
	if(str==NULL)
		return 0;
	
	int sign= 1;
	int number=0;
	if(*str=='-'){
		sign =-1;
		str++;
	}
	
	while(isdigit(*str)){
		number*=10;
		number+=(*str)-'0';
		str++;
	}
    return number*sign;
}


int main() {

	assert(998 == atoi("998"));
    assert(0 == atoi("0"));
    assert(-123123 == atoi("-123123"));
    assert(-123123444 == atoi("-123123444"));
    assert(-1 == atoi("-1"));
    cout<<"All tests passed!!!"; //must reach here
	
	return 0;
}