#!/bin/bash

echo -----"系统监控脚本1.0"-----
echo ------ "YanhLi-tran"-------

echo "当前用户：$(whoami)"
echo "主机名：$(hostname)"
echo "内核版本：$(uname -r)"
echo "当前时间为：$(date "+%Y-%m-%d %H:%M:%S")"
echo --------------------------
echo "CPU使用率(TOP5)："
ps -eo pid,ppid,pcpu,cmd | sort -k 3 -r | head -6
echo
echo -e "内存使用情况："
free -h
echo
echo "磁盘使用情况："
df -h
echo
echo "监控完成！"


