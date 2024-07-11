#include <iostream>
#include <thread>
#include <mutex>
#include <ctime>
#include <windows.h>

int iterNum = 10;
std::mutex mx_io;
int count = 0;

HANDLE hmx = CreateMutex(NULL, false, NULL);


bool ready = true;
struct mTime {
    int h;
    int m;
    int s;
    int ms;
};

mTime getTime(){
    mTime nt;
    SYSTEMTIME st;

    GetLocalTime(&st);

    nt.h = st.wHour;
    nt.m = st.wMinute;
    nt.s = st.wSecond;
    nt.ms = st.wMilliseconds;
    return nt;
}

void writer(){
    WaitForSingleObject(hmx, 0);

    mTime ct = getTime();            
    {
        std::lock_guard<std::mutex> io_lock(mx_io);
        std::cout << ct.h << ":" << ct.m << ":" << ct.s << ":" << ct.ms  << " WRITE" << std::endl;
    }

    std::this_thread::sleep_for(std::chrono::seconds(1));

    ReleaseMutex(hmx);
}

void reader(int id){
    WaitForSingleObject(hmx, 0);
    ReleaseMutex(hmx);

    mTime ct = getTime();

    {
        std::lock_guard<std::mutex> io_lock(mx_io);
        std::cout << ct.h << ":" << ct.m << ":" << ct.s << ":" << ct.ms  << " READ (" << id << ")" << std::endl;
    }

    std::this_thread::sleep_for(std::chrono::seconds(1));
}


void run(int id, int dl){
    for(int i = 0; i < iterNum; i++){
        
        reader(id);
        std::this_thread::sleep_for(std::chrono::seconds(dl));
    }
}

void runWriter(){
    for(int i = 0; i < iterNum; i++){
        
        writer();
        std::this_thread::sleep_for(std::chrono::seconds(3));
    }
}

int main(){

    auto start_time = std::chrono::steady_clock::now();

    mTime ct = getTime();
    std::cout << ct.h << ":" << ct.m << ":" << ct.s << ":" << ct.ms  <<" START" << std::endl;  

    std::thread run1(run, 1, 1);
    std::thread run2(run, 2, 1);
    std::thread run4(run, 3, 1);
    std::thread run3(runWriter);
    std::thread run5(runWriter);

    run1.join();
    run2.join();
    run3.join();
    run4.join();
    run5.join();

    auto end_time = std::chrono::steady_clock::now();
    auto elapsed_ns = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);
    std::cout << "COMPLEATE " <<  elapsed_ns.count() << " ms\n";

    
    return 1;
}