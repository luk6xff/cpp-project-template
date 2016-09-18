#include <bits/stdc++.h>
using namespace std;

static vector<int> sieveOfEratosthenes(int n){
	
	bool tab[n];
	vector<int> res;
	memset(tab,true,sizeof(tab));
	
	for(int i =2;i<=sqrt(n);i++){   //sqrt(n) cuz of in the next for loop we start from x= i*i
		
		if(tab[i]==true)
			for(int x= i*i; x<=n;x+=i){
				tab[x]=false;
			}
	}
	for(auto i=2;i<=n;i++){
		if(tab[i]){
			cout<<i<<" ";
			res.push_back(i);
		}		
	}
	return res;
}




 
/* 
 * Sieve of Atkins
 */
 
void sieveOfAtkins(long long n)
{
    vector<bool> isPrime(n + 1);
    isPrime[2] = true;
    isPrime[3] = true;
    for (long long i = 5; i <= n; i++)
    {
        isPrime[i] = false;
    }
    long long lim = ceil(sqrt(n));
    for (long long x = 1; x <= lim; x++)
    {
        for (long long y = 1; y <= lim; y++)
        {
            long long num = (4 * x * x + y * y);
            if (num <= n && (num % 12 == 1 || num % 12 == 5))
            {
                isPrime[num] = true;
            }
            num = (3 * x * x + y * y);
            if (num <= n && (num % 12 == 7))
            {
                isPrime[num] = true;
            }
 
            if (x > y)
            {
                num = (3 * x * x - y * y);
                if (num <= n && (num % 12 == 11))
                {
                    isPrime[num] = true;
                }
            }
        }
    }
    for (long long i = 5; i <= lim; i++)
    {
        if (isPrime[i])
        {
            for (long long j = i * i; j <= n; j += i)
            {
                isPrime[j] = false;
            }
        }
    }
 
    for (long long i = 2; i <= n; i++)
    {
         if (isPrime[i])
         {
             cout<<i<<"\t";
         }
    }
}

/////////////////////////////////////////////////////////////////////
static inline bool isPrime(int num)  // function that checks if given number is prime
{
   
   double sqrtOfNum=sqrt(num); 
   int i =2;
   bool res= true;
   if(num==0||num==1||num==4)
      res= false;
   else{
       while(i<=sqrtOfNum)
       {
          if(num%i==0)
            res= false;
            i++;
       }
    }
   return res;   
}

int main() {
	sieveOfEratosthenes(1000000);
	sieveOfAtkins(100000);
	cout<<endl<<endl<<endl;
	return 0;
}