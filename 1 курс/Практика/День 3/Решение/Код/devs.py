from sympy import divisors, divisor_count
import time

task = open("task3.txt", "r")
lines = task.readlines()
a = int(lines[0])
start_time = time.time()
divs = divisors(a)
divs_count = divisor_count(a)
print("--- %s seconds ---" % (time.time() - start_time))
# print(divs)
with open('listdivs.txt', 'w') as filehandle:  
    filehandle.writelines("%s\n" % divs_count)
    filehandle.writelines("%s\n" % div for div in divs)

task.close()