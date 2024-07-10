#include <iostream>
#include <fstream>
#include <vector>
#include <chrono>

typedef std::vector<std::vector<int>> matrix;

void read_matrix(std::ifstream &in, matrix &m, int64_t n) {
    for (int64_t i = 0; i < n; ++i) {
        for (int64_t j = 0; j < n; ++j) {
            in >> m[i][j];
        }
    }
}

void printM(matrix &m) {
    int64_t n = m.size();
    for (int i = 0; i < n; ++i) {
        for(int j = 0; j < n; ++j) {
            std::cout << m[i][j] << " ";
        }
        std::cout << std::endl;
    }
}

void matrix_multiply(matrix &a, matrix &b, matrix &c, int64_t n) {
    int i, j, k;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            c[i][j] = 0;
            for (k = 0; k < n; k++)
                c[i][j] += a[i][k] * b[k][j];
        }
    }
}

int main() {
    int64_t n;
    std::ifstream in("matrix.txt");

    if (!in.is_open()) {
        std::cout << "matrix.txt open error";
        return 1;
    }

    in >> n;
    
    matrix a(n, std::vector<int>(n, 0));
    matrix b(n, std::vector<int>(n, 0));
    matrix result(n, std::vector<int>(n));

    read_matrix(in, a, n);
    read_matrix(in, b, n);

    in.close();

    auto begin = std::chrono::steady_clock::now();

    matrix_multiply(a, b, result, n);

    auto end = std::chrono::steady_clock::now();
    auto elapsed_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count();


    std::ofstream out("result.txt");
    if (!out.is_open()) {
        std::cout << "Result file open error";
        return 1;
    }


    for (int64_t i = 0; i < n; ++i) {
        for (int64_t j = 0; j < n; ++j) {
            out << result[i][j] << " ";
        }
        out << std::endl;
    }


    out.close();
    std::cout << "Ok" << std::endl;
    std::cout << "Time (s): " << (double) elapsed_ms/1000;

    return 0;
}