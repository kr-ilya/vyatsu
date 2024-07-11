#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <time.h>

int GetRandomNumber(int min, int max){
    

    int num = min + rand() % (max - min + 1);

    return num;
}

int main(){
    
    std::ofstream out;
    out.open("input.txt");

    int n, mw;
    const int max_cost = 1e4;

    if(out.is_open()){
        srand(time(NULL));
        std::cin >> n >> mw;

        out << n << " " << mw << std::endl;

        for(int i = 0; i < n; i++){
            int cost = GetRandomNumber(1, max_cost);
            int weight = GetRandomNumber(1, mw);
            out << cost << " " << weight << std::endl;
        }
    }

    return 0;
}