#include "pvm3.h"
#include <iostream>
#include <fstream>
#include <cstring>
#include <chrono>

#define NUM_PROCS 7

int** newMatrix(int64_t n) {
    int* data = new int [n*n];
    int** arr = new int* [n];

    for (int64_t i = 0; i < n; ++i) {
        arr[i] = &(data[n*i]);
    }

    return arr;
}

void deleteMatrix(int** m) {
    delete[] m[0];
    delete[] m;
}

void read_matrix(std::ifstream &in, int** m, int64_t n, int64_t real_n) {
    for (int64_t i = 0; i < real_n; ++i) {
        memset(m[i], 0, n * sizeof *m[i]);
        for (int64_t j = 0; j < real_n; ++j) {
            in >> m[i][j];
        }
    }
}

int64_t new_size(int64_t n) {
    int64_t r = 1;
    while((n >>= 1) != 0) {
        r++;
    }
    return 1 << r;
}

bool isPowerOfTwo(int64_t v) {
    return v && !(v & (v - 1));
}

int main(int argc, char** argv) {
    
    if (argc < 3) {
        std::cout << "Run program with args: input.txt output.txt" << std::endl;
        return 1;
    }


    int n = 0;
    int real_n = 0;

    std::ifstream in;
    in.open(argv[1]);

    if (!in.is_open()) {
        std::cout << "matrix.txt open error";
        return 1;
    }

    in >> real_n;
    n = real_n;

    if (!isPowerOfTwo(real_n) || real_n == 1) {
        n = new_size(real_n);
    }

    int** a = newMatrix(n);
    int** b = newMatrix(n);

    read_matrix(in, a, n, real_n);
    read_matrix(in, b, n, real_n);

    in.close();

    int tIds[NUM_PROCS];
    
    pvm_spawn("slave", (char**)0, PvmTaskDefault, "", NUM_PROCS, tIds);

    // #0
    for (int i = 0; i < NUM_PROCS; ++i) {
        pvm_initsend(PvmDataDefault);
		pvm_pkint(&i, 1, 1);
		pvm_send(tIds[i], 0);
    }
    

    std::chrono::steady_clock::time_point begin;
    std::chrono::steady_clock::time_point end;
    int64_t elapsed_ms;
    
    int** result = newMatrix(n);
    begin = std::chrono::steady_clock::now();
    
    // #1 send n
    pvm_initsend(PvmDataDefault);
    pvm_pkint(&(n), 1, 1);
    pvm_mcast(tIds, NUM_PROCS, 1);

    // #2 send a
    pvm_initsend(PvmDataDefault);
    pvm_pkint(&(a[0][0]), n*n, 1);
    pvm_mcast(tIds, NUM_PROCS, 2);

    // #3 send b
    pvm_initsend(PvmDataDefault);
    pvm_pkint(&(b[0][0]), n*n, 1);
    pvm_mcast(tIds, NUM_PROCS, 3);

    // #18 send tId
    pvm_initsend(PvmDataDefault);
    pvm_pkint(&(tIds[0]), NUM_PROCS, 1);
    pvm_mcast(tIds, NUM_PROCS, 18);

    pvm_recv(tIds[0], 17);
    pvm_upkint(result[0], n*n, 1);    

    end = std::chrono::steady_clock::now();
    elapsed_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count();


    std::ofstream out(argv[2]);
    if (!out.is_open()) {
        std::cout << "Result file open error";
        return 1;
    }


    for (int64_t i = 0; i < real_n; ++i) {
        for (int64_t j = 0; j < real_n; ++j) {
            out << result[i][j] << " ";
        }
        out << std::endl;
    }

    deleteMatrix(a);
    deleteMatrix(b);
    deleteMatrix(result);

    out.close();

    std::cout << "Ok " << std::endl;
    std::cout << "Time (s): " << (double) elapsed_ms/1000 << std::endl;

    pvm_exit();

    return 0;
}