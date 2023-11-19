#ifndef TASK_H
#define TASK_H
#include <QMutex>
#include <QtConcurrent>
#include "philosopher.h"
#include <QObject>

const int NUM_PHILOSOPHERS = 5;

class Task : public QObject
{
    Q_OBJECT
public:
    Task();
    void start();
    void stop();
    void setGrabForkFn();
    void setResetForkFn();
    void setChangePhLabelFn();
    void setThinkingDuration(int, int);


signals:
    void grabForkSignal(int, int);
    void resetForkSignal(int);
    void changePhLabelSignal(int, std::string);

private:
    QMutex forks[NUM_PHILOSOPHERS];
    Philosopher* philosophers[NUM_PHILOSOPHERS];
    // QFuture<void> philosopherThreads[NUM_PHILOSOPHERS];
    QThreadPool pool;
    QList<QFuture<void>> philosopherThreads;
};

#endif // TASK_H
