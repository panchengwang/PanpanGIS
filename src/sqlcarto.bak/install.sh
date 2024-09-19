#!/bin/sh

VERSION=1.0

OS=`uname`

CUR_DIR=$(cd `dirname $0`; pwd)
PG_SRC_PATH=~/software/sdb/postgresql-16.4
POSTGIS_SRC_PATH=~/software/sdb/postgis-3.4.2

# rm -rf ${POSTGIS_SRC_PATH}/sqlcarto
# cp -rf ${CUR_DIR}/../sqlcarto  ${POSTGIS_SRC_PATH}

# cd ${POSTGIS_SRC_PATH}
# rm -rf extensions/postgis_sqlcarto
# mv sqlcarto/postgis_sqlcarto extensions/postgis_sqlcarto
# sh autogen.sh
# ./configure --prefix=$PGSQL --without-protobuf
# make -j 16
# make install




rm -rf $PG_SRC_PATH/contrib/sqlcarto
mkdir $PG_SRC_PATH/contrib/sqlcarto
cp -rf ${CUR_DIR}/*  $PG_SRC_PATH/contrib/sqlcarto
cd $PG_SRC_PATH/contrib/sqlcarto
make

SQL_FILE=sqlcarto--${VERSION}.sql
cat ./sqlcarto.sql > $SQL_FILE
cat ./email.sql >> $SQL_FILE
# cat ./china_proj.sql >> $SQL_FILE

make test
# make install
# ./test.sh