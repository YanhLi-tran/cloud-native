# MySQL 8.4.8 手动安装目录与操作速查手册

## 一、核心目录总览（永久存档）

|目录/文件路径|类型|核心用途|备注|
|---|---|---|---|
|/usr/local/mysql/|安装目录（程序根目录）|MySQL 服务端、客户端、工具等所有程序文件|脚本中 tar 解压的目标目录|
|/data/mysql/|数据目录|所有数据库、表、索引、日志等业务数据|自定义非默认目录，所有业务数据存储位置|
|/etc/my.cnf|全局配置文件|MySQL 启动参数、端口、字符集等全局配置|手动写入的核心配置文件|
|/tmp/mysql.sock|Socket 通信文件|虚拟机本地连接 MySQL 的通信文件|本地登录必须指定，外部连接不依赖|
|/data/mysql/mysql.log|错误日志文件|MySQL 运行日志、初始化日志、错误日志|排查问题核心文件|
|/data/mysql/mysql.pid|进程 PID 文件|记录 MySQL 服务进程 ID|用于启停服务|
## 二、各目录详细说明

### 1. 安装目录 /usr/local/mysql/

MySQL 程序根目录，所有二进制工具、库文件、插件均在此目录：

- **核心命令目录**：/usr/local/mysql/bin/
        

    - mysql：MySQL 客户端（登录命令）

    - mysqld：MySQL 服务端主程序

    - mysqld_safe：MySQL 安全启动脚本

    - mysqladmin：MySQL 管理工具（启停、密码重置等）

- **插件目录**：/usr/local/mysql/lib/plugin/

- **库文件目录**：/usr/local/mysql/lib/

- **头文件目录**：/usr/local/mysql/include/（编译连接用）

### 2. 数据目录 /data/mysql/

**绝对禁止删除**，所有业务数据存储位置：

- 系统数据库目录：mysql/（存储用户、权限、系统配置）

- 自定义业务数据库目录（如创建 test 库，会生成 /data/mysql/test/ 文件夹）

- InnoDB 核心文件：ibdata1、ib_logfile*（事务日志、共享表空间）

- 日志文件：mysql.log

- PID 文件：mysql.pid

### 3. 全局配置文件 /etc/my.cnf

当前生效的完整配置：

```ini
[mysqld]
# 核心路径配置
datadir=/data/mysql
socket=/tmp/mysql.sock
user=mysql
端口号port=3306

# 日志与PID配置
log-error=/data/mysql/mysql.log
pid-file=/data/mysql/mysql.pid

# 字符集与兼容性配置
character-set-server=utf8mb4
lower_case_table_names=1
```

## 三、常用操作命令速查

### 1. 登录 MySQL

```bash
# 快捷登录（已配置 alias，直接使用）
mysql

# 完整原始命令（无 alias 时使用）
/usr/local/mysql/bin/mysql -u root -p --socket=/tmp/mysql.sock
```

### 2. 启动/停止 MySQL

```bash
# 启动（指定配置文件，后台运行）
/usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/my.cnf &

# 停止（强制杀死所有 MySQL 进程）
pkill -9 mysqld
```

### 3. 远程连接配置（已完成）

```sql
-- 已执行的远程权限开通命令
CREATE USER 'root'@'%' IDENTIFIED BY '08365lyh';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

**外部连接信息**：

- 主机：虚拟机 IP

- 端口：3306

- 用户名：root

### 4. 防火墙操作（远程连接必备）

```bash
# 临时关闭防火墙
systemctl stop firewalld

# 永久关闭防火墙（开机不启动）
systemctl disable firewalld
```

### 5. 日志查看

```bash
# 实时查看 MySQL 运行日志
tail -f /data/mysql/mysql.log
```

## 四、关键注意事项

1. **数据安全**：绝对禁止删除 /data/mysql/ 目录，所有业务数据存储于此，删除会导致数据永久丢失。

2. **配置修改**：修改 /etc/my.cnf 后必须重启 MySQL 服务才能生效，禁止随意修改 datadir/socket 路径。

3. **本地连接**：虚拟机本地登录必须指定 --socket=/tmp/mysql.sock。

4. **外部连接**：外部设备（电脑、Navicat、Go 程序）通过虚拟机 IP + 3306 端口连接，不依赖本地 socket 文件。

## 五、原始安装脚本（备份）

```bash
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
