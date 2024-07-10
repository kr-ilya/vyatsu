all: build run
	
build:
	clang++ ./main.cpp \
	./helpers.cpp \
	-v \
	-L "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\x64" \
	-l iphlpapi \
	-l setupapi \
	-o main.exe
run:
	./main.exe