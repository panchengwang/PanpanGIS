LIBS = $(shell pkg-config skia --libs)
CFLAGS = $(shell pkg-config skia --cflags)
CC = g++ 
OBJS = sk_capi.o 
CUR_DIR = $(shell pwd)
PGSQL = $(shell pg_config --bindir)/..
EXE_SUFFIX =
DLL_SUFFIX = 
OS=$(shell uname | awk '{split($$0,str,"_"); print str[1]}')
ifeq '$(OS)' "MINGW64" 
	EXE_SUFFIX = .exe
	DLL_SUFFIX = .dll
else ifeq '$(OS)' "Linux" 
	EXE_SUFFIX = 
	DLL_SUFFIX = .so	
endif  


all:	$(OBJS)
	$(CC) -shared -o libskia_c$(DLL_SUFFIX) $(OBJS) $(LIBS) 
	make -C ./test 

sk_capi.o: sk_capi.cpp sk_capi.h
	$(CC) $(CFLAGS) -c $^ -DSK_CAPI_DLL_EXPORT


clean: 
	make -k -C ./test clean
	rm -f *.o 
	rm libskia_c$(DLL_SUFFIX)
	
install:
	cp -f $(CUR_DIR)/libskia_c$(DLL_SUFFIX) `pg_config --bindir`
	cp -f $(CUR_DIR)/sk_capi.h `pg_config --includedir` 

run: 
	$(CUR_DIR)/test/test.exe 