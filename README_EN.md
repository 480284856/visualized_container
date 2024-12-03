# Visualized Container

A graphical remote desktop container based on Docker, accessible via a web browser.

## Features

- 🖥️ Supports 4K (3840x2160) resolution
- 🚀 60Hz refresh rate
- 🌐 Accessible via web browser
- 📁 Supports file sharing
- 🔒 Secure VNC connection

## Quick Start

### Windows

1. Ensure Docker Desktop is installed and running.
2. Clone this repository:
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```
3. Run the `build.ps1` script:
   ```sh
   ./build.ps1
   ```
4. Open your browser and go to `http://localhost:6080`.

### Linux / macOS

1. Ensure Docker is installed.
2. Clone this repository:
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```
3. Run the `run_container.sh` script:
   ```sh
   ./run_container.sh
   ```
4. Open your browser and go to `http://localhost:6080`.

## File Structure

- `config/vnc/xstartup`: VNC startup script.
- `docker-compose.yaml`: Docker Compose configuration file.
- `Dockerfile`: Docker image build file.
- `scripts/start.sh`: Container startup script.
- `shared/`: Shared folder (needs to be created in the project root directory).
- `start.sh`: Container startup script.

## Contributing

Feel free to submit issues and contribute code!

## License

This project is licensed under the MIT License.