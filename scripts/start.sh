#!/bin/bash

# Initialize GNOME Keyring
if [ -n "$DESKTOP_SESSION" ]; then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

# Setup Input Method
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# Start iBus daemon
ibus-daemon -d -x

# Set up environment variables
echo '
# GNOME Keyring environment variables
if [ -n "$DESKTOP_SESSION" ]; then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
    export GTK_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export QT_IM_MODULE=ibus
fi' >> ~/.bashrc

# Make script executable
chmod +x ~/.bashrc

export USER=amos
export HOME=/home/amos

# 删除可能存在的旧锁文件
rm -rf /tmp/.X*
rm -rf /tmp/.X11-unix
rm -rf /home/amos/.vnc/*.pid
rm -rf /home/amos/.vnc/*.log

# 确保.Xauthority存在
touch $HOME/.Xauthority
chown amos:amos $HOME/.Xauthority

# 设置字体路径
FONT_PATH="/usr/share/fonts/X11/misc,/usr/share/fonts/X11/75dpi,/usr/share/fonts/X11/100dpi,/usr/share/fonts/X11/Type1"

# 创建VNC配置文件
mkdir -p $HOME/.vnc
cat > $HOME/.vnc/config << EOL
# VNC性能优化配置
geometry=3840x2160
depth=16
dpi=96
AlwaysShared=1
NeverShared=0
RemoteResize=0
FrameRate=15
UseIPv6=0
UseSHM=1
EOL

# Start iBus before starting VNC server
ibus-daemon -d -x &

# Start VNC server (your existing VNC server start command)
vncserver :1 \
    -geometry 3840x2160 \
    -depth 16 \
    -rfbauth $HOME/.vnc/passwd \
    -alwaysshared \
    -dpi 96 \
    -desktop "Amos Desktop" \
    -deferupdate 1 \
    -nolisten tcp \
    -economictranslate \
    -lazytight

# 等待 VNC 服务器启动
sleep 2

# 确保 VNC 服务器已启动
if ! ps aux | grep -v grep | grep -q Xtightvnc; then
    echo "VNC server failed to start. Check the logs for details."
    exit 1
fi

# 设置 DISPLAY 环境变量
export DISPLAY=:1

# 等待X服务器完全启动
for i in $(seq 1 10); do
    if xset q &>/dev/null; then
        break
    fi
    sleep 1
done

# 配置桌面环境性能
if xset q &>/dev/null; then
    # 禁用屏幕保护
    xset s off
    # 禁用鼠标加速
    xset m 0 0

    # 配置默认浏览器
    xdg-settings set default-web-browser firefox.desktop
    # 确保 xdg-open 可以正常工作
    dbus-launch --exit-with-session true
fi

# 启动 websockify，将 VNC 流量转发到 noVNC
websockify --web=/opt/novnc --wrap-mode=ignore --heartbeat=30 6080 localhost:5901