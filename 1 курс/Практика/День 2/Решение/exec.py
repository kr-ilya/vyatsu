import os
import subprocess
import time
import matplotlib.pyplot as plt
out = my_input = [] 
task = open("task2.txt", "r")
lines = task.readlines()
for line in lines:
    
    if os.path.isfile('input.txt'):
        os.remove('input.txt')
    file = open("input.txt", "w")
    file.write(line)
    file.close() 
    start_time = time.time()
    subprocess.call(('./program2.exe'))
    out.append((time.time() - start_time)) 
    print("--- %s seconds ---" % (time.time() - start_time))
task.close()
plt.plot(out)
plt.show()
# print(out)
