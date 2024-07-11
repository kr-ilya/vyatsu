#include "task.h"
#include <QMutexLocker>


Task::Task()
{
    for (int i = 0; i < NUM_PHILOSOPHERS; ++i) {
        int left_fork = i % NUM_PHILOSOPHERS;
        int right_fork = (i + 1) % NUM_PHILOSOPHERS;
        philosophers[i] = new Philosopher(i, NUM_PHILOSOPHERS, forks[left_fork], forks[right_fork]);
    }   
}

void Task::start() {
    int numThreads = QThread::idealThreadCount(); // Get the number of available hardware threads
    numThreads = qMin(numThreads, NUM_PHILOSOPHERS);
    pool.setMaxThreadCount(numThreads);

    for(int i = 0; i < NUM_PHILOSOPHERS; ++i) {
        philosopherThreads.append(QtConcurrent::run(&pool, [=](){
            philosophers[i]->run();
        }));
    }

    // for(int i = 0; i < NUM_PHILOSOPHERS; ++i) {
    //     philosopherThreads[i] = QtConcurrent::run([=](){
    //         philosophers[i]->run();
    //     });
    // }
}

void Task::stop() {
    for (int i = 0; i < NUM_PHILOSOPHERS; ++i) {
        philosophers[i]->stop();
    }   

    // for (const auto& future : philosopherThreads) {
    //     future.waitForFinished();
    // }

    for (int i = 0; i < NUM_PHILOSOPHERS; ++i) {
        if (philosopherThreads[i].isRunning()) {
            philosopherThreads[i].waitForFinished();
        }
    }
}

void Task::setGrabForkFn() {
    for (int i = 0; i < NUM_PHILOSOPHERS; ++i) {
        philosophers[i]->setGrabForkFn([this](int ph_id, int fork_id){
            emit grabForkSignal(ph_id, fork_id);
        });
    }   
}

void Task::setResetForkFn() {
for (int i = 0; i < NUM_PHILOSOPHERS; ++i) {
        philosophers[i]->setResetForkFn([this](int fork_id){
            emit resetForkSignal(fork_id);
        });
    }   
}

void Task::setChangePhLabelFn() {
for (int i = 0; i < NUM_PHILOSOPHERS; ++i) {
        philosophers[i]->setChangeLabelFn([this](int ph_id, std::string s){
            emit changePhLabelSignal(ph_id, s);
        });
    }   
}

void Task::setThinkingDuration(int ph_id, int delay) {
    philosophers[ph_id]->setThinkingDuration(delay);
}