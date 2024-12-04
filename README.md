# Visualized Container

一个基于 Docker 的图形化远程桌面容器，支持通过浏览器访问。

## 特性

- 🖥️ 支持 4K (3840x2160) 分辨率
- 🚀 60Hz 刷新率
- 🌐 通过浏览器访问
- 📁 支持文件共享
- 🔒 安全的 VNC 连接

## 快速开始

### Windows

1. 确保已安装并启动 Docker Desktop。
2. 克隆本仓库：
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```
3. 运行 `build.ps1` 脚本（支持可选参数）：
   ```sh
   # 基本用法
   ./build.ps1

   # 使用自定义参数
   ./build.ps1 -BaseImage "ubuntu:22.04" -ImageName "my_image" -ContainerName "my_desktop"
   ```
4. 打开浏览器访问 `http://localhost:6080`。

### Linux / macOS

1. 确保已安装 Docker。
2. 克隆本仓库：
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```
3. 运行 `run_container.sh` 脚本（支持可选参数）：
   ```sh
   # 基本用法
   ./run_container.sh

   # 使用自定义参数（只有 ubuntu 镜像可用）
   ./run_container.sh --base-image ubuntu:22.04 --image-name my_image --container-name my_desktop
   ```
4. 打开浏览器访问 `http://localhost:6080`。

## 文件结构

- `config/vnc/xstartup`: VNC 启动脚本。
- `docker-compose.yaml`: Docker Compose 配置文件。
- `Dockerfile`: Docker 镜像构建文件。
- `scripts/start.sh`: 容器启动脚本。
- `shared/`: 共享文件夹（需要在项目根目录下创建）。
- `start.sh`: 容器启动脚本。

## 贡献

欢迎提交问题和贡献代码！

## 许可证

此项目使用 MIT 许可证。
