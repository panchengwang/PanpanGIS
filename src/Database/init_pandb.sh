#!/bin/sh

# 初始化数据库

echo "创建用户数据库"

createdb pan_userdb
psql -d pan_userdb -f uuid.sql
psql -d pan_userdb -f user.sql
