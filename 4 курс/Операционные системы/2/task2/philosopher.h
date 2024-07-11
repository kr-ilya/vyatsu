#ifndef PHILOSOPHER_H
#define PHILOSOPHER_H

#include <QMutex>
#include <functional>
#include <string>
#include <unordered_map>

class Philosopher
{
public:
    Philosopher(int id, int num_philosophers, QMutex&, QMutex&);
    void run();
    void stop();
    void setGrabForkFn(std::function<void(int, int)>);
    void setResetForkFn(std::function<void(int)>);
    void setChangeLabelFn(std::function<void(int, std::string)>);
    void setThinkingDuration(int);

private:
    int id;
    int num_philosophers;
    std::unordered_map<int, QMutex*> mxForks;
    // QMutex& left _fork;
    // QMutex& right_fork;
    void eat();
    void think();
    int thinkingDuration;
    bool started;
    std::function<void(int, int)> grabFork;
    std::function<void(int)> resetFork;
    std::function<void(int, std::string)> changeLabel;
};

#endif // PHILOSOPHER_H
