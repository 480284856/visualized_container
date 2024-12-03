FROM ubuntu:20.04

# 设置环境变量
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
    novnc

# 安装 mesa-utils 以获取 gtf 命令
RUN apt-get install -y mesa-utils

# 下载最新的 noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# 创建 VNC 配置目录并设置密码
RUN mkdir -p /root/.vnc && \
    echo "vncpass123" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    touch /root/.Xresources

# 设置 xrdp 使用 xfce4
RUN echo "startxfce4" > /etc/skel/.xsession && \
    cp /etc/skel/.xsession /root/.xsession

# 设置 root 用户密码
RUN echo 'root:your_password' | chpasswd

# 复制配置文件
COPY config/vnc/xstartup /root/.vnc/
COPY scripts/start.sh /opt/visualized/
COPY config/env.sh /opt/visualized/

# 启动脚本
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 暴露端口
EXPOSE 3389 5901 6080
ENV USER=root
# 使用自定义启动脚本
WORKDIR /root
ENTRYPOINT ["/opt/visualized/start.sh"]