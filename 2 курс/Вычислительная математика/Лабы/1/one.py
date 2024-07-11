import numpy as np
import matplotlib.pyplot as plt
from prettytable import PrettyTable


fig, ax = plt.subplots()
ax.grid()

# интервал
a, b = 0.1, 1.0
# погрешность
eps = 0.00005

# функция
pf = "x^3 - sin(x)"
f = lambda x:  x**3 - np.sin(x)

# первая производная
df = lambda x: 3 * x**2 - np.cos(x)
#вторая производная
ddf = lambda x: 6 * x + np.sin(x)

k = 7
#phi(x)
pphi = "x - (x^3 - sin(x))/"+str(k)
phi = lambda x: x - ((x**3 - np.sin(x))/k)
#первая производная phi(x)
dphi = lambda x: 1-(1/k)*df(x)
pdphi = "1 - 1/"+str(k)+" * 3x^2 - cos(x)"

res = a
x = np.linspace(a, b)

def combined_method(left, right):
    def hords(xa, xb):
        return xb - f(xb) * (xb - xa) / (f(xb) - f(xa))

    def casat(xa):
        return xa - f(xa) / df(xa)

    fixed = f(left) * ddf(left) > 0
    if fixed:
        xa, xb = left, right
    else:
        xa, xb = right, left

    i = 0
    yield i, xa, f(xa), xb, f(xb), xb - xa
    
    while abs(xb - xa) > eps and i < 50:
        
        i += 1

        #Если неподвижна A
        if fixed:
            xb = hords(xa, xb)
            xa = casat(xa)
        else:
            xa = hords(xb, xa)
            xb = casat(xb)

        
        yield i, xa, f(xa), xb, f(xb), xb - xa


def iter_method(left, right, er):

    i = 0
    xn = left
    xn1 = right
    delta = xn-xn1
    while abs(delta) > er and i < 50:
        i += 1
        xn1 = phi(xn)
        delta = xn-xn1
        xn = xn1

        yield i, xn, phi(xn)
        


def checkform(left):
    if f(left) * ddf(left) > 0:
        r1 = 'По недостатку - метод касательных'
        r2 = 'По избытку - метод хорд'
    else:
        r1 = 'По недостатку - метод хорд'
        r2 = 'По избытку - метод касательных'
    return r1, r2

def isolate(left, right, acc):
    while f(left + acc) * f(right - acc) < 0:
        left += acc
        right -= acc

    while f(left) * f(left + acc) > 0:
        left += acc

    while f(right) * f(right - acc) > 0:
        right -= acc

    return left, right


def combined():
    print(f"f(x) = {pf}")
    print(f"[{a}, {b}]")
    print(f"f(a) = {f(a)}")
    print(f"f(b) = {f(b)}")
    print(f"f`(a) = {df(a)}")
    print(f"f`(b) = {df(b)}")
    print(f"f``(a) = {ddf(a)}")
    print(f"f``(b) = {ddf(b)}")
    r1, r2 = checkform(a)
    print(r1)
    print(r2)

    mm = abs(ddf(b)) <= abs(2*df(a))
    print(f"M <= 2m: {'верно' if mm else 'Неверно'}")

    an, bn = isolate(a,b, 0.01)
    print("Уточнение интервала изоляции: [{:.3f},{:.3f}]".format(an, bn))

    tablex = PrettyTable() 
    for t in combined_method(an,bn):
        # print('{}\t{:.15f}\t{:.15f}\t{:.15f}\t{:.15f}\t{:.15f}'.format(*t))
        tablex.field_names = ["n", "xa", "f(xa)", "xb","f(xb)", "xb - xa"]
        tablex.add_row(t)
        tablex.float_format = '.6'
        res = t[1]
        
    print(tablex)
    print(f'Решение: {res:.6f}')


def iteration():
    print(f"f(x) = {pf}")
    print(f"f(a) = {f(a)}")
    print(f"f(b) = {f(b)}")
    print(f"f`(a) = {df(a)}")
    print(f"f`(b) = {df(b)}")
    print(f"phi(x) = {pphi}")
    print(f"phi(a) = {phi(a)}")
    print(f"phi(b) = {phi(b)}")
    print(f"phi`(a) = {dphi(a)}")
    print(f"phi`(b) = {dphi(b)}")

    an, bn = isolate(a,b, 0.01)
    print("Уточнение интервала изоляции: [{:.3f},{:.3f}]".format(an, bn))

    if dphi(an) < 0 and dphi(bn) < 0:
        ts = "Двусторонняя"
        e = eps
    else:
        ts = "Односторонняя"
        e = abs(1 - max(abs(dphi(an)), abs(dphi(bn)))) * eps

    print(f"Тип сходимости: {ts}")
    print(f"Критерий останова: {e:.10f}")

    print(f"phi`(an) = {dphi(an)}")
    print(f"phi`(bn) = {dphi(bn)}")    

    tablex = PrettyTable() 
    for t in iter_method(an,bn,e):
        # print('{}\t{:.15f}\t{:.15f}'.format(*t))
        tablex.field_names = ["n", "xn", "phi(xn)"]
        tablex.add_row(t)
        tablex.float_format = '.10'
        res = t[2]
        
    print(tablex)
    print(f'Решение: {res:.6f}')


combined()
# iteration()

plt.plot(x, f(x))
plt.show()
