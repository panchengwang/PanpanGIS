#!/bin/sh

VERSION=1.0


PG_SRC_PATH=/d/software/sdb/postgresql-16.0
rm -rf $PG_SRC_PATH/contrib/sqlcarto
mkdir $PG_SRC_PATH/contrib/sqlcarto
cp -rf ../sqlcarto/*  $PG_SRC_PATH/contrib/sqlcarto
cd $PG_SRC_PATH/contrib/sqlcarto
make

SQL_FILE=sqlcarto--${VERSION}.sql
cat ./sqlcarto.sql > $SQL_FILE
cat ./email.sql >> $SQL_FILE

make install
./test.sh