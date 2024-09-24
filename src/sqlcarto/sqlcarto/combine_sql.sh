#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

cat ${CUR_DIR}/sql/sqlcarto_sys.sql > ${CUR_DIR}/sqlcarto.sql.in
cat ${CUR_DIR}/sql/email.sql >> ${CUR_DIR}/sqlcarto.sql.in
cat ${CUR_DIR}/sql/china_proj.sql >> ${CUR_DIR}/sqlcarto.sql.in
cat ${CUR_DIR}/sql/canvas.sql >>  ${CUR_DIR}/sqlcarto.sql.in
cat ${CUR_DIR}/sql/symbol.sql >>  ${CUR_DIR}/sqlcarto.sql.in