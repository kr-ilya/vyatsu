from random import randint

nums = 1000000
minn = -1000000
maxn = 1000000

out = open("test.txt", 'w')
out.write(str(nums)+"\n")
t = ' '.join([str(randint(minn, maxn)) for _ in range(nums)])
out.write(t)
out.close()