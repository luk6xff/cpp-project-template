 #include <stdio.h>
    void foo(const int *);
    int main()
    {
        const int i = 10;
        printf("%d ", i);
        foo(&i);
        printf("%d", i);
 
    }
    void foo(const int *i)
    {
        *i = 20;
    }
    
//### OUTPUT: compile time error -> cannot change const value : )
//#############################################################################################
    
    #include <stdio.h>
    int main()
    {
        const int i = 10;
        int *ptr = &i;
        *ptr = 20;
        printf("%d\n", i);
        return 0;
    }
 //### OUTPUT: Compile time warning and printf displays 20
//#############################################################################################  
     #include <stdio.h>
    int main()
    {
        j = 10;
        printf("%d\n", j++);
        return 0;
    }
    
    
 //### OUTPUT:  Compile time error  -> j not defined , for int j =10 -> prints 10
//#############################################################################################   

    
    