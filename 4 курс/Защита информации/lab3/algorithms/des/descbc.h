#pragma once

#include "des.h"


class DESCBC {
public:
    DESCBC(uint64 key);
    uint64 encrypt(uint64 block);
    uint64 decrypt(uint64 block);
private:
    DES des;
    uint64 last_block;
};