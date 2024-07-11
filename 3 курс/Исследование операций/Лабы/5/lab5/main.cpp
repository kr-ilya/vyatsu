#include <iostream>
#include <fstream>
#include <vector>

int main(){
    
    std::ifstream fin("input.txt");

    const int INF = 1e9;
    int m, n;
    int f, t;

    fin >> f >> t >> m >> n;

    std::vector<std::vector<int>> edges(n, std::vector<int>(3));

    for(int i = 0; i < n; i++){
        fin >> edges[i][0] >> edges[i][1] >> edges[i][2];
    }


    std::vector<int> mv(m, INF);
    std::vector<int> pref(m, -1);

    mv[f] = 0;

    for(int i = 1; i < m; i++){
        for(auto& e: edges){
            int a = e[0];
            int b = e[1];
            int w = e[2];

            if(mv[a] + w < mv[b]){
                mv[b] = mv[a] + w;
                pref[b] = a;
            }
        }
    }

    std::cout << "Res: " << mv[t] << std::endl;
    
    std::cout << t;
    int p = t;
    do{
        if (p != -1) {
            p = pref[p];
            std::cout << " <- " << p;
        } else {
            std::cout << " error path ";
            p = f;
        }
    }while (p != f);

    std::cout << std::endl;

    return 0;
}