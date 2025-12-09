#!/bin/bash

# 日志文件路径
LOG_FILE="/root/javanet/server.log"

echo "正在停止服务器..."
pkill -f "tomcat7:run" 2>/dev/null
sleep 3

echo "正在清理并重新编译..."
mvn clean package

if [ $? -ne 0 ]; then
    echo "编译失败，请检查错误信息"
    exit 1
fi

echo "正在后台启动服务器..."
# 使用 nohup 在后台运行，即使SSH断开也会继续运行
nohup mvn tomcat7:run > "$LOG_FILE" 2>&1 &

# 获取进程ID
PID=$!
echo $PID > /root/javanet/server.pid

echo "=========================================="
echo "服务器已在后台启动！"
echo "进程ID: $PID"
echo "日志文件: $LOG_FILE"
echo ""
echo "常用命令："
echo "  查看日志: tail -f $LOG_FILE"
echo "  停止服务: pkill -f 'tomcat7:run'"
echo "  查看状态: ps aux | grep tomcat7"
echo "=========================================="

# 等待几秒检查服务是否启动成功
sleep 5
if ps -p $PID > /dev/null 2>&1; then
    echo "✓ 服务器启动成功，正在运行中..."
else
    echo "✗ 服务器启动失败，请查看日志: $LOG_FILE"
    exit 1
fi