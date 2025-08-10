# WhatsApp-Driven Google Drive Assistant Test Commands
# This script helps you test the workflow functionality

Write-Host "🧪 WhatsApp-Driven Google Drive Assistant Test Suite" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

# Check if n8n is running
Write-Host "`n🔍 Checking n8n status..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5678" -TimeoutSec 5
    Write-Host "✅ n8n is running at http://localhost:5678" -ForegroundColor Green
} catch {
    Write-Host "❌ n8n is not running" -ForegroundColor Red
    Write-Host "Please start n8n first using: .\scripts\setup.ps1" -ForegroundColor Red
    exit 1
}

# Check if ngrok is running
Write-Host "`n🌐 Checking ngrok status..." -ForegroundColor Yellow
try {
    $ngrokResponse = Invoke-WebRequest -Uri "http://127.0.0.1:4040/api/tunnels" -TimeoutSec 5
    $tunnels = $ngrokResponse.Content | ConvertFrom-Json
    if ($tunnels.tunnels.Count -gt 0) {
        $publicUrl = $tunnels.tunnels[0].public_url
        Write-Host "✅ ngrok is running" -ForegroundColor Green
        Write-Host "🌐 Public URL: $publicUrl" -ForegroundColor Cyan
    } else {
        Write-Host "⚠️  ngrok is running but no tunnels found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ ngrok is not running" -ForegroundColor Red
    Write-Host "Please start ngrok: ngrok http 5678" -ForegroundColor Red
}

# Test commands
Write-Host "`n📱 Test Commands for WhatsApp" -ForegroundColor Yellow
Write-Host "=============================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Send these commands to your Twilio WhatsApp number: +14155238886" -ForegroundColor Cyan
Write-Host ""

$testCommands = @(
    @{Command="HELP"; Description="Show available commands"},
    @{Command="LIST"; Description="List files in root folder"},
    @{Command="LIST /internpe assignment"; Description="List files in specific folder"},
    @{Command="SUMMARY /sample.pdf"; Description="Get document summary"},
    @{Command="DELETE /test.pdf CONFIRM"; Description="Delete a file (requires CONFIRM)"},
    @{Command="MOVE /file.pdf /destination CONFIRM"; Description="Move file to destination"}
)

foreach ($test in $testCommands) {
    Write-Host "📝 $($test.Command)" -ForegroundColor White
    Write-Host "   $($test.Description)" -ForegroundColor Gray
    Write-Host ""
}

# Monitoring instructions
Write-Host "📊 Monitoring Instructions" -ForegroundColor Yellow
Write-Host "=========================" -ForegroundColor Yellow
Write-Host ""
Write-Host "To monitor your workflow:" -ForegroundColor Cyan
Write-Host "1. n8n logs: docker logs n8n-whatsapp-drive" -ForegroundColor Gray
Write-Host "2. ngrok dashboard: http://127.0.0.1:4040" -ForegroundColor Gray
Write-Host "3. n8n workflow: http://localhost:5678" -ForegroundColor Gray
Write-Host "4. Twilio console: https://console.twilio.com/" -ForegroundColor Gray
Write-Host ""

# Expected responses
Write-Host "✅ Expected Responses" -ForegroundColor Yellow
Write-Host "====================" -ForegroundColor Yellow
Write-Host ""
Write-Host "HELP command should return:" -ForegroundColor Cyan
Write-Host "📱 Available Commands:" -ForegroundColor Gray
Write-Host "• LIST - List files in Google Drive" -ForegroundColor Gray
Write-Host "• DELETE /file CONFIRM - Delete a file" -ForegroundColor Gray
Write-Host "• MOVE /file /destination - Move a file" -ForegroundColor Gray
Write-Host "• SUMMARY /file - Get document summary" -ForegroundColor Gray
Write-Host ""

Write-Host "LIST command should return:" -ForegroundColor Cyan
Write-Host "📁 Files in Google Drive:" -ForegroundColor Gray
Write-Host "• [List of files and folders]" -ForegroundColor Gray
Write-Host ""

Write-Host "SUMMARY command should return:" -ForegroundColor Cyan
Write-Host "🤖 Document Summary:" -ForegroundColor Gray
Write-Host "• [AI-generated summary of the document]" -ForegroundColor Gray
Write-Host ""

# Troubleshooting tips
Write-Host "🔧 Troubleshooting Tips" -ForegroundColor Yellow
Write-Host "======================" -ForegroundColor Yellow
Write-Host ""
Write-Host "If commands don't work:" -ForegroundColor Cyan
Write-Host "1. Check Twilio daily message limit (9 messages/day)" -ForegroundColor Gray
Write-Host "2. Verify webhook URL in Twilio console" -ForegroundColor Gray
Write-Host "3. Check n8n workflow execution logs" -ForegroundColor Gray
Write-Host "4. Ensure Google Drive credentials are configured" -ForegroundColor Gray
Write-Host "5. Verify file paths exist in your Google Drive" -ForegroundColor Gray
Write-Host ""

Write-Host "🎯 Ready to test! Send a WhatsApp message to +14155238886" -ForegroundColor Green
Write-Host "Happy testing! 🚀" -ForegroundColor Green
