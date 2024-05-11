# contrib/sqlcarto/Makefile

MODULE_big = sqlcarto
OBJS = email.o

EXTENSION = sqlcarto
DATA = sqlcarto--1.0.sql

EXTRA_CLEAN = 

HEADERS =

REGRESS =

POSTGIS_PATH = 
PG_CPPFLAGS = \
	-DPIC 


ifeq ($(shell uname),Darwin)
	SHLIB_LINK_F = 
		
endif
ifeq ($(shell uname),Linux)
		SHLIB_LINK_F = 
endif

SHLIB_LINK := $(SHLIB_LINK_F) $(SHLIB_LINK)



ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/sqlcarto
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif



distprep:

maintainer-clean:


test:
	echo $(SHLIB_LINK_F)