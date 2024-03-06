#include "des.h"
#include "key_data.h"
#include "des_data.h"

DES::DES(uint64 key){
    keygen(key);
}

void DES::keygen(uint64 key) {
    uint64 ik = 0; // 56 bits
    for (uint8 i = 0; i < 56; i++)
    {
        ik <<= 1;
        ik |= (key >> (64-key_table1[i])) & LB64_MASK;
    }

    // 28 bits
    uint32 C = (uint32) ((ik >> 28) & 0x000000000fffffff);
    uint32 D = (uint32)  (ik & 0x000000000fffffff);

    // Calculation of the 16 keys
    for (uint8 i = 0; i < 16; i++)
    {
        // key schedule, shifting Ci and Di
        for (uint8 j = 0; j < shift_table[i]; j++)
        {
            C = (0x0fffffff & (C << 1)) | (0x00000001 & (C >> 27));
            D = (0x0fffffff & (D << 1)) | (0x00000001 & (D >> 27));
        }

        uint64 ik2 = (((uint64) C) << 28) | (uint64) D;

        mkey[i] = 0; // 48 bits (2*24)
        for (uint8 j = 0; j < 48; j++)
        {
            mkey[i] <<= 1;
            mkey[i] |= (ik2 >> (56-key_table2[j])) & LB64_MASK;
        }
    }
}

uint64 DES::encrypt(uint64 block) {
    return des(block, true);
}

uint64 DES::decrypt(uint64 block) {
    return des(block, false);
}


uint64 DES::des(uint64 block, bool mode) {
    // applying initial permutation
    block = ip(block);

    // dividing T' into two 32-bit parts
    uint32 L = (uint32) (block >> 32) & L64_MASK;
    uint32 R = (uint32) (block & L64_MASK);

    // 16 rounds
    for (uint8 i = 0; i < 16; i++)
    {
        uint32 F = mode ? f(R, mkey[i]) : f(R, mkey[15-i]);
        feistel(L, R, F);
    }

    // swapping the two parts
    block = (((uint64) R) << 32) | (uint64) L;
    // applying final permutation
    return fp(block);
}

uint64 DES::ip(uint64 block) {
    // initial permutation
    uint64 result = 0;
    for (uint8 i = 0; i < 64; i++)
    {
        result <<= 1;
        result |= (block >> (64-IP[i])) & LB64_MASK;
    }
    return result;
}

uint64 DES::fp(uint64 block) {
    // inverse initial permutation
    uint64 result = 0;
    for (uint8 i = 0; i < 64; i++)
    {
        result <<= 1;
        result |= (block >> (64-FP[i])) & LB64_MASK;
    }
    return result;
}

void DES::feistel(uint32 &L, uint32 &R, uint32 F) {
    uint32 temp = R;
    R = L ^ F;
    L = temp;
}

uint32 DES::f(uint32 R, uint64 k) { // f(R,k) function 
    // applying expansion permutation and returning 48-bit data
    uint64 s_input = 0;
    for (uint8 i = 0; i < 48; i++)
    {
        s_input <<= 1;
        s_input |= (uint64) ((R >> (32-expansion[i])) & LB32_MASK);
    }

    // XORing expanded Ri with Ki, the round key
    s_input = s_input ^ k;

    // applying S-Boxes function and returning 32-bit data
    uint32 s_output = 0;
    for (uint8 i = 0; i < 8; i++)
    {
        // Outer bits
        char row = (char) ((s_input & (0x0000840000000000 >> 6*i)) >> (42-6*i));
        row = (row >> 4) | (row & 0x01);

        // Middle 4 bits of input
        char column = (char) ((s_input & (0x0000780000000000 >> 6*i)) >> (43-6*i));

        s_output <<= 4;
        s_output |= (uint32) (sbox[i][16*row + column] & 0x0f);
    }

    // applying the round permutation
    uint32 f_result = 0;
    for (uint8 i = 0; i < 32; i++)
    {
        f_result <<= 1;
        f_result |= (s_output >> (32 - pbox[i])) & LB32_MASK;
    }

    return f_result;
}
