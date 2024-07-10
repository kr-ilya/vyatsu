//
// Generate N x N matrix (default num: 2)
// output:
// n
// A
// B
//


#include <iostream>
#include <fstream>
#include <random>

std::random_device rd;
std::mt19937 gen(rd());

int random(int low, int high) {
    std::uniform_int_distribution<> dist(low, high);
    return dist(gen);
}

int main() {
    const int MAX_VALUE = 1e2;
    const int NUM_MATRIX = 2;

    int64_t n;

    std::cout << "Enter matrix size" << std::endl;
    while (true) {
        std::cin >> n;

        if (n < 2) {
            std::cout << "Enter number > 2" << std::endl;
            continue;
        }

        break;
    }
    
    std::ofstream out("matrix.txt");
    if (!out.is_open()) {
        std::cout << "File open error";
        return 1;
    }

    out << n << std::endl;


    for (int k = 0; k < NUM_MATRIX; ++k) {
        for (int64_t i = 0; i < n; ++i) {
            for (int64_t j = 0; j < n-1; ++j) {
                out << random(1, MAX_VALUE) << " ";
            }
            out << random(1, MAX_VALUE) << std::endl;
        }
    }

    out.close();

    std::cout << "Generated" << std::endl;
    return 0;
}