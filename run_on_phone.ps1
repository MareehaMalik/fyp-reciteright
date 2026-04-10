# Script to build and run ReciteRight on Android phone

Write-Host "========================================" -ForegroundColor Green
Write-Host "ReciteRight - Build & Deploy Script" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Get device ID
Write-Host "Checking for connected devices..." -ForegroundColor Yellow
$devices = & adb devices -l 2>&1 | Select-String "device$" | Select-Object -First 1
if ($null -eq $devices) {
    Write-Host "❌ No Android device found! Please connect your phone." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Device found: $devices" -ForegroundColor Green
$deviceId = $devices -split '\s+' | Select-Object -First 1

# Navigate to frontend
Push-Location "F:\ReciteRight\frontend\Frontend"

Write-Host ""
Write-Host "Building APK..." -ForegroundColor Yellow
flutter build apk --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ APK build failed!" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "✅ APK built successfully!" -ForegroundColor Green

# Install APK
$apkPath = ".\android\app\build\outputs\flutter-apk\app-release.apk"
if (-Not (Test-Path $apkPath)) {
    Write-Host "❌ APK not found at: $apkPath" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host ""
Write-Host "Installing APK on device: $deviceId" -ForegroundColor Yellow
& adb install -r $apkPath

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ APK installation failed!" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "✅ APK installed successfully!" -ForegroundColor Green

# Start the app
Write-Host ""
Write-Host "Launching app on device..." -ForegroundColor Yellow
& adb shell am start -n "com.tajweed_corrector/com.tajweed_corrector.MainActivity"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ App launched on your phone!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Pop-Location

