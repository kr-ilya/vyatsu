#include "dekkermutex.h"
#include <atomic>

DekkerMutex::DekkerMutex()
{
    flag[0] = flag[1] = false;
    turn = 0;
}

void DekkerMutex::lock(unsigned int id)
{
    flag[id] = true;
    unsigned int other = id ^ 1;

    while (flag[other].load())
    {
        if (turn.load() == other)
        {
            flag[id] = false;
            while (turn.load() == other)
            {
            }
            flag[id] = true;
        }
    }
}

void DekkerMutex::unlock(unsigned int id)
{
    turn = id ^ 1;
    flag[id] = false;
}
