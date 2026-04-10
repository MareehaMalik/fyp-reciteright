# Script to start ReciteRight backend

Write-Host "========================================" -ForegroundColor Green
Write-Host "ReciteRight Backend - Startup" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Navigate to backend
Push-Location "F:\ReciteRight\backend"

# Check if python exists
$python = Get-Command python -ErrorAction SilentlyContinue
if ($null -eq $python) {
    Write-Host "❌ Python not found! Please install Python." -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "✅ Python found: $($python.Source)" -ForegroundColor Green
Write-Host ""

# Check for required modules
Write-Host "Checking required Python modules..." -ForegroundColor Yellow
python -c "import flask, flask_cors, librosa, numpy, sklearn, joblib, requests, faster_whisper, soundfile, noisereduce; print('✅ All modules available')" 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️ Some modules may be missing. Installing..." -ForegroundColor Yellow
    Write-Host ""

    Write-Host "Installing required packages..." -ForegroundColor Yellow
    pip install -q flask flask-cors librosa numpy scikit-learn joblib requests faster-whisper soundfile noisereduce

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Packages installed successfully!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Some packages failed to install, but continuing anyway..." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Starting Flask backend on port 8000..." -ForegroundColor Yellow
Write-Host "Access at: http://192.168.100.7:8000" -ForegroundColor Cyan
Write-Host ""

python -u app.py

Pop-Location

