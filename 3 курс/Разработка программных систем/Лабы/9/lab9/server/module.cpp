#include <Windows.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

std::vector<long long> factorize(long long n) {
    long long i = 2;

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