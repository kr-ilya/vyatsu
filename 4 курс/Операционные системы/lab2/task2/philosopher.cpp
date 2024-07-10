#include "philosopher.h"
#include <QDebug>
#include <QThread>
#include <QMutexLocker>

const int eatingDuration = 3000;

Philosopher::Philosopher(int id, int nph, QMutex &lf, QMutex &rf) : id(id), num_philosophers(nph) {
    thinkingDuration = 5500;
    mxForks[id % num_philosophers] = &lf;
    mxForks[(id + 1) % num_philosophers] = &rf;
}

void Philosopher::eat() {
    int left_fork_id = id % num_philosophers;
    int right_fork_id = (id + 1) % num_philosophers;

    int first_fork = left_fork_id;
    int second_fork = right_fork_id;
    if (left_fork_id > right_fork_id) {
        first_fork = right_fork_id;
        second_fork = left_fork_id;
    }

    QMutexLocker left_lock(mxForks[first_fork]);
    grabFork(id, left_fork_id);

    QMutexLocker right_lock(mxForks[second_fork]);
    grabFork(id, right_fork_id);

    changeLabel(id, "Ем");
    qDebug() << "eating";
    QThread::msleep(eatingDuration);

    resetFork(left_fork_id);
    resetFork(right_fork_id);
    changeLabel(id, "Думаю");
}

void Philosopher::think() {
    changeLabel(id, "Думаю");
    qDebug() << "thinking";
    QThread::msleep(thinkingDuration);
}

void Philosopher::run() {
    started = true;
    while (started) {
        think();
        if(started) {
            eat();
        }
    }
}

void Philosopher::stop() {
    started = false;
}

void Philosopher::setGrabForkFn(std::function<void(int, int)> func) {
    grabFork = func;
}

void Philosopher::setResetForkFn(std::function<void(int)> func) {
    resetFork = func;
}

void Philosopher::setChangeLabelFn(std::function<void(int, std::string)> func) {
    changeLabel = func;
}

void Philosopher::setThinkingDuration(int d) {
    thinkingDuration = d;
}
