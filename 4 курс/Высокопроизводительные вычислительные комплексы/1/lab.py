from math import factorial as fact

p1 = 0.965
p2 = 0.965
p3 = 0.9

t1_n_cpu = 1
t1_n_mem = 6
t1_n_io = 2

t4_reserve_mem = 1
t4_reserve_io = 1

t5_reserve_mem = 2
t5_reserve_io = 2

def f(p, n, q):
    return 1 - (1  - p ** n) ** q

def c_m_n(m, n):
    return fact(n) / (fact(m) * fact(n - m))

def p_m_n(m, n, p):
    return c_m_n(m, n) * (p ** m) * ((1 - p) ** (n - m))

def r_m_n(m, n, p):
    return 1 - sum(p_m_n(i, n, p) for i in range(0, m))

task1 = p1 ** t1_n_cpu * p2 ** t1_n_mem * p3 ** t1_n_io
print(round(task1, 6))

task2 = f(p1, t1_n_cpu, 2) * f(p2, t1_n_mem, 2) * f(p3, t1_n_io, 2)
print(round(task2, 6))

task3 = f(p1, t1_n_cpu, 3) * f(p2, t1_n_mem, 3) * f(p3, t1_n_io, 3)
print(round(task3, 7))

task4 = p1 ** 2 * r_m_n(t1_n_mem, t1_n_mem + t4_reserve_mem, p2) * r_m_n(t1_n_io, t1_n_io+t4_reserve_io, p3)
print(round(task4, 6))

task5 = p1 ** 2 * r_m_n(t1_n_mem, t1_n_mem + t5_reserve_mem, p2) * r_m_n(t1_n_io, t1_n_io+t5_reserve_io, p3)
print(round(task5, 6))

task6 = p1 ** 2 * r_m_n(t1_n_mem, t1_n_mem + t1_n_mem, p2) * r_m_n(t1_n_io, t1_n_io+t1_n_io, p3)
print(round(task6, 6))