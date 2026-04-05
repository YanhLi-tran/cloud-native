#!/bin/bash

clear
echo ===========================
echo "      MySQL安装脚本"
echo ===========================

echo "1.安装依赖"
yum install -y libaio-devel numactl &>/dev/null

echo "2.创建用户"
useradd -r -s /sbin/nologin mysql 2>/dev/null

echo "3.创建安装目录和数据目录"
mkdir -p /usr/local/mysql
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql

echo "4.解压MySQL"
tar -Jxf mysql-8.4.8-linux-glibc2.28-x86_64.tar.xz -C /usr/local/mysql --strip-components 1

echo "5.写入配置文件"
cat > /etc/my.cnf << EOF
[mysqld]
datadir=/data/mysql
socket=/tmp/mysql.sock
user=mysql
port=3306
log-error=/data/mysql/mysql.log
pid-file=/data/mysql/mysql.pid
character-set-server=utf8mb4
lower_case_table_names=1
EOF

echo "6. 初始化MySQL"
/usr/local/mysql/bin/mysqld --initialize --user=mysql

echo "========================================"
echo " 安装完成！你的临时密码是："
grep "temporary password" /data/mysql/mysql.log
echo "========================================"
