from igraph import Graph
v = open('a3.txt').readlines()
file = open('task3.txt').readlines()
mx = 0
iv = 0
ves = [int(i) for i in file[1].split()]
g = Graph(edges=[[int(i.split()[0])-1, int(i.split()[1])-1] for i in v])
uvs = g.independent_vertex_sets(min=2)

for i in uvs:
    vmx = 0
    for j in i:
        vmx += ves[j]
        if(mx <= vmx):
            mx = vmx
            iv = i

print([(i+1) for i in iv])
print(mx)