# import time
import math
import matplotlib.pyplot as plt
out = my_input = [] 
task = open("task3.txt", "r")
# file = open("uot.txt", "w")
lines = task.readlines()
for line in lines:
    vals = line.split(' ')
    x = int(vals[0])
    y = int(vals[1])
    z = int(vals[2])
    # volume = (x ** 2) + (y ** 2) + (z ** 2)
    # volume = math.log(x + y + z) ** 2
    volume = x + y + z
    # file.write(f'{volume}\n')
    print(volume)
    out.append(volume) 


task.close()
# file.close()
plt.plot(out)
plt.show()
