//The value of multiplier was captured by value when the lambda was defined. Thus, changing the value of
//multiplier later does not change the lambda, and it still multiplies by three. The transform() algorithm is called
//twice, so the effect is to multiply by 9, not 60.

#include <algorithm>
#include <iostream>
#include <iterator>
#include <vector>

class MyString: public std::string
{
    public:
        MyString():std::string{}
        {
            std::cout<<"MyString CTOR "<<*this<<std::endl;
        }

        MyString(const MyString& copy):std::string(copy)
        {
            std::cout<<"MyString COPY CTOR "<<*this<<std::endl;
        }

        MyString(MyString&& copy):std::string(std::move(copy))
        {
            std::cout<<"MyString MOVE CTOR "<<*this<<std::endl;
        }         
};

std::vector<MyString> readCopyData()
{
    std::cout<<"readCopyData "<<std::endl;
    std::vector<MyString> vec{};
    MyString line;
    while(std::getline(std::cin, line))
    {
        vec.push_back(line);
    }
    return vec;
}

std::vector<MyString> readMoveData()
{
    std::cout<<"readMoveData "<<std::endl;
    std::vector<MyString> vec(10);
    MyString line;
    while(std::getline(std::cin, line))
    {
        vec.push_back(std::move(line));
    }
    return vec;
}


int main()
{
    //readCopyData();
    readMoveData();
    return 0;
    
}