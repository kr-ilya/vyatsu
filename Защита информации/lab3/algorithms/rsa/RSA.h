#pragma once

#include <random>

typedef unsigned long long ULL; 

class RSA {
public:
    RSA();
    void generate_keys(ULL _p, ULL _q);
    static void encrypt(ULL *input, ULL len, ULL *output, ULL _e, ULL _n);
    static void decrypt(ULL *input, ULL len, ULL *output, ULL _d, ULL _n);
    void get_public_key(ULL &_e, ULL &_n) {_e=e,_n=n;}
	void get_private_key(ULL &_d, ULL &_p, ULL &_q) {_p=p,_q=q,_d=d;}

private:
    ULL p,q,phi,e,d,n;

    ULL randVal();
    ULL exgcd(ULL a, ULL b, ULL& x, ULL& y);
    std::mt19937 rnd;
    
};
