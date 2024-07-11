task = open("task2.txt", "r")
lines = task.readlines()
a = int(lines[0])
ans = open("ans2d.txt", "r")
ae = ans.readlines()
good = 0
bad = 0
er = open('erlist.txt', 'w')
    
for line in ae:
    if a % int(line) != 0:
        # print('ERROR', line)
        er.writelines("%s\n" % line)
        bad += 1
    else:
        good += 1
print('Good: ', good, ' Bad: ', bad)
print('THE END')