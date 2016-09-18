////////////////////////1/////////////////////////////////////////////////////////////////////
#include <iostream>
using namespace std;
class A {
	
int x,y;

public: 

A():x(0),y(0){}
	
A& alter(void){
	
	if(x++&&y++){
		y+=2;
		cout<<"HERE";
	}
	cout<<x<<y;
	return *this;
}
	int sum(void){
		return x+y;
	}
};


int main() {
A a;
cout<<a.alter().sum()<<endl;
	return 0;
}
//RESULTS 1

////////////////////////2/////////////////////////////////////////////////////////////////////

#include <iostream>
using namespace std;
class A {
	
int x;

public: 

A(int b =0):x(b){}
	
operator int(){
	return 6^8%3; // it returns 0b00000110 ^ 0b00000010 = 0b00000100; => 0x04
}

A& operator =(const int b){
	a=b; return(*this);
}
	
};

int main() {
	A a;
	cout<<(3+(a=11))<<endl;
	return 0;
}

//RESULTS: 7



//////////////////////////////////////////3////////////////////////////////////////////////////////////////////
#include <iostream>
#include <memory>
using namespace std;

const int SIZE =5;

struct myStruct{
	
	void display(){
		cout<<SIZE<<endl;
	}	
	enum {
		SIZE=3
	};
};

int main(){
	
	auto_ptr<myStruct> spData(new myStruct);
	spData->display();
	return 0;
}
//RESULTS: 3
//////////////////////////////////////////4////////////////////////////////////////////////////////////////////
#include <iostream>
#include <memory>
#include <string>
using namespace std;

template<typename T> inline T power(T x, unsigned int a){
     T result;
     for(unsigned int idx=0;idx<a;idx++){
     	result+=x;
     }
		return result;
	}
int main(){
	
	cout<<power<int>(4,4)<<" "<<power<string>("ab",3)<<endl;
	return 0;
}

//RESULTS: 16ababab

//////////////////////////////////////////5////////////////////////////////////////////////////////////////////
#include <iostream>
#include <string>
using namespace std;

unsigned short vec[3][3]={0,1,2,4,5,6,7,8,9};
unsigned short *pc= vec[0];


int main(){
	
	int res = ++*(2+pc++);
	cout<<res;
}
//RESULTS: 3

//////////////////////////////////////////6////////////////////////////////////////////////////////////////////
#include <iostream>
#include <memory>
#include <string>
using namespace std;

template<typename T> class A{	
    public: 
        void setP();
        static T i;

    private: 
        static T p;
};

template<typename T> void A<T>::setP(){
	
	cout<<p++;
	
};
template<typename T> T A<T>::i=1;
template<typename T> T A<T>::p=1.2;

int main(){
	A<int> aaa;
	A<float> bbb;
	
	aaa.setP();
	cout<<aaa.i;
	bbb.setP();
	return 0;
}
//RESULTS: 111.2
//////////////////////////////////////////7////////////////////////////////////////////////////////////////////

#include <iostream>
#include <memory>
#include <string>
using namespace std;

const int x= 5;


int main(){
	
	int x[x];
	int y =sizeof(x)/sizeof(int);
	cout<<y;
	return 0;
}

//RESULTS: 5
//////////////////////////////////////////8////////////////////////////////////////////////////////////////////

#include <iostream>
#include <memory>
#include <string>
using namespace std;

namespace specific{
	
	int a= 4;
	void add(void){a++;}
}

void add(void){
	
	using namespace specific;
	a++;
}

int a =5;

int main(){
	
	add();
	std::cout<<a<<std::endl;
	return 0;
}

//RESULTS: 5
//////////////////////////////////////////9////////////////////////////////////////////////////
#include <iostream>
#include <memory>
#include <string>
using namespace std;

void func(const char* s)try
{
	
	int y =2;
	throw 1;
}
catch(int e){
	cout<<"CAUGHT"	;
	cout<<s<<" "<<e<<endl;
}



int main(){
	
	func("test");
	return 0;
}
//RESULTS: "CAUGHT \n test 1
//////////////////////////////////////////10////////////////////////////////////////////////////