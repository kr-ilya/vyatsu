
# python -m pybind11 --includes

all:
	clang++ \
	-O2 \
	-std=c++17 \
	module.cpp \
	-shared \
	-I "C:\Program Files\Python39\Include" \
	-I "D:\Code\univer\rps\lab9\server\env\lib\site-packages\pybind11\include" \
	-L "c:\Program Files\Python39\libs" \
	-o fast_factorize.pyd