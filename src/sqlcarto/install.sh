#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

sh ${CUR_DIR}/sqlcarto/combine_sql.sh
POSTGIS_SRC_PATH=~/software/sdb/postgis-3.4.2
# cd ${POSTGIS_SRC_PATH}/../
# rm ${POSTGIS_SRC_PATH} -rf
# tar -zvxf ${POSTGIS_SRC_PATH}.tar.gz

cd ${CUR_DIR}
cp -rf * ${POSTGIS_SRC_PATH}

cd ${POSTGIS_SRC_PATH}
sh patch.sh
# ./configure --prefix=${PGSQL} --without-protobuf
make -j 32
make install