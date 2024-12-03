#!/bin/bash

# 构建镜像
docker build -t visualized_container .

# 运行容器并映射端口
docker run -d -p 6080:6080 --name visualized_container visualized_container