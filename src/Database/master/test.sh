#!/bin/sh


CUR_DIR=$(cd $(dirname $0); pwd)

# curl "http://127.0.0.1/MasterService/service.php"
# echo ""

# DATA=$(awk '{printf "%s",$0} END {print ""}'  ${CUR_DIR}/request/identifycode.json)
# curl -d "request=${DATA}" "http://127.0.0.1/MasterService/service.php"
# echo ""

DATA=$(awk '{printf "%s",$0} END {print ""}'  ${CUR_DIR}/request/register.json)
curl -d "request=${DATA}" "http://127.0.0.1/MasterService/service.php"
echo ""

