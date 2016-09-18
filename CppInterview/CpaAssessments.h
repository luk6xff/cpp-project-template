
/*****************************************************************************************
    
          ASSESSMENT NR 2    
    
******************************************************************************************/




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//1.What is the output of the following snippet?

    int i = 1, j = i++, k = --i;
    if(i > 0) {
        j++;
        k++;
    }
    else {
        k++;
        i++;
    }
    if(k == 0) {
        i++;
        j++;
    }
    else {
        if(k > 0)
            k--;
        else
            k++;
        i++;
    }
    cout << i * j * k;
    
 /*
 Select correct answer (single choice)
 0 
 2 
 8 
 4 
 */
 
 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//2.What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    int main() {
            int i = 3, j = 0;
            do {
                i--;
                j++;
            } while(i >= 0);
            cout << j;
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 3 
 4 
 5 
 2 
  */
 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//3. What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    int main() {
            for(float val = -10.0; val < 100.0; val = -val * 2)
                cout << "*";
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 ** 
 ***** 
 **** 
 *** 
  */
 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//4. What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    int main() {
            for(float val = -10.0; val < 100.0; val = -val * 2) {
                if(val < 0 && -val >= 40)
                    break;
                cout << "*";
            }
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 ***** 
 ** 
 **** 
 *** 
  */
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//5. What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    int main() {
            int a = 1, b = 2;
            int c = a | b;
            int d = c & a;
            int e = d ^ 0;
            cout << e << d << c;
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 131 
 100 
 031 
 113 
  */
 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//6. What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    int main() {
            int a = 1, b = 2;
            int c = a << b;
            int d = 1 << c;
            int e = d >> d;
            cout << e;
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 2 
 4 
 0 
 1 
  */
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//7. What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    int main() {
            int a = 2;
            switch(a << a) {
            case 8 : a++;
            case 4 : a++;
            case 2 : break;
            case 1 : a--;
            }
            cout << a;
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 5 
 3 
 4 
 2 
  */
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//8. What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    int main() {
            int g[3][3] = {{2, 4, 8}, {3, 6, 9}, {5, 10, 15}};
            for(int i = 2; i >= 0; i--)
                for(int j = 0; j < 3; j++)
                    g[i][j] += g[j][i];
            cout << g[1][1];
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 12 
 15 
 9 
 6 
  */
  
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//9. What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    
    struct str {
        int t[3];
        char s[3];
    };
    
    int main() {
            str z[3];
            for(int i = 0; i < 3; i++) 
                for(int j = 0; j < 3; j++) {
                    z[i].s[j] = '0' + i + j;
                    z[j].t[i] = i + j;
                }
            cout << z[0].s[1] << z[1].t[2] << z[2].s[0];
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 132 
 032 
 123 
 312 
  */
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//10. What is the output of the following snippet?

    #include <iostream>
    using namespace std;
    
    int main() {
            char arr[5] = { 'a', 'b', 'c', 'd', 'e' };
            for(int i = 1; i < 5; i++) {
                cout << "*";
                if((arr[i] - arr[i - 1]) % 2)
                    continue;
                cout << "*";
            }
            return 0;
    }
    
 
 /*
Select correct answer (single choice)
 **** 
 ***** 
 ******* 
 ******** 
 */
 
 
 
 
 
 
 
 
 /*****************************************************************************************
    
          ASSESSMENT NR 3    
    
******************************************************************************************/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//1. What is the output of the following snippet?
 
    #include <iostream>
    using namespace std;
    
    int main() {
        int t[3] = { 3, 2, 1 }, *ptr = t + 1;
        (*(ptr + 1))++;
        *ptr++;
        cout << t[1] << t[2];
        return 0;
    }
    
 /*
 33 
 23 
 22 
 32 
*/ 
 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//2. What is the output of the following snippet?
 
    #include <iostream>
    using namespace std;
    
    int main() {
        float x = 3.14, *p = &x;
        p[0] = ++x;
        cout << x;
        return 0;
    }
    
 /*
 4.14 
 6.28 
 3.14 
 0.0 
 */ 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//3. What is the output of the following snippet?
 
    #include <iostream>
    using namespace std;
    
    int main() {
        int tab[5] = { 1, 2, 4, 8, 16 };
        int *p1 = tab, *p2 = tab + 4;
        for(int *p = p1 + 1; p < p2; p++)
            *p = p[-1] * 2;
        cout << tab[1] << tab[2];
        return 0;
    }
    
 /*
 01 
 12 
 24 
 48 
 */ 
 
 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//4. What is the output of the following snippet?
 
    #include <iostream>
    using namespace std;
    
    int fun(float a, float b) {
        return a / b;
    }
    
    int main() {
        cout << fun(fun(1.0,2.0),fun(2.0,1.0));
        return 0;
    }
    
 /*
 2 
 1 
 -1 
 0 
*/ 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//5. What is the output of the following snippet?
 
    #include <iostream>
    using namespace std;
    
    int f1(int a) {
        return ++a;
    }
    
    int f2(int &a) {
        return ++a;
    }
    
    int f3(int *a) {
        return *a + 1;
    }
    
    int main() {
        int value = 2;
        cout << f1(value);
        cout << f2(value);
        cout << f3(&value);
        return 0;
    }
    
 /*
 456 
 445 
 333 
 334 
*/ 
 
 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//6. What is the output of the following snippet?
 
    #include <iostream>
    using namespace std;
    
    int f1(int *a) {
        return *a;
    }
    
    int *f2(int *a) {
        return a;
    }
    
    int *f3(int &a) {
        return &a;
    }
    
    int main() {
        int value = 2;
        cout << f1(f2(f3(value)));
        return 0;
    }
    
 
 
 /*
 3 
 0 
 1 
 2 
 */ 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//7. What is the output of the following snippet?
 
    #include <iostream>
    using namespace std;
    
    int fun(int p1 = 1, int p2 = 1) {
        return p2 << p1;
    }
    
    int main() {
        cout << fun(fun(),fun(2));
        return 0;
    }
    
 /*
 4 
 16 
 32 
 8 
 */ 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//8. What is the output of the following snippet?

 
    #include <iostream>
    #include <string>
    using namespace std;
    
    string fun(string &t, string s = "", int r = 2) {
        while(--r)
            s += s;
        t = t + s;
        return s;
    }
    
    int main() {
        string name = "x";
        cout << fun(name, name);
        cout << name;
        return 0;
    }
    
 
 /*
 xxxxx 
 xxx 
 xxxxxx 
 xxxx 
 */ 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//9. What is the output of the following snippet?

 
    #include <iostream>
    using namespace std;
    
    int fun(int a, int b) {
        return a + b;
    }
    
    int fun(int a, char b) {
        return b - a;
    }
    
    int fun(float a, float b) {
        return a * b;
    }
    
    int main() {
        cout << fun(1,0) << fun('a','c') << fun(2.f,2.f);
        return 0;
    }
    
 
 
 /*
 481 
 124 
 248 
 012 
 */ 
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//10. What is the output of the following snippet?
 
    #include <iostream>
    using namespace std;
    
    int fun(long a) {
        return a / a;
    }
    
    int fun(int a) {
        return 2 * a;
    }
    
    int fun(double a = 3.0) {
        return a;
    }
    
    int main() {
        cout << fun(1000000000L) << fun (1L) << fun(1.f);
        return 0;
    }
    
 /*
 333 
 222 
 444 
 111 
*/ 

 /*****************************************************************************************
    
          ASSESSMENT NR 5    
    
******************************************************************************************/

//1

    #include <iostream>
    using namespace std;
    
    class A {
        int cnt;
        void put(int v) { cout << cnt++; }
    };
    
    
    int main() {
        A a;
        a.cnt = 0;
        a.put(1);
        a.put(1);
        return 0;
    }
 /*
 It prints 2 
 It prints 0 
 Compilation fails 
 It prints 1 
*/
//2
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        int cnt;
        void put(int v);
    };
    
    void A::put(int v)  { cout << ++cnt; }
    
    int main() {
        A a[2];
        a[0].cnt = 0;
        a[1].cnt = 1;
        a[a[0].cnt].put(a[1].cnt);
        return 0;
    }
 

  /*Compilation fails 
 It prints 1 
 It prints 2 
 It prints 0 
*/
//3
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        float v;
        float set(float v) {
            v += 1.0;
            this -> v = v;
            return v;
        }
        float get(float d) {
            v += 1.0;
            return v;
        }
    };
    
    int main() {
        A a;
        cout << a.get(a.set(a.set(0.5)));
        return 0;
    }
 


 /* It prints 2.5 
 It prints 1.5 
 Compilation fails 
 It prints 3.5 
*/

//4
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        float v;
        float set(float v) {
            A::v += 1.0;
            A::v = v + 1.0;
            return v;
        }
        float get(float v) {
            v += A::v;
            return v;
        }
    };
    
    int main() {
        A a;
        cout << a.get(a.set(a.set(0.5)));
        return 0;
    }
 
 /* It prints 2.0 
 It prints 2.5 
 Compilation fails 
 It prints 1.5 
*/
//5
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        A() { v = 2.5; }
        float v;
        float set(float v) {
            A::v += 1.0;
            return v;
        }
        float get(float v) {
            v += A::v;
            return v;
        }
    };
    
    int main() {
        A a;
        a.A();
        cout << a.get(a.set(1.5));
        return 0;
    }
 
 /* It prints 5 
 Compilation fails 
 It prints 1 
 It prints 3 
*/
//6
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        A(A &a) { v = a.get(0.0); }
        A(float v) { A::v = v; }
        float v;
        float set(float v) {
            A::v += v;
            return v;
        }
        float get(float v) {
            return A::v + v;
        }
    };
    
    int main() {
        A a(0.), b = a;
        cout << a.get(b.set(1.5));
        return 0;
    }
 
  /*It prints 1.5 
 It prints 2.5 
 It prints 4.5 
 Compilation fails 
*/
//7
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        A(A &a) { v = a.get(0.0); }
        A(float v) { A::v = v; }
        float v;
        float set(float v) {
            A::v += v;
            return v;
        }
        float get(float v) {
            return A::v + v;
        }
    };
    
    int main() {
        A *a = new A(1.0), *b = new A(*a);
        cout << a->get(b->set(a->v));
        return 0;
    }
 

  /*Compilation fails 
 It prints 1 
 It prints 4 
 It prints 2 
*/
//8
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        float v;
        A() { v = 1.0; }
        A(A &a) { A::v = a.v; cout << "1"; }
        ~A() { cout << "0"; }
        float set(float v) {
            A::v = v;
            return v;
        }
        float get(float v) {
            return A::v;
        }
    };
    
    int main() {
        A a,*b = new A(a),*c = new A(*b);
        c->get(b->get(a.set(1.0)));
        delete b;
        delete c;
        return 0;
    }
 
 /* It prints 11000 
 It prints 110 
 Compilation fails 
 It prints 1100 
*/
//9
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        float v;
        A() { v = 1.0; }
        A(A &a) { A::v = a.v; cout << "1"; }
        ~A() { cout << "0"; }
        float set(float v) {
            A::v = v;
            return v;
        }
        float get(float v) {
            return A::v;
        }
    };
    
    int main() {
        A a, b = a;
        return 0;
    }
 


 /* It prints 11100 
 It prints 100 
 It prints 1100 
 Compilation fails 
*/
//10
    #include <iostream>
    using namespace std;
    
    class A {
    public:
        float v;
        A() : v(1.0) {}
        A(A &a) : v(2.0) {}
        A(float f) : v(3.0) {}
        float get() {
            return A::v;
        }
    };
    
    int main() {
        A a, b(a.get()), c(b);
        cout << a.v + b.v + c.v;
        return 0;
    }
 


  /*It prints 9 
 Compilation fails 
 It prints 6 
 It prints 3 
*/