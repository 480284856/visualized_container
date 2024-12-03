
#!/bin/bash

source /opt/visualized/env.sh

export USER=root
export HOME=/root

# 删除可能存在的旧锁文件
rm -rf /tmp/.X*
rm -rf /tmp/.X11-unix
rm -rf /root/.vnc/*.pid
rm -rf /root/.vnc/*.log

# 启动 VNC 服务器
vncserver :1 -geometry 3840x2160 -depth 24

# 等待 X 服务器启动
sleep 5

# 设置 DISPLAY 环境变量
export DISPLAY=:1

# 使用 gtf 生成新的模式行
MODELINE=$(gtf 3840 2160 60 | grep -oP '(?<=Modeline ).*')

# 从 MODELINE 提取模式名称
MODENAME=$(echo $MODELINE | awk '{print $1}' | tr -d '"')

# 添加新模式
xrandr --newmode $MODELINE

# 获取当前输出名称，可能是 "Xvnc1"
OUTPUT=$(xrandr | grep " connected" | awk '{print $1}')

# 将新模式添加到输出设备
xrandr --addmode $OUTPUT $MODENAME

# 设置输出设备使用新模式
xrandr --output $OUTPUT --mode $MODENAME

# 启动 websockify，将 VNC 流量转发到 noVNC
websockify --web=/opt/novnc --wrap-mode=ignore 6080 localhost:5901