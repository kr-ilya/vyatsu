#include <Windows.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <iostream>
#include <chrono>
#include <string>

std::vector<long long> factorize(long long n) {
    long long i = 2;


    auto begin = std::chrono::high_resolution_clock::now();

    std::vector<long long> res = {1};
    
    while (i * i  <= n) {
        while (n % i == 0) {
            res.push_back(i);
            n /= i;
        }
        ++i;
    }

    if (n > 1)
        res.push_back(n);
        
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<float> elt = end - begin;

    std::cout << "[C++]: " << std::to_string(elt.count()) << " sec" << std::endl;

    return res;
}

namespace py = pybind11;

PYBIND11_MODULE(fast_factorize, m) {
    m.def("factorize", &factorize, "Factorize function");

#ifdef VERSION_INFO
    m.attr("__version__") = VERSION_INFO;
#else
    m.attr("__version__") = "dev";
#endif
}