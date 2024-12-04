FROM ubuntu:20.04

# 环境变量设置
ENV DEBIAN_FRONTEND=noninteractive \
    USER=root \
    HOME=/root \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=6080 \
    VNC_RESOLUTION=3840x2160 \
    VNC_COL_DEPTH=24

# 使用阿里云源
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get clean && \
    apt-get update

# 安装桌面环境和必要工具
RUN apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    xterm \
    x11-xserver-utils \
    xrdp \
    git \
    python3-websockify \
    novnc \
    mesa-utils \
    dos2unix

# 配置 noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# 配置 VNC
RUN mkdir -p /root/.vnc && \
    echo "vncpass123" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    touch /root/.Xresources

# 配置 XRDP
RUN echo "startxfce4" > /etc/skel/.xsession && \
    cp /etc/skel/.xsession /root/.xsession && \
    echo 'root:your_password' | chpasswd

# 复制配置文件
COPY config/vnc/xstartup /root/.vnc/
COPY scripts/start.sh /opt/visualized/

# 处理脚本文件
RUN apt-get install -y dos2unix && \
    mkdir -p /opt/visualized && \
    dos2unix /opt/visualized/start.sh && \
    chmod +x /opt/visualized/start.sh

# 设置工作目录
WORKDIR /root

# 暴露端口
EXPOSE 3389 5901 6080

# 启动命令
ENTRYPOINT ["/opt/visualized/start.sh"]