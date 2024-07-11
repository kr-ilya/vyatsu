import random
from fast_factorize import factorize as fast_fact

def factorize(n):
    n = int(n)
    r = [1, n,] if isPrime(n) else fast_fact(n)
    return ' '.join(str(x) for x in r)

def isPrime(x):
    x = int(x)
    return len(list(filter(lambda i: x % i == 0, range(2, int(x**0.5) + 1)))) == 0

def getNext(i):
    i = int(i)
    return str(getNext(i + 1) if not isPrime(i + 1) else i + 1)

getRandomPrime = lambda: str(getNext(random.randint(2, 10**12)))