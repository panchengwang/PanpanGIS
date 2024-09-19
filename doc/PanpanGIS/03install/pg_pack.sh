#!/bin/sh

cd ~/software/sdb

PACK_DIR_PARENT=~/$(uuid)
mkdir $PACK_DIR_PARENT
PACK_DIR=$PACK_DIR_PARENT/pgsql

TMPFILE=$(mktemp)


# 将pgsql拷贝到一个单独的文件夹
cp -r $PGSQL $PACK_DIR

# 生成dll依赖库拷贝脚本
# 查找exe和dll的依赖库
ldd $PGSQL/bin/*.exe > $TMPFILE
ldd $PGSQL/lib/*.dll >> $TMPFILE
# 去除包含.exe:的行
# sed '/.exe:/d' $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
sed -i '/.exe:/d' $TMPFILE 
# 去除包含.dll:的行
# sed '/.dll:/d' $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
sed -i '/.dll:/d' $TMPFILE 
# 将形如(0x7ffc1cd30000)的字符串去除
# sed 's/(.*)//' $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
sed -i 's/(.*)//' $TMPFILE 
# 排序以便去重
sort $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
# 去重
awk '!a[$0]++' $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
# 将=>替换成空格
# sed 's/=>/ /' $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
sed -i 's/=>/ /' $TMPFILE 
# 去除签到空白字符
# sed 's/^[ \t]*/ /' $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
sed -i 's/^[ \t]*/ /' $TMPFILE 
ESCAPE_PGSQL=$(echo "$PGSQL" | sed 's/\//\\\//g')
# 去除已经包含在$PGSQL/lib中的dll库
# sed "/$ESCAPE_PGSQL/d" $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
sed -i "/$ESCAPE_PGSQL/d" $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
# 将两列互换以便生成拷贝命令
awk '{temp = $1; $1 = $2; $2 = "'$PACK_DIR/bin/'"temp; print $0}' $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
# 生成拷贝脚本
# sed 's/^/cp -r /' $TMPFILE > ${TMPFILE}_bak & rm $TMPFILE & mv ${TMPFILE}_bak $TMPFILE
sed -i 's/^/cp -r /' $TMPFILE 
# 将依赖库都拷贝至$PACK_DIR/bin目录
sh $TMPFILE
# 删除库拷贝脚本
rm -f $TMPFILE

# 打包
tar -zcvf pgsql.tar.gz -C $PACK_DIR/.. $(shell basename $PACK_DIR)
# 删除临时文件
rm -rf $PACK_DIR_PARENT