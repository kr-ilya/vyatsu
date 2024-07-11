from igraph import *
v = open('a1.txt').readlines()
g = Graph(edges=[[int(i.split()[0])-1, int(i.split()[1])-1] for i in v])
plot(g, vertex_label=[i for i in range(1, 21)])