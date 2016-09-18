#include <stdio.h>
    int main()
    {
        int a[5] = {1, 2, 3, 4, 5};
        int i;
        for (i = 0; i < 5; i++)
            if ((char)a[i] == '5')
                printf("%d\n", a[i]);
            else
                printf("FAIL\n");
            	printf("CHAR: %d , %c\n",(char)a[i],(char)a[i]);   
                return 0;
    }
//### OUTPUT: prints five times FAIL
    
//#############################################################################################
    #include  <stdio.h>
    int main()
    {
       signed char chr;
       chr = 128;
       printf("%d\n", chr);
       return 0;
    }
 //### OUTPUT: -128
    
//#############################################################################################  
    #include  <stdio.h>
    int main()
    {
        char c;
        int i = 0;
        FILE *file;
        file = fopen("test.txt", "w+");
        fprintf(file, "%c", 'a');
        fprintf(file, "%c", -1);
        fprintf(file, "%c", 'b');
        fclose(file);
        file = fopen("test.txt", "r");
        while ((c = fgetc(file)) !=  -1)
            printf("%c", c);
        return 0;
    }
    
 //### OUTPUT:  a
//#############################################################################################   
    #include <stdio.h>
    #define a 10
    int main()
    {
        const int a = 5;
        printf("a = %d\n", a);
    }
//### OUTPUT:   Compilation error
//#############################################################################################
   
      #include <stdio.h>
    int main()
    {
        int var = 010;
        printf("%d", var);
    }  
    
    
    
//### OUTPUT:  8 - octal representation
//#############################################################################################

      #include <stdio.h>
    #include <string.h>
    int main()
    {
        char *str = "x";
        char c = 'x';
        char ary[1];
        ary[0] = c;
        printf("%d %d", strlen(str), strlen(ary));
        return 0;
    }  
    
        
//### OUTPUT:  1 (undefined value)
//#############################################################################################
    #include <stdio.h>
    int main()
    {
        float x = 0.1;
        if (x == 0.1)
            printf("RYCIE");
        else
            printf("PODRYWANKO");
    }
    
    
    //### OUTPUT:  PODRYWANKO
//############################################################################################
    #include <stdio.h>
    void main()
    {
        float x = 0.1;
        printf("%d, ", x);
        printf("%f", x);
    }
    
    
    //### OUTPUT:  Junk value, 0.100000
//#############################################################################################
    
    
    //### OUTPUT:  a
//#############################################################################################
    
    
    //### OUTPUT:  a
//#############################################################################################
    
    
    //### OUTPUT:  a
//#############################################################################################
    
    //### OUTPUT:  a
//#############################################################################################
    
///////////////////////////////////////////QUESTIONS///////////////////////////////////////////
    /*
        
       Using the variable a, write down definitions for the following:

(a) An integer
    int a;

(b) A pointer to an integer
    int *a;
(c) A pointer to a pointer to an integer
    int **a;
(d) An array of ten integers
    int a[];
(e) An array of ten pointers to integers
    int *a[10];
(f) A pointer to an array of ten integers
    int (*a)[10];
(g) A pointer to a function that takes an integer as an argument and returns an integer
    int (*a)(int a);
(h) An array of ten pointers to functions that take an integer argument and return an integer. 
    int (*a[10])(int a);       
        


Const
7. What does the keyword const mean?

As soon as the interviewee says ‘const means constant’, I know I’m dealing with an amateur. Dan Saks has exhaustively covered const in the last year, such that every reader of ESP should be extremely familiar with what const can and cannot do for you. If you haven’t been reading that column, suffice it to say that const means “read-only”.  Although this answer doesn’t really do the subject justice, I’d accept it as a correct answer. (If you want the detailed answer, then read Saks’ columns – carefully!).

If the candidate gets the answer correct, then I’ll ask him these supplemental questions:

What do the following incomplete[2] declarations mean?

const int a;

int const a;

const int *a;

int * const a;

int const * a const;

The first two mean the same thing, namely a is a const (read-only) integer.  The third means a is a pointer to a const integer (i.e., the integer isn’t modifiable, but the pointer is). The fourth declares a to be a const pointer to an integer (i.e., the integer pointed to by a is modifiable, but the pointer is not). The final declaration declares a to be a const pointer to a const integer (i.e., neither the integer pointed to by a, nor the pointer itself may be modified).

If the candidate correctly answers these questions, I’ll be impressed.

Incidentally, one might wonder why I put so much emphasis on const, since it is very easy to write a correctly functioning program without ever using it.  There are several reasons:

(a)    The use of const conveys some very useful information to someone reading your code. In effect, declaring a parameter const tells the user about its intended usage.  If you spend a lot of time cleaning up the mess left by other people, then you’ll quickly learn to appreciate this extra piece of information. (Of course, programmers that use const, rarely leave a mess for others to clean up…)

(b)    const has the potential for generating tighter code by giving the optimizer some additional information.

(c)    Code that uses const liberally is inherently protected by the compiler against inadvertent coding constructs that result in parameters being changed that should not be.  In short, they tend to have fewer bugs.

Volatile

8. What does the keyword volatile mean? Give three different examples of its use.

A volatile variable is one that can change unexpectedly.  Consequently, the compiler can make no assumptions about the value of the variable.  In particular, the optimizer must be careful to reload the variable every time it is used instead of holding a copy in a register.  Examples of volatile variables are:

(a)    Hardware registers in peripherals (e.g., status registers)

(b)    Non-stack variables referenced within an interrupt service routine.

(c)    Variables shared by multiple tasks in a multi-threaded application.

If a candidate does not know the answer to this question, they aren’t hired.  I consider this the most fundamental question that distinguishes between a ‘C programmer’ and an ‘embedded systems programmer’.  Embedded folks deal with hardware, interrupts, RTOSes, and the like. All of these require volatile variables. Failure to understand the concept of volatile will lead to disaster.

On the (dubious) assumption that the interviewee gets this question correct, I like to probe a little deeper, to see if they really understand the full significance of volatile. In particular, I’ll ask them the following:

(a) Can a parameter be both const and volatile? Explain your answer.

(b) Can a pointer be volatile? Explain your answer.

(c) What is wrong with the following function?:

int square(volatile int *ptr)

{

return *ptr * *ptr;

}

The answers are as follows:

(a)    Yes. An example is a read only status register. It is volatile because it can change unexpectedly. It is const because the program should not attempt to modify it.

(b)    Yes. Although this is not very common. An example is when an interrupt service routine modifies a pointer to a buffer.

(c)    This one is wicked.  The intent of the code is to return the square of the value pointed to by *ptr. However, since *ptr points to a volatile parameter, the compiler will generate code that looks something like this:

int square(volatile int *ptr)

{

int a,b;

a = *ptr;

b = *ptr;


return a * b;

}

Since it is possible for the value of *ptr to change unexpectedly, it is possible for a and b to be different. Consequently, this code could return a number that is not a square!  The correct way to code this is:

long square(volatile int *ptr)

{

int a;

a = *ptr;

return a * a;

}





*/
    
    uint8_t a ;
    a= ~(a&1<<3)