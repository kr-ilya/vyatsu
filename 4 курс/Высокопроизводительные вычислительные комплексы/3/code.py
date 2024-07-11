from math import factorial as fact
from functools import reduce


def pi_0(b, k):
    den = b ** k / (fact(k) * (1 - b / k)) + sum(b ** m / fact(m) for m in range(k))
    return 1 / den


def l(b, k):
    p = pi_0(b, k)
    return p * b ** (k + 1) / (fact(k) * k * (1 - b / k) ** 2)


def m(b, k):
    return b + l(b, k)

bks = [(0.235, 2), (0.0125, 1), (0.0525, 1), (0.065, 2), (0.042, 2)]

total = 1
print('p_i')
for (b, k) in bks:
    print(pi_0(b, k))
    total *= pi_0(b, k)

print('l_i')
for (b, k) in bks:
    print('{:0.5f}'.format(l(b, k)))

print('m_i')
for (b, k) in bks:
    print('{:0.5f}'.format(m(b, k)))

l0 = 0.1
lambdas = [0.5, 0.05, 0.175, 0.125, 0.05]
print('w_i')
for ((b, k), lm) in zip(bks, lambdas):
	print('{:0.5f}'.format(l(b, k) / lm))

print('u_i')
for ((b, k), lm) in zip(bks, lambdas):
	print('{:0.7f}'.format(m(b, k) / lm))
              
print('P')
print(total)

print('L')
print(sum(l(b, k) for ((b, k), lm) in zip(bks, lambdas)))

print('M')
print(sum(m(b, k) for ((b, k), lm) in zip(bks, lambdas)))

print('W')
print(sum(l(b, k) / lm * lm / l0 for ((b, k), lm) in zip(bks, lambdas)))

print('U')
print(sum(m(b, k) / lm * lm / l0 for ((b, k), lm) in zip(bks, lambdas)))