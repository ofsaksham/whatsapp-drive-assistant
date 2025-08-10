# WhatsApp-Driven Google Drive Assistant Setup Script
# This script helps you set up the n8n workflow with Docker and ngrok

Write-Host "WhatsApp-Driven Google Drive Assistant Setup" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green

# Check if Docker is running
Write-Host "`nChecking Docker status..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "Docker is installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "Docker is not installed or not running" -ForegroundColor Red
    Write-Host "Please install Docker Desktop and start it first" -ForegroundColor Red
    exit 1
}

# Check if ngrok is installed
Write-Host "`nChecking ngrok installation..." -ForegroundColor Yellow
try {
    $ngrokVersion = ngrok version
    Write-Host "ngrok is installed: $ngrokVersion" -ForegroundColor Green
} catch {
    Write-Host "ngrok is not installed" -ForegroundColor Red
    Write-Host "Please install ngrok from https://ngrok.com/download" -ForegroundColor Red
    exit 1
}

# Check if .env file exists
Write-Host "`nChecking environment configuration..." -ForegroundColor Yellow
if (Test-Path ".env") {
    Write-Host ".env file found" -ForegroundColor Green
} else {
    Write-Host ".env file not found" -ForegroundColor Yellow
    Write-Host "Please copy env.example to .env and configure your credentials" -ForegroundColor Yellow
    if (Test-Path "env.example") {
        Copy-Item "env.example" ".env"
        Write-Host "Created .env file from env.example" -ForegroundColor Green
        Write-Host "Please edit .env file with your actual credentials" -ForegroundColor Yellow
    }
}

# Check if workflow.json exists
Write-Host "`nChecking workflow file..." -ForegroundColor Yellow
if (Test-Path "workflow.json") {
    Write-Host "workflow.json found" -ForegroundColor Green
} else {
    Write-Host "workflow.json not found" -ForegroundColor Red
    Write-Host "Please ensure workflow.json is in the current directory" -ForegroundColor Red
    exit 1
}

# Start n8n container
Write-Host "`nStarting n8n container..." -ForegroundColor Yellow
Write-Host "This will start n8n on http://localhost:5678" -ForegroundColor Cyan

$containerName = "n8n-whatsapp-drive"
$port = "5678:5678"
$volume = "${PWD}/.n8n:/home/node/.n8n"

# Stop existing container if running
Write-Host "Stopping existing container if running..." -ForegroundColor Gray
docker stop $containerName 2>$null
docker rm $containerName 2>$null

# Start new container
Write-Host "Starting n8n container..." -ForegroundColor Gray
docker run -d --name $containerName -p $port -v $volume --env-file .env n8nio/n8n

if ($LASTEXITCODE -eq 0) {
    Write-Host "n8n container started successfully" -ForegroundColor Green
    Write-Host "n8n will be available at: http://localhost:5678" -ForegroundColor Cyan
} else {
    Write-Host "Failed to start n8n container" -ForegroundColor Red
    exit 1
}

# Wait for n8n to start
Write-Host "`nWaiting for n8n to start (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Start ngrok
Write-Host "`nStarting ngrok tunnel..." -ForegroundColor Yellow
Write-Host "This will create a public URL for your webhook" -ForegroundColor Cyan

# Start ngrok in background
Start-Process -FilePath "ngrok" -ArgumentList "http 5678" -WindowStyle Minimized

Write-Host "ngrok started in background" -ForegroundColor Green
Write-Host "Check ngrok dashboard at: http://127.0.0.1:4040" -ForegroundColor Cyan

# Final instructions
Write-Host "`nSetup Complete!" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Open n8n at: http://localhost:5678" -ForegroundColor Cyan
Write-Host "2. Import workflow.json into n8n" -ForegroundColor Cyan
Write-Host "3. Configure your credentials (Google Drive, Twilio)" -ForegroundColor Cyan
Write-Host "4. Get your ngrok URL from: http://127.0.0.1:4040" -ForegroundColor Cyan
Write-Host "5. Update Twilio webhook URL with your ngrok URL" -ForegroundColor Cyan
Write-Host "6. Test with WhatsApp commands!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "- Stop n8n: docker stop $containerName" -ForegroundColor Gray
Write-Host "- View logs: docker logs $containerName" -ForegroundColor Gray
Write-Host "- Restart: docker restart $containerName" -ForegroundColor Gray
Write-Host ""
Write-Host "Happy automating!" -ForegroundColor Green
