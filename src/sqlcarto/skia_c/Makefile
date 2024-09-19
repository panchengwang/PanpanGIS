LIBS = $(shell pkg-config skia --libs)
CFLAGS = $(shell pkg-config skia --cflags)
CC = g++ 
OBJS = sk_capi.o 

all:	$(OBJS)
	$(CC) -shared -o libskia_c.dll $(OBJS) $(LIBS) 
	make -C ./test 

sk_capi.o: sk_capi.cpp sk_capi.h
	$(CC) $(CFLAGS) -c $^ -DSK_CAPI_DLL_EXPORT


clean: 
	make -k -C ./test clean
	rm -f *.o 
	rm libskia_c.dll
	

run: 
	./test/test.exe 