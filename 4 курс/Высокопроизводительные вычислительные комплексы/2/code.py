from math import factorial as fact

def p_0(R, N):
    num = R ** N
    den = fact(N - 1) * (N - R)
    s = sum((R ** n) / fact(n) for n in range(N))
    return 1 / (num / den + s)


def p_n(R, n, N):
    if n <= N:
        return p_0(R, N) * (R ** n) / fact(n)
    else:
        # print(f'aa = {p_0(R, N)}')
        return p_0(R, N) * (R ** n) / (fact(N) * N ** (n - N))


def p_0_1(N, p):
    num = N ** (N - 1) * p ** N
    den = fact(N - 1) * (1 - p)
    s = sum((N ** i) * (p ** i) / fact(i) for i in range(N))
    return 1 / (num / den + s)


def l(N, p):
    num = N ** (N - 1) * p ** (N + 1) * p_0_1(N, p)
    den = fact(N - 1) * (1 - p) ** 2
    return num / den


def _m(B, o):
    return B/o

def _ro(B, o, lmb, N):
    return lmb/N * o/B

def _R(ro, N):
    return ro*N

def _W(l, lmb):
    return l/lmb

def _U(l, R, lmb):
    return (l+R)/lmb

B = 180
o = 4
lmb = 12

for i in range(1, 4):
    m = _m(B, o)
    ro = _ro(B, o, lmb, i)
    R = _R(ro, i)
    l_ = l(i, ro)
    W = _W(l_, lmb)
    U = _U(l_, R, lmb)


    print(f'N = {i} m = {round(m, 3):.3f} ro = {round(ro, 3):.3f} R = {round(R, 3):.3f} l = {round(l_, 6):.6f} W = {round(W, 6):.6f} U = {round(U, 3):.3f}')

# t1 = p_n(3.1, 8, 6)
# print(round(t1, 4))

# t2 = p_n(1.6, 3, 2)
# print(round(t2, 4))

# t3 = l(6, 0.0667)
# print(round(t3, 7))