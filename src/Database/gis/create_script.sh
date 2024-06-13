#!/bin/sh

# 初始化数据库


# 当前目录
CUR_DIR=$(cd $(dirname $0); pwd)
INSTALL_SQL_NAME=install.sql

# 生成安装脚本，注意下面命令的先后顺序
cat ${CUR_DIR}/../shared/tables.sql > ${CUR_DIR}/${INSTALL_SQL_NAME}
cat ${CUR_DIR}/../shared/miscellaneous.sql >> ${CUR_DIR}/${INSTALL_SQL_NAME}
cat ${CUR_DIR}/../shared/configuration.sql >>  ${CUR_DIR}/${INSTALL_SQL_NAME}
cat ${CUR_DIR}/../shared/server.sql >> ${CUR_DIR}/${INSTALL_SQL_NAME}
cat ${CUR_DIR}/../shared/user.sql >>  ${CUR_DIR}/${INSTALL_SQL_NAME}
cat ${CUR_DIR}/../shared/service.sql >> ${CUR_DIR}/${INSTALL_SQL_NAME}
cat ${CUR_DIR}/catalog.sql >> ${CUR_DIR}/${INSTALL_SQL_NAME}



