#include "RSA.h"
#include <random>
#include <ctime>
#include <assert.h>

RSA::RSA() {
//    rnd.seed(std::time(nullptr));
    rnd.seed(1234);
}

void RSA::generate_keys(ULL _p, ULL _q) {
    p = _p;
    q = _q;
    phi = (p-1)*(q-1);
    n = p*q;
    ULL y;
    while(true) {
        e = randVal()%(phi-3)+3;
        if (phi%e==0) continue;
        ULL gcd = exgcd(e,phi,d,y);
        if (gcd == 1ULL && d > 0 && d < n) break;
    }
}

ULL RSA::randVal() { 
    ULL ret=rnd();
    return (ret<<31)+rnd();
}

ULL RSA::exgcd(ULL a, ULL b, ULL& x, ULL& y) {
	if(b == 0) {
		x = 1;
		y = 0;
		return a;
	}
	ULL gcd = exgcd(b, a%b, x, y);
	ULL t = y;
	y = x-(a/b)*(y);
	x = t;
	return gcd;
}

ULL mod_pro(ULL x, ULL y, ULL n) { 
	ULL ret = 0,tmp = x % n; 
	while(y) { 
		if (y & 0x1)
			if((ret += tmp) > n) ret -= n; 
		if ((tmp<<=1)>n) tmp -= n; 
		y>>=1; 
	} 
	return ret; 
}

ULL mod(ULL a,ULL b,ULL c) { 
	ULL ret = 1; 
	while(b) { 
		if (b & 0x1) ret = mod_pro(ret,a,c); 
		a = mod_pro(a,a,c); 
		b >>= 1; 
	} 
	return ret; 
}

void RSA::encrypt(ULL *input, ULL len, ULL *output, ULL _e, ULL _n) {
    for (int i = 0; i < len; ++i) { 
		assert(input[i] < _n);
		output[i] = mod(input[i], _e, _n);
	}
}

void RSA::decrypt(ULL *input, ULL len, ULL *output, ULL _d, ULL _n) {
    for (int i=0; i<len; ++i) 
		output[i] = mod(input[i],_d,_n);
}
