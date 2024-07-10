all: build

build:
	clang++ ./main.cpp \
	-I "C:\Program Files (x86)\Microsoft SDKs\MPI\Include" \
	-I "C:\Program Files (x86)\Microsoft SDKs\MPI\Include\x64" \
	-L "C:\Program Files (x86)\Microsoft SDKs\MPI\Lib\x64" \
	-l msmpi.lib \
	-O2 \
	-o main.exe

run:
	mpiexec -n 4 ./main.exe 2000

