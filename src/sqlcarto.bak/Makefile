# contrib/sqlcarto/Makefile

PG_INSATLL_PATH=/usr/local/pgsql
POSTGIS_SRC_PATH=${HOME}/software/sdb/postgis-3.4.2
MODULE_big = sqlcarto
# OBJS = 	${POSTGIS_SRC_PATH}/liblwgeom/*.o  \
# 	${POSTGIS_SRC_PATH}/deps/ryu/*.o \
# 	${POSTGIS_SRC_PATH}/deps/flatgeobuf/*.o \
# 	${POSTGIS_SRC_PATH}/postgis/*.o \
# 	${POSTGIS_SRC_PATH}/libpgcommon/*.o \
# 	email.o \
# 	bytea2cstring.o \
# 	china_proj.o \
# 	china_trans.o 
OBJS = 	email.o \
	bytea2cstring.o \
	china_proj.o \
	china_trans.o


EXTENSION = sqlcarto
DATA = sqlcarto--1.0.sql

EXTRA_CLEAN = 

HEADERS =

REGRESS =

PG_INCLUDE = $(shell pg_config --includedir)
PG_LIBS = $(shell pg_config --libdir)
XML2_INCLUDE = $(shell xml2-config --cflags)
XML2_LIBS = $(shell xml2-config --libs)
WEBP_INCLUDE = $(shell pkg-config libwebp --cflags)
WEBP_LIBS = $(shell pkg-config libwebp --libs)
JSON_C_INCLUDE = $(shell pkg-config json-c --cflags)
JSON_C_LIBS = $(shell pkg-config json-c --libs)
CURL_INCLUDE = $(shell pkg-config libcurl --cflags)
CURL_LIBS = $(shell pkg-config libcurl --libs)
GEOS_INCLUDE = $(shell geos-config --cflags)
GEOS_LIBS = $(shell geos-config --clibs) $(shell geos-config --cclibs)
# GEOS_LIBS_CPP = $(shell geos-config --cclibs)
# GEOS_LIBS += " $(GEOS_LIBS_CPP)"

PROJ_LIBS = $(shell pkg-config proj --libs)
SFCGAL_LIBS = $(shell sfcgal-config --libs)
JSON_C_LIBS = $(shell pkg-config json-c --libs)
OS_PREFIX = $(shell echo ${MSYSTEM,,})

PG_CPPFLAGS += -I$(POSTGIS_SRC_PATH)/liblwgeom \
	-I$(POSTGIS_SRC_PATH)/liblwgeom \
	-I$(POSTGIS_SRC_PATH)/libpgcommon \
	-std=gnu99 -g -O2 -fno-math-errno -fno-signed-zeros -Wall  \
	-I$(PG_INCLUDE) \
	$(WEBP_INCLUDE) \
	-DLIBDEFLATE_DLL  \
	$(XML2_INCLUDE) \
	-I/ucrt64/include \
	$(JSON_C_INCLUDE)  \
	-DNDEBUG   -DDLL_EXPORT -DPIC
PG_CPPFLAGS += $(shell pkg-config libcurl --cflags)

SHLIB_LINK_F = $(POSTGIS_SRC_PATH)/libpgcommon/libpgcommon.a \
	$(POSTGIS_SRC_PATH)/liblwgeom/.libs/liblwgeom.a  \
	-L$(PG_LIBS) \
	$(GEOS_LIBS) \
	$(PROJ_LIBS) \
	$(JSON_C_LIBS) \
	-LD:/msys64/ucrt64/lib \
	-lxml2 -lz -llzma -liconv -lm -lws2_32 \
	-L/ucrt64/lib -lSFCGAL -Wl,--exclude-libs,ALL  -lm
SHLIB_LINK_F += $(shell pkg-config libcurl --libs)

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
	@echo $(SHLIB_LINK_F)
	echo $(PG_CPPFLAGS)
	
