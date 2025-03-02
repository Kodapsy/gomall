#!/bin/bash

# 进入项目根目录
cd /home/dobu/project/gomall

# Step 1. 启动 Docker 基础设施
echo "🚀 Starting Docker infrastructure..."
docker-compose up -d

# 等待 10 秒确保容器就绪
echo "⏳ Waiting for containers to initialize..."
sleep 10

# Step 2. 启动所有微服务（后台运行）
services=(
    "app/user"
    "app/product"
    "app/cart"
    "app/order"
    "app/payment"
    "app/checkout"
    "app/email"
)

echo "🔧 Building and starting microservices..."
pids=()
for service in "${services[@]}"; do
    echo "🛠️  Starting $service..."
    cd "$service" && go run . &
    pids+=($!)
    cd - > /dev/null
done

# Step 3. 启动前端服务（前台运行）
echo "🌐 Starting frontend service..."
cd app/frontend
go run main.go

# 捕获 Ctrl+C 信号
trap "cleanup" SIGINT

cleanup() {
    echo "🛑 Stopping all services..."
    # 停止前端服务
    kill -9 %1
    # 停止微服务
    for pid in "${pids[@]}"; do
        kill -9 $pid
    done
    # 停止 Docker 容器
    docker-compose down
    exit 0
}

# 保持脚本运行
wait