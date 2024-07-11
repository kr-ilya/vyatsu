from math import *
from functools import reduce
from prettytable import PrettyTable
import matplotlib.pyplot as plt

def print_lagrange_interpolation(x, func, eps):

    tablex = PrettyTable() 
    tablex.header  = False
    tablex.float_format = '.4'
    tablex2 = PrettyTable() 
    tablex2.field_names = ["D, 10^-6", "Yi/Di, 10^6"]
    tablex2.float_format = '.4'
    xs, ys = func
    n = len(xs)     
    rs = [[0]*n for i in range(n)]

    print('x = ', x)
    
    print('xi   yi')
    for i in range(n):
        print(xs[i], ys[i])

    for i in range(n):
        row = []
        for j in range(n):
            if i != j:
                rs[i][j] = round(xs[i] - xs[j], int(-log10(eps)))
    
    mt = 1
    for i in range(n):
        rs[i][i] = round(x-xs[i], int(-log10(eps)))
        mt *= rs[i][i]
        tablex.add_row(rs[i])
        
    syd = 0
    for i in range(n):
        row = []
        tm = 1
        for j in range(n):
            tm *= rs[i][j]
        syd += ys[i]/tm
        row.append(round(tm*10**6, int(-log10(eps))))
        row.append(round((ys[i]/tm)/10**6, int(-log10(eps))))
        tablex2.add_row(row)


    xs, ys = func
    n = len(xs)

    ls = [reduce(lambda a, b: a * b, ((x-xs[j])/(xs[i]-xs[j]) for j in range(n) if i != j)) for i in range(n)]

    print(tablex)
    print(tablex2)

    print('sum(Yi/Di) = {:2.4f} * 10^6'.format(syd/10**6))
    print('the product of diagonal = {:2.4f} * 10^-6'.format(mt*10**6))


def lagrange_interpolation(x, func, eps):
    xs, ys = func
    n = len(xs)

    ls = [reduce(lambda a, b: a * b, ((x-xs[j])/(xs[i]-xs[j]) for j in range(n) if i != j)) for i in range(n)]
    result = sum(l * y for l, y in zip(ls, ys))

    return round(result, int(-log10(eps)))

def getQ(x, x0, step):
    return (x-x0)/step

def newton_member(q, dy, n, y0, t):
    # print(q, dy, n, y0, t)
    tmp = q
    if n > 1:
        for i in range(2, n+1):
            if t == 1:
                tmp *= (q-i+1)
            else:
                tmp *= (q+i-1)
        tmp = (tmp/factorial(n))*dy
    elif n == 1:
        tmp *= dy
    elif n == 0:
        tmp = y0
    return tmp

def print_newton_interpolation(x_list, h, xy_list, eps):
    tablex_nn1 = PrettyTable() 
    tablex_nn1.field_names = ["Xi", "Yi"]
    tablex_nn1.float_format = '.4'

    tablex_nn2 = PrettyTable() 
    tablex_nn2.float_format = '.4'

    xs, ys = xy_list

    l = len(x_list)
    for i in range(l):
        print(f'x{i+1} = {x_list[i]}')

    ll = len(xs)
    for i in range(ll):
        row = []
        row.append(xs[i])
        row.append(ys[i])

        tablex_nn1.add_row(row)

    print(tablex_nn1)

    print(f'Step = {h}')

    col = []
    for i in range(ll):
        col.append(xs[i])
    tablex_nn2.add_column('X', col)

    col = []
    for i in range(ll):
        col.append(ys[i])
    tablex_nn2.add_column('Y', col)
    dy1List = [] # первая строка dnY
    dy2List = [] # диагональные жлементы dnY
    tmpY = ys[:]
    for i in range(ll-1):
        col = ['']*(ll)
        for j in range(ll-1-i):
            col[j] = round(tmpY[j+1] - tmpY[j], int(-log10(eps)))
        
        tablex_nn2.add_column(f'd{i+1}Y', col)
        tmpY = col[:]
        dy1List.append(col[0])
        dy2List.append(col[j])
    
    print(tablex_nn2)
    print('\n')
    print('The first interpolation formula:')

    q = getQ(x_list[0], xs[0], h)

    print(f'x1={x_list[0]}')
    print(f'q={q:.6f}')
    sumRes = 0
    print('Members of the polynomial:')
    for i in range(ll):
        res = newton_member(q, dy1List[i-1], i, ys[0], 1)
        sumRes += res
        print('{}) {:.8f}'.format(i, res))
    
    print(f'P({x_list[0]}) = {sumRes:.6f}')

    print('\n')
    print('The second interpolation formula:')

    q = getQ(x_list[1], xs[-1], h)

    print(f'x2={x_list[1]}')
    print(f'q={q:.6f}')
    sumRes = 0
    print('Members of the polynomial:')
    for i in range(ll):
        res = newton_member(q, dy2List[i-1], i, ys[-1], 2)
        sumRes += res
        print('{}) {:.8f}'.format(i, res))
    
    print(f'P({x_list[1]}) = {sumRes:.6f}')

    print('\n')
    print('The first interpolation formula:')

    q = getQ(x_list[2], xs[0], h)

    print(f'x3={x_list[2]}')
    print(f'q={q:.6f}')
    sumRes = 0
    print('Members of the polynomial:')
    for i in range(ll):
        res = newton_member(q, dy1List[i-1], i, ys[0], 1)
        sumRes += res
        print('{}) {:.8f}'.format(i, res))
    
    print(f'P({x_list[2]}) = {sumRes:.6f}')

    print('\n')
    print('The second interpolation formula:')

    q = getQ(x_list[3], xs[-1], h)

    print(f'x4={x_list[3]}')
    print(f'q={q:.6f}')
    sumRes = 0
    print('Members of the polynomial:')
    for i in range(ll):
        res = newton_member(q, dy2List[i-1], i, ys[-1], 2)
        sumRes += res
        print('{}) {:.8f}'.format(i, res))
    
    print(f'P({x_list[3]}) = {sumRes:.6f}')
    
def lin(a, b, x):
    return exp(log(a)+log(b)*x)

def find_b(x, y):
    l = len(x)
    sumxlny = 0
    sumx = 0
    sumlny = 0
    sumx2 = 0
    for i in range(l):
        sumxlny += x[i] * log(y[i])
        sumx += x[i]
        sumlny += log(y[i])
        sumx2 += x[i]*x[i]
    return exp((l*sumxlny - sumx*sumlny)/(l*sumx2-sumx*sumx))


def find_a(x,y, b):
    l = len(x)
    sumx = 0
    sumlny = 0
    for i in range(l):
        sumx += x[i]
        sumlny += log(y[i])

    return exp(1/l*sumlny - (log(b)/l)*sumx)

def print_squares(x, y):
    
    tablex_s = PrettyTable() 
    tablex_s.float_format = '.4'
    tablex_s.field_names = ["Xi", "Yi", "Xi*Yi", "Xi^2", "YiT", "delta", "delta^2"]
    l = len(x)

    b = find_b(x, y)
    a = find_a(x, y, b)
    ar=  round(a,4)
    br=  round(b,4)
    print('xi   yi')
    for i in range(l):
        print(f'{x[i]} {y[i]}')

    print('Type of empirical dependence: indicative')
    print(f'a = {ar}')
    print(f'b = {br}')
    print(f'The equation: y = {ar}{br}^x')
    print('ln(y)=Y    ln(a)=A   ln(b)=B')
    print(f'linear view: A+Bx')
    
    
    s1 = 0
    s2 = 0
    s3 = 0
    s4 = 0
    s5 = 0
    s6 = 0
    s7 = 0
    for i in range(l):
        row = []
        row.append(x[i])
        row.append(y[i])
        row.append(x[i]*y[i])
        row.append(round(x[i]**2, 4))
        row.append(round(lin(a,b,x[i]),4))
        row.append(round(y[i]-lin(a,b,x[i]), 4))
        row.append(round((y[i]-lin(a,b,x[i]))**2, 4))
        s1 += row[0]
        s2 += row[1]
        s3 += row[2]
        s4 += row[3]
        s5 += row[4]
        s6 += row[5]
        s7 += row[6]
        tablex_s.add_row(row)
    tablex_s.add_row(['---']*7)
    tablex_s.add_row([round(s1, 4), round(s2, 4), round(s3, 4), round(s4, 4), round(s5, 4), round(s6, 4), round(s7, 4)])
    print(tablex_s)
    dev = round(sqrt(s7)/l, 4)
    print(f'standard deviation: {dev}')
#интерполяция методом Лагранжа
x_lg = 0.153

func_vals = [
    (0.1, 0.2, 0.29, 0.40, 0.49, 0.55),
    (1.66448, 1.66071, 1.65734, 1.65322, 1.64987, 1.64764)
]

print('Lagrange interpolation')
print_lagrange_interpolation(x_lg, func_vals, 0.000001)

res = lagrange_interpolation(x_lg, func_vals, 0.000001)

print(f'Result: L({x_lg}) = {res}')


print('\n')
print('Newton interpolation')
#интерполяция методом Ньютона

x_newton = [0.455, 0.5575, 0.440, 0.5674]

h_newton = 0.01

xy_newton = [
    (0.45, 0.46, 0.47, 0.48, 0.49, 0.50, 0.51, 0.52, 0.53, 0.54, 0.55, 0.56),
    (20.1846, 19.6133, 18.9425, 18.1746, 17.3010, 16.3123, 15.1984, 13.9484, 12.5508, 10.9987, 9.2647, 7.3510)
]

eps_newton = 0.000001

print_newton_interpolation(x_newton, h_newton, xy_newton, eps_newton)

print('\n')
print('Least Squares method')
fig, ax = plt.subplots()
ax.grid()

x_squeares = [3.0, 3.1, 3.2, 3.3, 3.4, 3.5]
y_squares = [25.0, 29.4, 34.4, 40.4, 47.6, 56.0]

print_squares(x_squeares, y_squares)

plt.scatter(x_squeares, y_squares)
plt.show()