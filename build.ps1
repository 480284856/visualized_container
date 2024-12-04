# Check if Docker Desktop is running
$dockerProcess = Get-Process "*docker desktop*" -ErrorAction SilentlyContinue
if (-not $dockerProcess) {
    Write-Host "Docker Desktop is not running. Please start Docker Desktop first."
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Write-Host "Waiting for Docker to start..."
    Start-Sleep -Seconds 20
}

# Test Docker connection
$dockerRunning = $false
try {
    $null = docker ps
    $dockerRunning = $true
} catch {
    $dockerRunning = $false
}

if (-not $dockerRunning) {
    Write-Host "Error: Docker is not responding. Please make sure Docker Desktop is running properly."
    exit 1
}

# Stop and remove old container if exists
if (docker ps -a | Select-String "visualized_desktop") {
    Write-Host "Stopping and removing old container..."
    docker-compose down
}

# Build and start new container
Write-Host "Building and starting container..."
docker-compose up -d --build

# Wait for container to start
Start-Sleep -Seconds 5

# Show container status
Write-Host "`nContainer status:"
docker ps | Select-String "visualized_desktop"

# Show access information
Write-Host "`nBuild complete!"
Write-Host "Please visit: http://localhost:6080"
Write-Host "password: 123123"
Write-Host "Shared folder location: $((Get-Location).Path)\shared"