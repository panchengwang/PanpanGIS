#!/bin/sh

# 初始化数据库

echo "创建用户数据库"
MASTERDB=pan_master_db
dropdb $MASTERDB
createdb $MASTERDB
psql -d $MASTERDB -f miscellaneous.sql
psql -d $MASTERDB -f uuid.sql
psql -d $MASTERDB -f user.sql
