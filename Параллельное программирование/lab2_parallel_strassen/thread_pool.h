#pragma once

#include <atomic>             
#include <condition_variable> 
#include <exception>          
#include <functional>         
#include <future>             
#include <memory>             
#include <mutex>              
#include <queue>              
#include <thread>             
#include <type_traits>        
#include <utility>            

namespace Lab {

using concurrency_t = std::invoke_result_t<decltype(std::thread::hardware_concurrency)>;

class thread_pool {
public:

    thread_pool(const concurrency_t thread_count_ = 0) : thread_count(determine_thread_count(thread_count_)), threads(std::make_unique<std::thread[]>(determine_thread_count(thread_count_))) {
        create_threads();
    }

    ~thread_pool() {
        wait_for_tasks();
        destroy_threads();
    }

    template <typename F, typename... A>
    void push_task(F&& task, A&&... args) {
        std::function<void()> task_function = std::bind(std::forward<F>(task), std::forward<A>(args)...);

        const std::scoped_lock tasks_lock(tasks_mutex);
        tasks.push(task_function);
        
        ++tasks_total;
        task_available_cv.notify_one();
    }

    template <typename F, typename... A, typename R = std::invoke_result_t<std::decay_t<F>, std::decay_t<A>...>>
    std::future<R> submit(F&& task, A&&... args) {
        std::function<R()> task_function = std::bind(std::forward<F>(task), std::forward<A>(args)...);
        std::shared_ptr<std::promise<R>> task_promise = std::make_shared<std::promise<R>>();
        push_task(
            [task_function, task_promise] {
                try {
                    if constexpr (std::is_void_v<R>) {
                        std::invoke(task_function);
                        task_promise->set_value();
                    }
                    else {
                        task_promise->set_value(std::invoke(task_function));
                    }
                }
                catch (...) {
                    try {
                        task_promise->set_exception(std::current_exception());
                    }
                    catch (...)
                    {
                    }
                }
            });
        return task_promise->get_future();
    }

    void wait_for_tasks() {
        waiting = true;
        std::unique_lock<std::mutex> tasks_lock(tasks_mutex);
        task_done_cv.wait(tasks_lock, [this] { return (tasks_total == 0); });
        waiting = false;
    }

private:

    void create_threads() {
        running = true;
        for (concurrency_t i = 0; i < thread_count; ++i) {
            threads[i] = std::thread(&thread_pool::worker, this);
        }
    }

    void destroy_threads() {
        running = false;
        task_available_cv.notify_all();
        for (concurrency_t i = 0; i < thread_count; ++i) {
            threads[i].join();
        }
    }

    [[nodiscard]] concurrency_t determine_thread_count(const concurrency_t thread_count_) {
        if (thread_count_ > 0) {
            return thread_count_;
        } else {
            if (std::thread::hardware_concurrency() > 0)
                return std::thread::hardware_concurrency();
            else
                return 1;
        }
    }

    void worker() {
        while (running) {
            std::function<void()> task;
            std::unique_lock<std::mutex> tasks_lock(tasks_mutex);
            task_available_cv.wait(tasks_lock, [this] { return !tasks.empty() || !running; });
            if (running) {
                task = std::move(tasks.front());
                tasks.pop();
                tasks_lock.unlock();
                task();
                tasks_lock.lock();
                --tasks_total;
                if (waiting)
                    task_done_cv.notify_one();
            }
        }
    }

    std::atomic<bool> running = false;

    std::condition_variable task_available_cv = {};

    std::condition_variable task_done_cv = {};

    std::queue<std::function<void()>> tasks = {};

    std::atomic<size_t> tasks_total = 0;

    mutable std::mutex tasks_mutex = {};

    concurrency_t thread_count = 0;

    std::unique_ptr<std::thread[]> threads = nullptr;

    std::atomic<bool> waiting = false;
};

}
