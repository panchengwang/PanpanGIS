#!/bin/sh

DLL_FULL_NAME=$1
DLL_NAME=$(shell basename $DLL_FULL_NAME)
echo $DLL_NAME
TMPFILE=$(mktemp)
echo "LIBRARY ${DLL_NAME}" > ${TMPFILE}
dlltool ${DLL_FULL_NAME}  -z ${TMPFILE}_bak --export-all-symbols
cat ${TMPFILE}_bak >> ${TMPFILE}

dlltool -D ${DLL_FULL_NAME} -d $TMPFILE -l $2 -k

# # cp -f ${PGSQL}/lib/libpostgis-3.dll.a ${PGSQL}/bin/libpostgis-3.dll.a
# # cp -f ${PGSQL}/lib/postgis-3.dll ${PGSQL}/bin/postgis-3.dll
# # cp -f $CUR_DIR/libs/libpostgis4sqlcarto.dll.a ${PGSQL}/lib
# # cp -f $CUR_DIR/libs/libpostgis4sqlcarto.dll ${PGSQL}/bin
rm -f ${TMPFILE}_bak
rm -f ${TMPFILE}
