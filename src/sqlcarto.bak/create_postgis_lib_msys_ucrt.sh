#!/bin/bash

# The dynamic library postgis-x.x.so can not be linked by using option "-l",
# we created libpostgis.so(linux) or libpostgis.a(Mac) to support sqlcarto extension.




OS=`uname`

CUR_DIR=$(cd `dirname $0`; pwd)
mkdir $CUR_DIR/libs
PGSQL=/usr/local/pgsql
POSTGIS_SRC_PATH=~/software/sdb/postgis-3.4.2

GEOS_LIBS=`geos-config --clibs` 
GEOS_LIBS_CPP=`geos-config --cclibs`
GEOS_LIBS+=" ${GEOS_LIBS_CPP}"
PROJ_LIBS=`pkg-config proj --libs`
SFCGAL_LIBS=`sfcgal-config --libs`
JSON_C_LIBS=`pkg-config json-c --libs`


gcc -shared -DPIC -o ./libs/liblwgeom.dll \
    ${POSTGIS_SRC_PATH}/liblwgeom/.libs/*.o ${POSTGIS_SRC_PATH}/deps/ryu/d2s.o \
    ${GEOS_LIBS} ${PROJ_LIBS} ${SFCGAL_LIBS} ${JSON_C_LIBS} -L${PGSQL}/lib  
sh export_static_archive_for_dll.sh ./libs/liblwgeom.dll  ./libs/liblwgeom.dll.a 

gcc -shared -DPIC -o ./libs/liblwpgcommon.dll \
    ${POSTGIS_SRC_PATH}/libpgcommon/*.o \
    ${GEOS_LIBS} ${PROJ_LIBS} ${SFCGAL_LIBS} ${JSON_C_LIBS} \
    -L${PGSQL}/lib \
    -L./libs -llwgeom \
    -lpostgres
sh export_static_archive_for_dll.sh ./libs/liblwpgcommon.dll  ./libs/liblwpgcommon.dll.a 

# gcc -shared -DPIC -o ./libs/libpostgis.dll \
#     ${PG_OBJS} \
#     ${GEOS_LIBS} ${PROJ_LIBS} ${SFCGAL_LIBS} ${JSON_C_LIBS} \
#     -L${PGSQL}/lib \
#     -L./libs -llwgeom \
#     -lpostgres
# sh export_static_archive_for_dll.sh ./libs/libpostgis.dll  ./libs/libpostgis.dll.a 
  


cp -f ./libs/liblwgeom.dll ${PGSQL}/bin/liblwgeom.dll
cp -f ./libs/liblwpgcommon.dll ${PGSQL}/bin/liblwpgcommon.dll
cp -f ./libs/libpostgis.dll ${PGSQL}/bin/libpostgis.dll

