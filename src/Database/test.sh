#!/bin/sh


CUR_DIR=$(cd $(dirname $0); pwd)

echo "创建控制节点数据库"
cd master
sh create_script.sh

MASTERDB=pan_master_db
dropdb $MASTERDB
createdb $MASTERDB
psql -d $MASTERDB -f install.sql


echo "创建gis服务节点数据库"
cd ..
cd gis
sh create_script.sh

GISDB=pan_gis_db
dropdb $GISDB
createdb $GISDB
psql -d $GISDB -f install.sql


cd ..
psql -d $MASTERDB -f test.sql
