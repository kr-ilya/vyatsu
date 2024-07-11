#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>

int main(){
    std::ifstream fin("input.txt");

    int num_items, max_weight;

    fin >> num_items >> max_weight;

    std::vector<std::vector<int>> matrix(2, std::vector<int>(max_weight+1));
    std::vector<int> w(num_items);
    std::vector<int> c(num_items);

    for(int i = 0; i <= max_weight; i++){
        matrix[0][i] = 0;
    }

    matrix[1][0] = 0;

    for(int i = 0; i < num_items; i++){
        fin >> c[i] >> w[i];
    }

    int a = 0;
    int b = 1;

    for(int i = 0; i <= num_items; i++){
        for(int j = 0; j <= max_weight; j++){
            if(i != 0 && j != 0){
                if(w[i-1] > j){
                    matrix[b][j] = matrix[a][j];
                }else{
                    matrix[b][j] = std::max(matrix[a][j], matrix[a][j-w[i-1]]+c[i-1]);
                }
            }
        }

        a ^= 1;
        b ^= 1;
    }

    std::cout << matrix[a][max_weight] << std::endl;

    return 0;
}