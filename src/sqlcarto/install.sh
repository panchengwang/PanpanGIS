#!/bin/sh

VERSION=1.0
SQL_FILE=sqlcarto--${VERSION}.sql
cat ./sqlcarto.sql > $SQL_FILE
cat ./email.sql >> $SQL_FILE

PG_SRC_PATH=/d/software/sdb/postgresql-16.0

mkdir $PG_SRC_PATH/contrib/sqlcarto
cp -rf ../sqlcarto/*  $PG_SRC_PATH/contrib/sqlcarto
cd $PG_SRC_PATH/contrib/sqlcarto
make
make install
./test.sh