#include "descbc.h"

DESCBC::DESCBC(uint64 key): des(key) {
    last_block = (uint64) 0x0000000000000000;
}

uint64 DESCBC::encrypt(uint64 block) {
    last_block = des.encrypt(block ^ last_block);
    return last_block;
}

uint64 DESCBC::decrypt(uint64 block) {
    uint64 result = des.decrypt(block) ^ last_block;
    last_block = block;
    return result;
}