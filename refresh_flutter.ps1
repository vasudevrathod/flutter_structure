# Flutter Project Refresh Script

Write-Host "--- Starting Flutter Maintenance ---" -ForegroundColor Cyan

# Check if pubspec.yaml exists to ensure we are in a Flutter project root
if (!(Test-Path "pubspec.yaml")) {
    Write-Host "Error: pubspec.yaml not found. Please run this script in the root of your Flutter project." -ForegroundColor Red
    exit
}

Write-Host "1. Running: flutter clean..." -ForegroundColor Yellow
flutter clean

# Check if the previous command was successful
if ($LASTEXITCODE -ne 0) {
    Write-Host "Flutter clean failed. Stopping script." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "2. Running: flutter pub get..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -eq 0) {
    Write-Host "--- Done! Project is ready. ---" -ForegroundColor Green
} else {
    Write-Host "--- 'flutter pub get' failed. Check logs above. ---" -ForegroundColor Red
}