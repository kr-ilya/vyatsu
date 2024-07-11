import os, random

def nextInt():
	return random.randrange(-100000, 100000)

def gen():
	global next
	name = ("0" + str(next))[-2:]
	f = open(name + ".in", "w")
	f.write(str(a[next - 1]) + "\n")
	for i in range(a[next - 1]):
		f.write(str(nextInt()) + " ")
	f.write("\n")	
	f.close()
	os.system("java solver < " + name + ".in > " + name + ".out")
	next = next + 1

def genA():
	global next
	name = ("0" + str(next))[-2:]
	f = open(name + ".in", "w")
	f.write(str(a[next - 1]) + "\n")
	for i in range(a[next - 1]):
		f.write(str(i + 1) + " ")
	f.write("\n")	
	f.close()
	os.system("java solver < " + name + ".in > " + name + ".out")
	next = next + 1

def genD():
	global next
	name = ("0" + str(next))[-2:]
	f = open(name + ".in", "w")
	f.write(str(a[next - 1]) + "\n")
	for i in range(a[next - 1]):
		f.write(str(a[next - 1] - i) + " ")
	f.write("\n")	
	f.close()
	os.system("java solver < " + name + ".in > " + name + ".out")
	next = next + 1

a, b, next = [10, 10, 20, 30, 40, 1000, 948, 831, 861, 319, 1000, 1000], [2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2], 1
random.seed(47141561)
os.system("javac solver.java")
for i in range(len(a)):
	if b[i] == 0:
		gen()
	elif b[i] == 1:
		genA()
	else:
		genD()
#os.remove("solver.class")