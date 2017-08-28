# makefile

CC=gcc
CXX=g++
RM=rm -f
CPPFLAGS=-g
LDFLAGS=-g -fpack-struct=1
LDLIBS=
AR=ar

SRCS=main.cpp binlog.h
# OBJS=$(subst .cpp, .o, $(SRCS))

PROJECT=main

main: $(SRCS)
	$(CXX) $(LDFLAGS) -o $(PROJECT) -L. $(LDLIBS) $(SRCS)
clean:
	$(RM) $(PROJECT)
all-clean: clean
	$(RM) $(PROJECT)
