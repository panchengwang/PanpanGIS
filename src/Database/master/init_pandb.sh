#!/bin/sh

# 初始化数据库
CUR_DIR=$(cd $(dirname $0); pwd)

#创建控制节点数据库
MASTERDB=pan_master_db
dropdb $MASTERDB
createdb $MASTERDB
cat $CUR_DIR/miscellaneous.sql > pan_master_db.sql
cat $CUR_DIR/configuration.sql >>  pan_master_db.sql
cat $CUR_DIR/user.sql >>  pan_master_db.sql
cat $CUR_DIR/server.sql >> pan_master_db.sql

psql -d $MASTERDB -f pan_master_db.sql

