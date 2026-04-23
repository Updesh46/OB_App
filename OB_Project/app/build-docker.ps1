# Docker Build Script for OB App (PowerShell)
# Run this script from the app directory

param(
    [string]$ImageName = "obapp",
    [string]$Tag = "latest"
)

$FullImage = "$ImageName`:$Tag"

Write-Host "🐳 Building multi-stage Docker image for OB App..." -ForegroundColor Green
Write-Host "📦 Image: $FullImage" -ForegroundColor Yellow
Write-Host ""

try {
    # Build the image
    docker build -t $FullImage .

    Write-Host "✅ Build completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 To run the container:" -ForegroundColor Cyan
    Write-Host "   docker run -d -p 8080:8080 --name obapp $FullImage" -ForegroundColor White
    Write-Host ""
    Write-Host "🌐 Access the application at: http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📊 To check container status:" -ForegroundColor Cyan
    Write-Host "   docker ps | grep obapp" -ForegroundColor White
    Write-Host ""
    Write-Host "📝 To view logs:" -ForegroundColor Cyan
    Write-Host "   docker logs -f obapp" -ForegroundColor White
}
catch {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}