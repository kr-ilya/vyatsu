#include "task.h"
#include "dekkermutex.h"
#include <string>
#include <fstream>
#include <vector>
#include <filesystem>
#include <QDebug>


std::string path("output.txt");

Task::Task()
{
    DekkerMutex mutex;
    timeout = 3300;
    timeout2 = 3300;
    started = false;
    currentNumber = 0;
    currentLineNumber = 0;
    p2IsOver = false;
    stopLimitNum = 10000;
    maxNumber = 100;
    std::vector<unsigned int> numbers;
    procDone[0] = procDone[1] = false;

    std::ofstream ofs;
    ofs.open(path, std::ofstream::out | std::ofstream::trunc);
    ofs.close();
}

void Task::setLogThread(std::function<void(uint, std::string)> func)
{
    logThread = func;
}

void Task::setStopThreadsCb(std::function<void()> func) {
    onThreadsStop = func;
}

void Task::onProcDone()
{
    if(procDone[0] && procDone[1]) {
        onThreadsStop();
    }
}

void Task::proc1()
{
    while (started && currentNumber <= stopLimitNum)
    {
        if (currentNumber >= maxNumber) {
            currentNumber = 0;
        }
        std::string str = std::to_string(currentNumber);
        mutex.lock(0);

        std::ofstream out(path, std::ios_base::out | std::ios_base::app);
        out << str << std::endl;
        logThread(1, "Записано: " + str);
        out.flush();
        out.close();

        mutex.unlock(0);

        currentNumber += 2;
        stopLimitNum += 2;
        QThread::msleep(timeout);
    }

    if (started) {
        procDone[0] = true;
        onProcDone();
        logThread(1, "Поток завершен");
    }
}

void Task::proc2()
{
    std::fstream file;
    std::string line;
    uint num;
    while (started && !p2IsOver)
    {
        mutex.lock(1);

        file.open(path, std::ios::in);
        if (!file.is_open()){
            qDebug() << QString("File not found");
            mutex.unlock(1);
            return;
        }

        while(std::getline(file, line))
        {
            if (line != "") {
                try {
                    num = std::stoi(line);
                    numbers.push_back(num);
                } catch(...) {
                      qDebug() << QString("convertation error");
                      mutex.unlock(1);
                      break;
                }
            }
        }

        file.close();
        file.open(path, std::ios::out | std::ios::trunc);
        // флаг, для работы с первым новым (рнаее не прочитынным) числом
        bool rFlag = false;
        unsigned int ln = 0;
        for(const auto &n : numbers) {
            if ((ln < currentLineNumber || rFlag)) {
                file << std::to_string(n) << std::endl;
            } else {
                if ((n % 3 == 0 || n % 4 == 0)) {
                    file << std::to_string(n) << std::endl;
                    logThread(2, "Прочитано:  " + std::to_string(n));
                    currentLineNumber++;
                } else {
                    logThread(2, "Удалено:  " + std::to_string(n));
                }
                rFlag = true;

                if (n == maxNumber) {
                    p2IsOver = true;
                }
            }
            ln++;
        }
        numbers.clear();

        file.flush();
        file.close();
        mutex.unlock(1);
        QThread::msleep(timeout2);
    }

    if(started) {
        procDone[1] = true;
        onProcDone();
        logThread(2, "Поток завершен");
    }

}

void Task::start()
{
    started = true;
    t1 = QtConcurrent::run([this](){
        proc1();
    });

    t2 = QtConcurrent::run([this](){
        proc2();
    });
}

void Task::stop()
{
    started = false;
    if (t1.isRunning()) {
        t1.waitForFinished();
    }
    if (t2.isRunning()) {
        t2.waitForFinished();
    }
}

void Task::setTimeout(unsigned int pid, unsigned int tm)
{
    switch (pid){
    case 1:
        timeout = tm;
        break;
    case 2:
        timeout2 = tm;
        break;
    }
}

void Task::reset()
{
    currentNumber = 0;
    // clear file
    std::ofstream file;
    file.open(path, std::ofstream::out | std::ofstream::trunc);
    file.close();
}
