import random
import sys
sys.setrecursionlimit(2000)

fact = lambda n, k = 2: [1, n,] if isPrime(n) else [k] + fact(n//k, k) if n % k == 0 else fact(n, k+1) if k <= n else []

def factorize(n):
    n = int(n)
    return ' '.join(str(x) for x in fact(n))

def isPrime(x):
    x = int(x)
    return len(list(filter(lambda i: x % i == 0, range(2, int(x**0.5) + 1)))) == 0

def getNext(i):
    i = int(i)
    return str(getNext(i + 1) if not isPrime(i + 1) else i + 1)

getRandomPrime = lambda: str(getNext(random.randint(2, 10**12)))