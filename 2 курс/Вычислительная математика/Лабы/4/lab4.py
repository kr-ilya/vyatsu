from math import *
from prettytable import PrettyTable

def trapez_n(f1, a, b, eps):
    return round(sqrt(abs((b - a) ** 3 * f1(a) / (12 * eps))))

def trapezoid(func,n, a,b,eps):
    h = (b - a)/n
    result = sum(h * (func(a+h*i) + func(a+h*(i+1)))/2 for i in range(n))
    return round(result, int(-log10(eps)))

def trapezoid_print(func,n, a,b,eps):
    tablex = PrettyTable() 
    tablex.field_names = ["i", "xi", 'f(xi)', 'k']
    tablex.float_format = '.4'

    h = (b - a)/n
     
    for i in range(n+1):
        if i == 0 or i == n:
            k = 0.5
        else:
            k = 1

        row = []
        row.append(i)
        row.append(a+h*i)  
        row.append(func(a+h*i))
        row.append(k)
        tablex.add_row(row)
    print(tablex)

def simpson(func, a, b, h, eps):

    n = round((b - a) / h)
    
    i1 = h / 3 * (func(a) + func(b)
                    + 4 * sum(func(a + i * h) for i in range(1, n, 2))
                    + 2 * sum(func(a + i * h) for i in range(2, n, 2)))

    return i1

def simpson_print(func, a, b, h, eps):

    tablex = PrettyTable() 
    tablex.field_names = ["i", "xi", 'f(xi)', 'k']
    tablex.float_format = '.4'

    n = round((b - a) / h)

    for i in range(n+1):
        if i == 0 or i == n:
            k = 1
        elif i % 2 == 0:
            k = 2
        else:
            k = 4

        row = []
        row.append(i)
        row.append(a + i * h)  
        row.append(func(a + i * h))
        row.append(k)
        tablex.add_row(row)
    print(tablex)

def gauss(table, func, a, b):
    res = 0.5 * (b - a) * sum(a * func((b - a) * x / 2 + (a + b) / 2) for a, x in zip(*table))
    return res

def gauss_print(table, func, a, b):
    print('Argi = (b - a) * xi / 2 + (a + b) / 2')
    tablex = PrettyTable() 
    tablex.field_names = ["i", "xi", 'Ai', 'Argi', 'f(Argi)', 'Ai*f(Argi)']
    tablex.float_format = '.5'
    s = 0
    i = 0
    for a, x in zip(*table):
        arg = (b - a) * x / 2 + (a + b) / 2
        row = []
        row.append(i)
        row.append(x)  
        row.append(a)  
        row.append(arg)  
        row.append(func(arg))
        row.append(a*func(arg))
        s += a*func(arg)
        tablex.add_row(row)
        i += 1
    print(tablex)
    print(f'sum(Ai*func(Argi)) = {s}')


def difur(func, a, b, h, x0, y0, f_ex):
    tablex = PrettyTable() 
    tablex.field_names = ["i", "xi", 'yi', 'f(x, y)', 'xi+h', 'yi+h*fi', 'f(xi+h, yi+h*fi)', 'dYk', 'eyi', 'abs(eyi-yi)']
    tablex.float_format = '.5'

   
    x = x0
    y = y0
    i = 0
    while x <= b:
        row = []
        row.append(i)
        row.append(x)
        row.append(y)
        if x == b:
            row.append('---')
            row.append('---')
            row.append('---')
            row.append('---')
            row.append('---')
        else:

            row.append(func(x, y))
            row.append(x+h)
            row.append(y+h*func(x,y))
            row.append(func(x+h, y+h*func(x,y)))
            dy = h/2*(func(x, y) + func(x+h, y+h*func(x, y)))
            ey = f_ex(x)
            row.append(dy)
        row.append(ey)
        row.append(abs(ey-y))
        tablex.add_row(row)
        y += dy
        x += h
        x = round(x, 3)
        i += 1

    print(tablex)
#формула трапеций
print('trapezoid method')

a_trapezoid = 0.6
b_trapezoid = 1.5
# фукнция
f_trapezoid = lambda x: 1/(sqrt(1+2*x**2))
#вторая производная
f1_trapezoid = lambda x: -2*x*(1+2*x**2)**-1.5
eps_trapezoid = 0.0001
n_trapezoid = trapez_n(f1_trapezoid, a_trapezoid, b_trapezoid, eps_trapezoid)

print('f = 1/sqrt(1+2*x^2)')
print(f'[{a_trapezoid}, {b_trapezoid}]')
print(f'n = {n_trapezoid}')
print(f'h = {round((b_trapezoid - a_trapezoid)/n_trapezoid, 4)}')
print(f'eps = {eps_trapezoid}')
trapezoid_print(f_trapezoid, n_trapezoid, a_trapezoid, b_trapezoid, eps_trapezoid)
r = trapezoid(f_trapezoid, n_trapezoid, a_trapezoid, b_trapezoid, eps_trapezoid)
print(f'I = {r}')
print()
print()

# метод симпсона
print('simpson method')

a_simpson = 0.4
b_simpson = 0.8
f_simpson = lambda x: tan(x**2+0.5)/(1+2*x**2)
eps_simpson = 0.0001
h_simpson = 0.01
print('f = tg(x^2+0,5)/(1+2*x^2)')
print(f'[{a_simpson}, {b_simpson}]')
print(f'eps = {eps_simpson}')
print()
print(f'step = h = {h_simpson}')
simpson_print(f_simpson, a_simpson, b_simpson, h_simpson, eps_simpson)
r1 = simpson(f_simpson, a_simpson, b_simpson, h_simpson, eps_simpson)
print(f'I = {round(r1, int(-log10(eps_simpson)))}')
print()
print(f'step = h/2 = {h_simpson/2}')
simpson_print(f_simpson, a_simpson, b_simpson, h_simpson/2, eps_simpson)
r2 = simpson(f_simpson, a_simpson, b_simpson, h_simpson/2, eps_simpson)
print(f'I = {round(r2, int(-log10(eps_simpson)))}')
print(f'Difference: {abs(r2-r1):.16f}')

print()
print()

#метод гаусса
print('gauss method')

a_gauss = -0.4
b_gauss = 1.6
f_gauss = lambda x: (x+1)/sqrt(x**2+1)
t1_gauss = [
    (0.129484966, 0.279705391, 0.381830051, 0.417959184, 0.381830051, 0.279705391, 0.129484966),
    (-0.949107912, -0.741531186, -0.405845151, 0, 0.405845151, 0.741531186, 0.949107912)
]

t2_gauss = [
    (0.34785, 0.65215, 0.65215, 0.34785),
    (-0.86114, -0.33998, 0.33998, 0.86114)
]

print('f = (x+1)/sqrt(x^2+1)')
print(f'[{a_gauss}. {b_gauss}]')
print('4 nodes:')

print('x1 = -0.86114    A1 = 0.34785')
print('x2 = -0.33998    A2 = 0.65215')
print('x3 =  0.33998    A3 = 0.65215')
print('x4 =  0.86114    A4 = 0.34785')
print()
print('7 nodes:')

print('x1 = -0.949107912    A1 = 0.129484966')
print('x2 = -0.741531186    A2 = 0.279705391')
print('x3 = -0.405845151    A3 = 0.381830051')
print('x4 =  0.000000000    A4 = 0.417959184')
print('x5 =  0.405845151    A5 = 0.381830051')
print('x6 =  0.741531186    A6 = 0.279705391')
print('x7 =  0.949107912    A7 = 0.129484966')
print()
print(print(f'(b-a)/2 = {(b_gauss-a_gauss)/2}'))
print('4 NODES:')

gauss_print(t2_gauss, f_gauss, a_gauss, b_gauss)
r1 = gauss(t2_gauss, f_gauss, a_gauss, b_gauss)
print(f'I = {r1}')
print()

print('7 NODES:')

gauss_print(t1_gauss, f_gauss, a_gauss, b_gauss)
r2 = gauss(t1_gauss, f_gauss, a_gauss, b_gauss)
print(f'I = {r2}')
print(f'Difference: {abs(r2-r1):.16f}')
print()
print()

#диф уравение
print('differential equation')

f_difur = lambda x, y: x**3 + y
f_ex = lambda x: 13*exp(x)*0.5 - x**3 - 3*x**2 - 6*x - 6
a_difur = 0.0
b_difur = 1.0
h_difur = 0.1
x0_difur = 0
y0_difur = 0.5
print('y` = x^3 + y')
print('y() = 13*e^x*0.5 - x^3 - 3*x^2 - 6*x - 6')
print(f'{a_difur} <= x <= {b_difur}')
print(f'h = {h_difur}')
print(f'y({x0_difur}) = {y0_difur}')
print()
print(f'step = h = {h_difur}')
difur(f_difur, a_difur, b_difur, h_difur, x0_difur, y0_difur, f_ex)

print()
print(f'step = h/2 = {h_difur/2}')
difur(f_difur, a_difur, b_difur, h_difur/2, x0_difur, y0_difur, f_ex)