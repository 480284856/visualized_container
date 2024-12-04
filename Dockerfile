ARG BASE_IMAGE=ubuntu:20.04
FROM $BASE_IMAGE

# 环境变量设置
ENV DEBIAN_FRONTEND=noninteractive \
    USER=amos \
    HOME=/home/amos \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=6080 \
    VNC_RESOLUTION=3840x2160 \
    VNC_COL_DEPTH=24 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# 系统配置和基础包安装
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && \
    # 安装基础工具
    apt-get install -y --no-install-recommends \
        sudo \
        git \
        curl \
        wget \
        unzip \
        vim \
        net-tools \
        iputils-ping \
        htop \
        neofetch \
        dos2unix \
        # 语言和字体支持
        language-pack-en \
        locales \
        fonts-noto-cjk \
        fonts-wqy-microhei \
        xfonts-base \
        xfonts-75dpi \
        xfonts-100dpi \
        xfonts-scalable \
        # 桌面环境
        xfce4 \
        xfce4-goodies \
        dbus-x11 \
        # 远程访问
        tightvncserver \
        xterm \
        x11-xserver-utils \
        xrdp \
        python3-websockify \
        novnc \
        # 音频支持
        pulseaudio \
        pavucontrol \
        xfce4-pulseaudio-plugin \
        # 浏览器
        firefox \
        chromium-browser \
        # FUSE支持
        fuse \
        libfuse2 \
        # 图形支持
        mesa-utils \
        xserver-xorg-video-dummy \
        xserver-xorg-video-fbdev \
        # 运行cursor的依赖
        libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss-dev && \
    # 清理apt缓存
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 配置语言环境
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# 创建并配置用户
RUN useradd -m -s /bin/bash amos && \
    echo "amos:123123" | chpasswd && \
    adduser amos sudo && \
    echo "amos ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 配置 noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# 配置用户环境
RUN mkdir -p /home/amos/.vnc && \
    mkdir -p /home/amos/.config/xfce4/xfconf/xfce-perchannel-xml && \
    echo "123123" | vncpasswd -f > /home/amos/.vnc/passwd && \
    chmod 600 /home/amos/.vnc/passwd && \
    touch /home/amos/.Xresources && \
    echo "startxfce4" > /etc/skel/.xsession && \
    cp /etc/skel/.xsession /home/amos/.xsession && \
    # XFCE4性能优化
    echo '<?xml version="1.0" encoding="UTF-8"?><channel name="xfwm4" version="1.0"><property name="general" type="empty"><property name="use_compositing" type="bool" value="false"/></property></channel>' > /home/amos/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml && \
    # FUSE配置
    echo "user_allow_other" > /etc/fuse.conf && \
    chmod 644 /etc/fuse.conf && \
    modprobe fuse || true && \
    # 设置正确的所有权
    chown -R amos:amos /home/amos

# 设置VNC密码
RUN mkdir -p /home/amos/.vnc && \
    echo "123123" | vncpasswd -f > /home/amos/.vnc/passwd && \
    chmod 600 /home/amos/.vnc/passwd && \
    chown amos:amos /home/amos/.vnc/passwd

# 复制并配置启动脚本
COPY scripts/start.sh /opt/visualized/
COPY config/vnc/xstartup /home/amos/.vnc/
RUN dos2unix /opt/visualized/start.sh && \
    chmod +x /opt/visualized/start.sh && \
    chown -R amos:amos /home/amos/.vnc

# 设置工作目录并切换用户
WORKDIR /home/amos
USER amos

# 暴露端口
EXPOSE 3389 5901 6080

# 启动命令
ENTRYPOINT ["/opt/visualized/start.sh"]
