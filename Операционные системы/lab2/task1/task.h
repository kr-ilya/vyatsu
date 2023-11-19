#include <string>
#include <fstream>
#include <vector>
#include <filesystem>
#include "dekkermutex.h"
#include <QtConcurrent>
#include <functional>

#ifndef TASK_H
#define TASK_H
class Task
{
private:
    DekkerMutex mutex;
    unsigned int timeout, timeout2;
    bool started;
    unsigned int currentNumber;
    unsigned int currentLineNumber;
    bool p2IsOver;
    unsigned int maxNumber;
    unsigned int stopLimitNum;
    std::vector<unsigned int> numbers;
    std::atomic_bool procDone[2];
    QFuture<void> t1;
    QFuture<void> t2;

    void onProcDone();
    std::function<void(uint, std::string)> logThread;
    std::function<void()> onThreadsStop;

 public:
    Task();

    void start();
    void stop();
    void proc1();
    void proc2();
    void setTimeout(unsigned int, unsigned int);
    void setLogThread(std::function<void(uint, std::string)>);
    void setStopThreadsCb(std::function<void()>);
    void reset();
};
#endif // TASK_H
