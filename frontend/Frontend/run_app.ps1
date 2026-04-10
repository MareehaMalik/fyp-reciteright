# Build and deploy Tajweed Corrector app
# This script works around Flutter's path resolution issue with spaces in the directory name

Write-Host "Building APK..." -ForegroundColor Cyan
Push-Location android
& .\gradlew.bat assembleDebug
Pop-Location

Write-Host "Finding APK..." -ForegroundColor Cyan
$apk = (Get-ChildItem -Path "android/app/build/outputs/apk/debug/" -Filter "app-debug.apk" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1).FullName

if (-not $apk) {
    Write-Host "ERROR: APK not found!" -ForegroundColor Red
    exit 1
}

Write-Host "APK found: $apk" -ForegroundColor Green

Write-Host "Installing on device..." -ForegroundColor Cyan
$androidHome = $env:ANDROID_HOME
if (-not $androidHome) { 
    $androidHome = "$env:LOCALAPPDATA\Android\sdk" 
}

& "$androidHome\platform-tools\adb.exe" install -r $apk
if ($LASTEXITCODE -ne 0) {
    Write-Host "Installation failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Launching app..." -ForegroundColor Cyan
& "$androidHome\platform-tools\adb.exe" shell am start -n "com.example.tajweed_corrector/.MainActivity"

Write-Host "App is running!" -ForegroundColor Green
