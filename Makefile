##############################################################################################################
#config begin

#compile option
CXX	:= g++
CC	:= gcc
OPT	:= -g -O0 -ggdb -Wall -Wno-deprecated -Wno-unused-function -Wno-unused-variable
AR	:= ar rc

#head file and lib file
LIBDIRS	:= /usr/local/lib ../deps/log ../deps/leveldb-1.18 /usr/lib64/mysql ../deps/mysql /usr/local/mysql5.5/lib ../deps/tinyxml
LIBS	:= pthread boost_system boost_thread protobuf leveldb boost_filesystem mysqlclient mysql zookeeper_mt zlog tinyxml
INCDIRS	:= ../deps/leveldb-1.18/include ../deps/log ../deps/tinyxml ../deps/mysql /usr/local/mysql5.5/include /usr/local/include/zookeeper ..

#define macro
MACROS	:=

#files should be solved
SRCDIRS	:= . ../base ../proto ../arc-im/auth-zookeeper
SRCEXTS	:= .cpp .cc .cxx
SRCS	:=

#target
TYPE	:= exe#(exe lib dll)
TARGET	:= arc_rec

#config end
###############################################################################################################
#calc var

ifeq ($(TYPE),dll) 
	OPT += -fPIC -shared
endif 

SOURSES	:= $(foreach d, $(SRCDIRS), $(wildcard $(addprefix $(d)/*, $(SRCEXTS))))
SOURSES	+= $(SRCS)
OBJS	:= $(foreach x, $(SRCEXTS), $(patsubst %$(x), %.o, $(filter %$(x), $(SOURSES))))

LIBDIROPT	:= $(foreach d,$(LIBDIRS),-L$(d))
LIBOPT		:= $(foreach f,$(LIBS),-l$(f))
INCOPT		:= $(foreach d,$(SRCDIRS),-I$(d))
INCOPT		+= $(foreach d,$(INCDIRS),-I$(d))

#calc var end
###############################################################################################################
all: $(TARGET)
$(TARGET):$(OBJS)
ifeq ("$(TYPE)","lib")
	$(AR) $(TARGET) $^
else
	$(CXX) $(OPT) -o $(TARGET) $^ $(LIBDIROPT) $(LIBOPT)
endif

%.o:%.c
	$(CC) $(OPT) -c $< -o $@ $(INCOPT)
%.o:%.cpp
	$(CXX) $(OPT) -c $< -o $@ $(INCOPT)
%.o:%.cc
	$(CXX) $(OPT) -c $< -o $@ $(INCOPT)
%.o:%.cxx
	$(CXX) $(OPT) -c $< -o $@ $(INCOPT)

clean:
	rm -rf $(OBJS) $(TARGET)
###############################################################################################################
