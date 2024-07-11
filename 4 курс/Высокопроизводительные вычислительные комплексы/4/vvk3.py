import math

def summSQRT():
    i = 0
    S = 0
    while i < alpha.__len__():
        S += math.sqrt(k[i] * alpha[i] * teta[i])
        i = i + 1
    return S

def summSmin():
    i = 0
    S = 0
    while i < k.__len__():
        S += k[i] * Vmin[i]
        i = i + 1
    return S

def summ1(n):
    j = 0
    S = 0
    while j < n:
        S += math.sqrt(lambdamas[j] * teta[j] * k[j])
        j = j + 1
    return S

def summS():
    j = 0
    Sum = 0
    while j < S.__len__():
        Sum += S[j]
        j = j + 1
    return Sum

def summ2(n):
    i = 0
    S = 0
    while i < n:
        S += k[i] * alpha[i] * teta[i]
        i = i + 1
    return S

def summ3(n):
    i = 0
    S = 0
    while i < n:
        S += math.sqrt(k[i] * alpha[i] * teta[i])
        i = i + 1
    return S

'''numKanals = 4
P = [0.2, 0.25, 0.28, 0.27]
V=[0.45 , 0.25 ,0.25, 0.63]#среднее время обслуживания заявки единицей оборудования
K=[2,1,1,1]#колиество каналов или не каналов V со скрина
L0 = 0.1
L1=L0/P[0]
L=[]
L.append(L1)
for i in range(1, numKanals):
    L.append(P[i]*L1)

for i in range(L.__len__()):
    print('L['+(i+1).__str__()+'] = ' +L[i].__str__())

Alpha = []
for i in range(0,numKanals):
    Alpha.append(L[i]/L0)


for i in range(Alpha.__len__()):
    print('Alpha['+(i+1).__str__()+'] = ' +Alpha[i].__str__())

stacionar = []

for i in range(0, numKanals):
    stacionar.append(K[i]/(Alpha[i]*V[i]))

for i in range(stacionar.__len__()):
    print('stacionar['+(i+1).__str__()+'] = ' +stacionar[i].__str__())

if(L0 < min(stacionar)):
    print("Стационарный режим существует")
else:
    print("стационарный режим не существует")

B=[]
for i in range(0, numKanals):
    B.append(L[i]*V[i])

for i in range(B.__len__()):
    print('B['+(i+1).__str__()+'] = ' +B[i].__str__())


import math
def P0Calculate(i):
    if(K[i] ==1):
        return (1- B[i])
    else:
        Po = (B[i]**K[i])/ (math.factorial(K[i]) * (1- (B[i]/K[i])))
        for M0 in range(K[i]):
            Po += (B[i]**M0)/math.factorial(M0)

        Po = Po **(-1)
        return Po


P0=[]
for i in range(numKanals):
   P0.append(P0Calculate(i))

for i in range(P0.__len__()):
    print('P0['+(i+1).__str__()+'] = ' +P0[i].__str__())


P_14 = 1
for i in range(P0.__len__()):
    P_14*=P0[i]

print('P_14 = ' + P_14.__str__())


l = []

def lCalculate(i):
    li = ((B[i]**(K[i]+1))*P0[i])/(math.factorial(K[i]) * K[i] *(1- (B[i]/K[i]))*(1- (B[i]/K[i])))
    return li

for i in range(numKanals):
   l.append(lCalculate(i))

for i in range(l.__len__()):
    print('l['+(i+1).__str__()+'] = ' +l[i].__str__())

m=[]
for i in range(numKanals):
    m.append(l[i] +B[i])

for i in range(m.__len__()):
    print('m[' + (i+1).__str__()+'] = ' + m[i].__str__())



W=[]
for i in range(numKanals):
    W.append(l[i]/L[i])

for i in range(W.__len__()):
    print('W[' + (i+1).__str__()+'] = ' + W[i].__str__())


U=[]
for i in range(numKanals):
    U.append(W[i] + V[i])

for i in range(W.__len__()):
    print('U[' + (i+1).__str__()+'] = ' + U[i].__str__())

l_srednee = 0
for i in range(l.__len__()):
    l_srednee+=l[i]

print('l среднее число заявок ожидающих...  = ' + l_srednee.__str__())

m_srednee = 0
for i in range(m.__len__()):
    m_srednee+=m[i]

print('m среднее число заявок в сети  = ' + m_srednee.__str__())

W_srednee = 0
for i in range(Alpha.__len__()):
    W_srednee+= Alpha[i]*W[i]

print('W среднее время ожидания заявки в сети = ' + W_srednee.__str__())

U_srednee = 0
for i in range(Alpha.__len__()):
    U_srednee+= Alpha[i]*U[i]

print('U среднее время пребывания заявки в сети = ' + U_srednee.__str__())
'''


lambda0 = 0.2
lambdamas = []
alpha = [60, 40, 1]
teta = [16000, 5, 1]
k = [1, 5000, 100000]
Up = 20
Sp = 400000
Vmin = []
V = []
S = []
Sr = 0

i = 0
while i < alpha.__len__():
    lambdamas.append(lambda0*alpha[i])
    print("Lambda" + str(i + 1) + " = " + str(lambdamas[i]))
    i = i + 1

i = 0
while i < alpha.__len__():
    Vmin.append(lambda0 * alpha[i] * teta[i])
    print("V" + str(i + 1) + " = " + str(Vmin[i]))
    i = i + 1

i = 0
while i < Vmin.__len__():
    S.append(k[i] * Vmin[i])
    print("S" + str(i + 1) + " = " + str(S[i]))
    i = i + 1

i = 0
while i < alpha.__len__():
    V.append(lambda0 * alpha[i] * teta[i] + (1/(lambda0*Up))* math.sqrt(lambdamas[i]*teta[i]/k[i]) * summ1(3))
    print("V" + str(i + 1) + " = " + str(V[i]))
    i = i + 1

Sr = lambda0 * summ2(3) + (1/Up) * (summ3(3))**2
print("S = " + str(Sr))
S0 = Sr - summS()
print("S0 = " + str(S0))

Vmin = []
i = 0
while i < alpha.__len__():
    Vmin.append(lambda0 * alpha[i] * teta[i])
    print("Vmin" + str(i + 1) + " = " + str(Vmin[i]))
    i = i + 1

Smin = summSmin()
print("Smin = " + str(Smin))

S0new = Sp - Smin
print("S0 = " + str(S0new))

V2 = []
i = 0
while i < alpha.__len__():
    V2.append(lambda0 * alpha[i] * teta[i] + (Sp/k[i])*(math.sqrt(k[i] * alpha[i] * teta[i]) / summSQRT()))
    print("V" + str(i + 1) + " для нового S*" + " = " + str(V2[i]))
    i = i + 1

Ur = (1/S0new) * (summSQRT())**2
print("U = " + str(Ur))

def summSQR():
    i = 0
    S = 0
    while i < alpha.__len__():
        S += math.sqrt(k[i] * teta[i] * alpha[i])
        i = i + 1
    return S**2


print('Данные для таблицы: ')
i = 0
iС, dС = divmod(Sr, 1)
St = iС
print("S = " + str(St))
deltaS = int(round(St / 100))
print("dS = " + str(deltaS))
print()
print("N;U;dU;S;dS")
deltaU = 0
while i < 61:
    Ut = (1 / (St - Smin)) * summSQR()
    if (i == 0):
    #    print(str(i) + ";" + str(round(Ut, 0)) + ";" + str(deltaU) +
            #  ";" + str(St) + ";" + str(deltaS))
    #    print(str(St))
    #    print(str(round(Ut, 0)))
       print(str(deltaU))
    else:
    #    print(str(i) + ";" + str(round(Ut, 6)) + ";" + str(round((deltaU - Ut),6)) +
            #   ";" + str(round(St)) + ";" + str(round(deltaS, 6)))
    #    print(str(round(St)))
    #    print(str(round(Ut, 6)))
        print(str(round((deltaU - Ut),6)))
    deltaU = Ut
    St = St + deltaS
    i = i + 1

print()
print("Точки для графика - S = f(U*)")
Spoint1 = []
xPoint1 = []
yPoint1 = []
i = 1
while i < 36:
    Spoint1.append([])
    xPoint1.append(i)
    yPoint1.append(round(Sr + S0*Up/i))
    Spoint1[i - 1].append(i)
    Spoint1[i - 1].append(round(Sr + S0*Up/i))
    i = i + 1

print(Spoint1)
print()
i = 0
while i < xPoint1.__len__():
    print(xPoint1[i])
    i = i + 1

print()
i = 0
while i < yPoint1.__len__():
    print(yPoint1[i])
    i = i + 1

print()
print("Точки для графика - U = f(S*)")
Spoint2 = []
xPoint2 = []
yPoint2 = []

#круглое значение больше Smin
i = 700000
while i < 4000000:
    xPoint2.append(i)
    Uq = (1/(i - Smin)) * summSQR()
    yPoint2.append(round(Uq))
    i = i + 100000

print()
i = 0
while i < yPoint2.__len__():
    print(yPoint2[i])
    i = i + 1

print()
i = 0
while i < xPoint2.__len__():
    print(xPoint2[i])
    i = i + 1



'''lambda0 = 0.4
alpha = [100, 10, 1]
teta = [100, 1, 5]
k = [1, 50]
Vmin = []
i = 0
while i < alpha.__len__():
    Vmin.append(lambda0 * alpha[i] * teta[i])
    print("Vmin" + str(i + 1) + " = " + str(Vmin[i]))
    i = i + 1'''