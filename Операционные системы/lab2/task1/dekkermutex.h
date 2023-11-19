#ifndef DEKKERMUTEX_H
#define DEKKERMUTEX_H

#include <atomic>
class DekkerMutex
{
private:
    std::atomic_bool flag[2];
    std::atomic_uint turn;

public:
    DekkerMutex();

    void lock(unsigned int id);

    void unlock(unsigned int id);

};
#endif // DEKKERMUTEX_H
