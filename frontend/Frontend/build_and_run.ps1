#!/usr/bin/env pwsh
# Build and run Tajweed Corrector on Android device

$projectRoot = Get-Location
$androidHome = $env:ANDROID_HOME
if (-not $androidHome) { 
    $androidHome = "$env:LOCALAPPDATA\Android\sdk" 
}

$adbPath = "$androidHome\platform-tools\adb.exe"
# Using flutter-apk path instead of apk/debug because Flutter uses this output path
$apkPath = "android\app\build\outputs\flutter-apk\app-debug.apk"
$packageName = "com.example.tajweed_corrector"
$mainActivity = "$packageName/.MainActivity"

Write-Host "🔨 Building APK with Flutter..." -ForegroundColor Cyan
flutter build apk --debug
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}

Write-Host "📱 Checking connected devices..." -ForegroundColor Cyan
$devices = & $adbPath devices | Select-String "device$"
if (-not $devices) {
    Write-Host "❌ No devices connected" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Device found: $devices" -ForegroundColor Green

Write-Host "📦 Installing APK..." -ForegroundColor Cyan
& $adbPath install -r $apkPath
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Installation failed" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 Launching app..." -ForegroundColor Cyan
& $adbPath shell am start -n $mainActivity
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to launch app" -ForegroundColor Red
    exit 1
}

Write-Host "✅ App launched successfully!" -ForegroundColor Green
Write-Host "📊 Showing logs..." -ForegroundColor Cyan
& $adbPath logcat -s "flutter" | Select-Object -First 100
