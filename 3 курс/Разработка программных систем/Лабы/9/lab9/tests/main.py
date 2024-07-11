from time import time
from fast_factorize import factorize
import sys

sys.setrecursionlimit(2000)

def main():
    data = [21990232406568, 219982384065688, 2199882324665688, 219988232466568884]

    def fact(n):
        i = 2
        prims = []
        while i * i <= n:
            while n % i == 0:
                prims.append(i)
                n /= i

            i += 1
        if n > 1:
            prims.append(n)
        return prims
    
    for i, v in enumerate(data):
        print(i+1)
        start = time()
        rp = fact(v)
        duration = time() - start
        print(f"[Python]: {time() - start}")      

        r = factorize(v)
        print()
        

if __name__ == "__main__":
    main()