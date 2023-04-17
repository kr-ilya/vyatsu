BINPATH = ${HOME}/pvm3/bin/${PVM_ARCH}

all: init master slave

init:
	mkdir -p $(BINPATH)

master:
	g++ master.cpp \
	-O2 \
	-L pvm \
	-I pvm \
	-l pvm3 \
	-std=c++17 \
	-o $(BINPATH)/master \

slave:
	g++ slave.cpp \
	-O2 \
	-L pvm \
	-I pvm \
	-l pvm3 \
	-l gpvm3 \
	-std=c++17 \
	-o $(BINPATH)/slave \
	
	