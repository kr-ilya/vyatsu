import random

isPrime = lambda x: len(list(filter(lambda i: x % i == 0, range(2, int(x**0.5) + 1)))) == 0

factorize = lambda n, k = 2: [1, n,] if isPrime(n) else [k] + factorize(n//k, k) if n % k == 0 else factorize(n, k+1) if k <= n else []

getNext = lambda i: getNext(i + 1) if not isPrime(i + 1) else i + 1

getRandomPrime = lambda: getNext(random.randint(2, 10**9))