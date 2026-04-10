param(
  [string]$Path = (Get-Location).Path,
  [switch]$Run
)

# Resolve path
try {
  $projPath = (Resolve-Path -Path $Path).Path
} catch {
  Write-Error "Path not found: $Path"
  exit 1
}

Write-Host "Project path:" $projPath

$winWrapper = Join-Path $projPath 'gradlew.bat'
$unixWrapper = Join-Path $projPath 'gradlew'

if (Test-Path $winWrapper) {
  Write-Host "Found Windows Gradle wrapper: gradlew.bat"
  Push-Location $projPath
  & $winWrapper clean build
  if ($LASTEXITCODE -ne 0) { Write-Error "Build failed (gradlew.bat)"; Pop-Location; exit $LASTEXITCODE }
  if ($Run) {
    Write-Host "Running project using 'gradlew.bat run' (if a run task exists)"
    & $winWrapper run
  }
  Pop-Location
  exit $LASTEXITCODE
}

if (Test-Path $unixWrapper) {
  Write-Host "Found Unix Gradle wrapper (gradlew). Attempting to run via WSL..."
  # Try to convert Windows path to WSL path and run inside WSL
  $wslPath = $null
  try {
    $wslPath = wsl wslpath -a $projPath 2>$null
    $wslPath = $wslPath.Trim()
  } catch {}
  if ($wslPath) {
    Write-Host "WSL path:" $wslPath
    $cmd = "cd '$wslPath' && ./gradlew clean build"
    if ($Run) { $cmd = $cmd + " && ./gradlew run" }
    wsl bash -lc $cmd
    exit $LASTEXITCODE
  } else {
    Write-Host "WSL not available. Open Git Bash (or WSL) and run:"
    Write-Host "  cd '$projPath'"
    Write-Host "  ./gradlew clean build"
    if ($Run) { Write-Host "  ./gradlew run" }
    exit 1
  }
}

Write-Host "No Gradle wrapper found in $projPath."
Write-Host "Options:"
Write-Host " - If you have Gradle installed, run: gradle wrapper (to create the wrappers), then re-run the script."
Write-Host " - Or open Git Bash/WSL and run ./gradlew if a Unix wrapper is present elsewhere."
exit 1
