#pragma once

#define uint64 unsigned long long
#define uint32 unsigned int
#define uint8 unsigned char

class DES {
public:
    DES(uint64 key);
    uint64 encrypt(uint64 block);
    uint64 decrypt(uint64 block);

private:
    uint64 des(uint64 block, bool mode);
    void keygen(uint64 key);
    uint64 ip(uint64 block);
    uint64 fp(uint64 block);

    void feistel(uint32 &L, uint32 &R, uint32 F);
    uint32 f(uint32 R, uint64 k);
    uint64 mkey[16];
};