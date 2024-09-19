#!/bin/bash

# The dynamic library postgis-x.x.so can not be linked by using option "-l",
# we created libpostgis.so(linux) or libpostgis.a(Mac) to support sqlcarto extension.




OS=`uname`

CUR_DIR=$(cd `dirname $0`; pwd)
mkdir $CUR_DIR/libs
PGSQL=/usr/local/pgsql
POSTGIS_SRC_PATH=~/software/sdb/postgis-3.4.2

# macos 
if test ${OS} = 'Darwin' ; then
  ar rcs $CUR_DIR/libs/libpostgis.a ${POSTGIS_SRC_PATH}/liblwgeom/*.o ${POSTGIS_SRC_PATH}/libpgcommon/*.o ${POSTGIS_SRC_PATH}/deps/ryu/*.o
fi

# Linux
if test ${OS} = 'Linux' ; then

  gcc -shared -o $CUR_DIR/libs/libpostgis.so ${POSTGIS_SRC_PATH}/liblwgeom/*.o ${POSTGIS_SRC_PATH}/libpgcommon/*.o ${POSTGIS_SRC_PATH}/deps/ryu/*.o
fi

# MINGW64
OS=`expr substr ${OS} 1 7`
if test ${OS} = 'MINGW64' ; then
    # gcc -shared -o ./libs/liblwgeom.dll ${POSTGIS_SRC_PATH}/liblwgeom/*.o ${POSTGIS_SRC_PATH}/deps/ryu/d2s.o  -lgeos -lgeos_c  -L/usr/local/pgsql/lib -ljson-c  -lproj -lsfcgal
    
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

    cp -f ./libs/liblwgeom.dll ${PGSQL}/bin/liblwgeom.dll
    cp -f ./libs/liblwpgcommon.dll ${PGSQL}/bin/liblwpgcommon.dll
    # rm -rf ./libs/*
#   ar rcs $CUR_DIR/libs/libpostgis4sqlcarto.a \
#     ${POSTGIS_SRC_PATH}/liblwgeom/*.o \
#     ${POSTGIS_SRC_PATH}/libpgcommon/*.o \
#     ${POSTGIS_SRC_PATH}/postgis/*.o \
#     ${POSTGIS_SRC_PATH}/deps/flatgeobuf/*.o \
#     ${POSTGIS_SRC_PATH}/deps/wagyu/*.o \
#     ${POSTGIS_SRC_PATH}/deps/ryu/*.o
  
#   gcc -shared -o $CUR_DIR/libs/libpostgis4sqlcarto.dll \
#     `geos-config --clibs` \
#     `geos-config --cclibs` \
#     `pkg-config proj --libs ` \
#     `gdal-config --libs` \
#     `pkg-config json-c --libs` \
#     `sfcgal-config --libs` \
#     -L${PGSQL}/lib -lpostgres -lpgcommon -lpgport -lpgtypes \
#     ${POSTGIS_SRC_PATH}/liblwgeom/*.o \
#     ${POSTGIS_SRC_PATH}/libpgcommon/*.o \
#     ${POSTGIS_SRC_PATH}/postgis/*.o \
#     ${POSTGIS_SRC_PATH}/deps/flatgeobuf/*.o \
#     ${POSTGIS_SRC_PATH}/deps/ryu/*.o

#   gcc -shared -o $CUR_DIR/libs/libpostgis4sqlcarto.dll \
#     ${POSTGIS_SRC_PATH}/liblwgeom/*.o ${POSTGIS_SRC_PATH}/libpgcommon/*.o ${POSTGIS_SRC_PATH}/deps/ryu/*.o \
#     -L${PGSQL}/lib ${PGSQL}/lib/libpostgres.a \
#     `geos-config --clibs` \
#     `geos-config --cclibs` \
#     `pkg-config proj --libs ` \
#     `gdal-config --libs` \
#     `pkg-config json-c --libs` \
#     `sfcgal-config --libs` 

    # TMPFILE=$(mktemp)
    # echo "LIBRARY postgis-3.dll" > ${TMPFILE}
    # dlltool ${PGSQL}/lib/postgis-3.dll  -z ${TMPFILE}_bak --export-all-symbols
    # cat ${TMPFILE}_bak >> ${TMPFILE}
    
    # dlltool -D ${PGSQL}/lib/postgis-3.dll -d $TMPFILE -l ${PGSQL}/lib/libpostgis-3.dll.a -k
    # # cp -f ${PGSQL}/lib/libpostgis-3.dll.a ${PGSQL}/bin/libpostgis-3.dll.a
    # # cp -f ${PGSQL}/lib/postgis-3.dll ${PGSQL}/bin/postgis-3.dll
    # # cp -f $CUR_DIR/libs/libpostgis4sqlcarto.dll.a ${PGSQL}/lib
    # # cp -f $CUR_DIR/libs/libpostgis4sqlcarto.dll ${PGSQL}/bin
    # rm -f ${TMPFILE}_bak
    # rm -f ${TMPFILE}
fi

ls -l $CUR_DIR/libs
