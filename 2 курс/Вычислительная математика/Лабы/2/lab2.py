from math import *
import sys
from prettytable import PrettyTable
import numpy as np
from numpy import linalg as LA


eqtype = -1
if(len(sys.argv) > 1):
    eqtype = int(sys.argv[1])

if not (eqtype > 0 and eqtype <= 5):
    eqtype = -1
    print('Неверный параметр. Допустимые значения: 1-4')

def gauss_table(a,b, eps):
    n = len(b)
    tablex = PrettyTable() 
    tablex.field_names = ["x1", "x2", "x3", "x4", 'X', 'Check']
    tablex.float_format = '.3'

    #Формирование таблицы
    # Вывод исходной матрицы
    for i in range(n):
        row = []
        rowsum = 0
        for t in range(n):
            row.append(a[i][t])
            rowsum += a[i][t]
        rowsum += b[i]
        row.append(b[i])
        row.append(rowsum)

        tablex.add_row(row)
       
    # Находим m
    for i in range(n):
        tablex.add_row(["-"*6]*6)
        row = ["*"]*6
        rowsum = 0
        if i+1 < n:
            m = a[i+1][i]/a[i][i]
            # первая строчка /m
            for t in range(i, n):
                row[t] = a[i][t]*m
                rowsum += a[i][t]*m
            row[4] = b[i]*m
            rowsum += b[i]*m
            row[5] = rowsum
            tablex.add_row(row)
            tablex.add_row(["-"*6]*6)

        # по строкам
        for j in range(i+1, n):
            row = ["*"]*6
            rowsum = 0
            m = -a[j][i]/a[i][i]
            # по столбцам
            for k in range(i, n):
                a[j][k] += a[i][k]*m
                row[k] = a[j][k]
                rowsum += a[j][k]
            b[j] += b[i]*m 
            row[4] = b[j]
            rowsum += b[j]
            row[5] = rowsum
            tablex.add_row(row)

    r = ""
    r2 = ""
    for idx, val in reversed(list(enumerate(gauss(a, b, eps)))):
        r += "X"+str(idx+1)+"="+str(val)+"\n"
        r2 += "!X"+str(idx+1)+"="+str(round(val+1, int(-log10(eps))))+"\n" 
    tablex.add_row(["*","*","*","*",r, r2])
    return tablex
    # Конец формирования таблицы

def gauss(a, b, eps):
    n = len(b)
    
    for i in range(n): # по столбцам
        # поиск опорного элемента
        z = i
        for h in range(z+1, n):
            if(abs(a[z][i]) < abs(a[h][i]) or a[z][i] == 0):
                a[z], a[h] = a[h], a[z]
                b[z], b[h] = b[h], b[z]
       
        # прямой ход
        for j in range(i+1, n): # по строкам c i+1
            m = -a[j][i]/a[i][i]
            for k in range(i, n): # по столбцам с i
                a[j][k] += a[i][k]*m
            b[j] += b[i]*m 
        
    # обратный ход
    x = [0] * n
    for i in range(n-1, -1, -1):
        r = 0
        for j in range(i+1, n):
            r += a[i][j] * x[j]
        x[i] = (b[i] - r)/a[i][i]

    return [round(i, int(-log10(eps))) for i in x]

def simple_iterations(a, b, eps):

    x0 = b[:]
    x1 = b[:]
    n = len(b)     

    tablex = PrettyTable() 
    tablex.field_names = ["n", "x1", "x2", "x3", "x4", 'b']
    tablex.float_format = '.5'

    tablex.add_row([0, x1[0], x1[1], x1[2], x1[3], abs(max(x1, key=abs))])
    k = 0
    while True:
        row = [0]*6
        k += 1
        row[0] = k
        for i in range(n): 
            
            x1[i] = b[i]
            for j in range(n):
                x1[i] += x0[j] * a[i][j]
            row[i+1] = x1[i]

        atmp = [0]*n
        for i in range(n):
            atmp[i] = x1[i] - x0[i]

        row[-1] = abs(max(atmp, key=abs))
        tablex.add_row(row)
        if abs(max(atmp, key=abs)) <= eps:
            break
        else:
            x0 = x1[:]

       

    print(tablex)
    return [round(x, int(-log10(eps))) for x in x0]

def simple_iterations_norms(a,n):

    # alpha 1
    # по строкам
    s1 = 0
    for i in range(n):
        stmp = 0
        for j in range(n):
            stmp += abs(a[i][j])
        if stmp > s1:
            s1 = stmp

    # alpha 2
    # по столбцам
    s2 = 0
    for i in range(n):
        stmp = 0
        for j in range(n):
            stmp += abs(a[j][i])
        if stmp > s2:
            s2 = stmp

    # alpha 3
    # евклидова норма
    s3 = 0
    for i in range(n):
        for j in range(n):
            s3 += abs(a[i][j])**2
    s3 = sqrt(s3)

    return [s1, s2, s3]

def reverse_matrix(a,b):
    a0 = LA.inv(a)
    ar = np.array(a0)
    br = np.array(b)

    return ar.dot(br)  

def newton_method(funcs, s, eps):
    f1, f2, f1x, f1y, f2x, f2y = funcs
    x0, y0 = s

    tablex = PrettyTable() 
    tablex.field_names = ["n", "x", "y", "dx", "dy", 'max(dx^2, dy^2)']
    tablex.float_format = '.5'

    k = 0


    while True:
        k += 1
        row = [0]*6
        row[0] = k
        a = [
                [f1x(x0, y0), f1y(x0, y0)],
                [f2x(x0, y0), f2y(x0, y0)]
            ]
        
        b = [-f1(x0, y0), -f2(x0, y0)]

        # определитель a
        d = (a[0][0] * a[1][1]) - (a[0][1] * a[1][0])

        dx = (b[0]  * a[1][1] - b[1] * a[0][1]) / d
        dy = (b[1] * a[0][0] - b[0] * a[1][0]) / d

        row[1] = x0+dx
        row[2] = y0+dy
        row[3] = dx
        row[4] = dy
        row[5] = max(dx**2, dy**2)
        tablex.add_row(row)

        if max(dx**2, dy**2) <= eps:
            break
        else:
            x0 += dx
            y0 += dy
    print(tablex)
    return round(x0, int(-log10(eps))), round(y0, int(-log10(eps)))

#Метод Гусса
if eqtype == 1:
    # мой
    A = [
        [2.20, -3.17, 1.24, -0.87],
        [1.50, 2.11, -0.45, 1.44],
        [0.86, -1.44, 0.62, 0.28],
        [0.48, 1.25, -0.63, -0.97]
    ]

    B = [0.46, 1.50, -0.12, 0.35]

    print('Gauss method')
    print('2,20*x1-3,17*x2+1,24*x3-0,87*x4=0,46')      
    print('1,50*x1+2,11*x2-0,45*x3+1,44*x4=1,50')            
    print('0,86*x1-1,44*x2+0,62*x3+0,28*x4=-0,12')            
    print('0,48*x1+1,25*x2-0,63*x3-0,97*x4=0,35')
    print('e = 0.001')
    print()

    #Вывод таблицы
    tablex = gauss_table(A,B, 0.001)
    print(tablex)

    for idx, val in enumerate(gauss(A, B, 0.001)):
        print('X'+str(idx+1), val)

# Метод простых итераций
if eqtype == 2:
    # мой
    A = [
        [0.00, 0.22, -0.11, 0.31],
        [0.38, 0.00, -0.12, 0.22],
        [0.11, 0.23, 0.00, -0.51],
        [0.17, -0.21, 0.31, 0.00]
    ]

    B = [2.70, -1.50, 1.20, -0.17]

    print('Simple iteration method')
    print('x1=0,22*x2-0,11*x3+0,31*x4+2,70')                   
    print('x2=0,38*x1-0,12*x3+0,22*x4-1,50')                   
    print('x3=0,11*x1+0,23*x2-0,51*x4+1,20')                   
    print('x4=0,17*x1-0,21*x2+0,31*x3-0,17')
    print('e = 0.0001')
    print()

    for idx, val in enumerate(simple_iterations_norms(A, len(B))):
        print('α'+str(idx+1), round(val, 4))
    print()
    for idx, val in enumerate(simple_iterations(A, B, 0.0001)):
        print('X'+str(idx+1), val)

# Метод обратной матрицы
if eqtype == 3:
    A = [
        [2,1,1],
        [1,3,2],
        [4,1,2]
    ]
    
    B = [5,8,9]

    print('Inverse matrix method')
    print('2*x1+x2+x3=5')                  
    print('x1+3*x2+2*x3=8')                
    print('4*x1+x2+2*x3=9')
    print('e = 0.001')

    print('det|A| = ', round(LA.det(A), 3))
    print()
    print('Matrix')

    for i in range(len(B)):
        s = ''
        for j in range(len(B)):
            s += str(A[i][j])+' '
        print(s)
    invmat = LA.inv(A)
    print()
    print('Inverse matrix')
    for i in range(len(B)):
        s = ''
        for j in range(len(B)):
            s += str(round(invmat[i][j],3))+' '
        print(s)


    for idx, val in enumerate(reverse_matrix(A, B)):
        print('X'+str(idx+1), round(val, int(-log10(0.001))))


# Метод Ньютона
if eqtype == 4:

    functions = [
        lambda x, y: x + exp(0.1 - y) + 2.1, #F1
        lambda x, y: y + cos(x), #F2
        lambda x, y: 1, #F1`x
        lambda x, y: -exp(0.1 - y), #F1`y
        lambda x, y: -sin(x), #F2`x
        lambda x, y: 1, #F2`y
    ]

    s = [-2.1, 0.1]

    print('Newton method')
    print('F1 = x+exp(0.1-y)+2.1=0')            
    print('F2 = y+cos(x)=0')
    print('F1`x = 1')
    print('F1`y = -exp(0.1-y)')
    print('F2`x = -sin(x)')
    print('F2`y = 1')
    print('e = 0.001')
    print()

    x, y = newton_method(functions, s, 0.001)
    print('x = ', x)
    print('y = ', y)