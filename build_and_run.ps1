# Build and run script
cd "F:\ReciteRight\frontend\Frontend"

# Clean everything
Write-Host "Cleaning build artifacts..."
rm -r -fo .dart_tool -ea 0
rm -r -fo build -ea 0
rm -r -fo .gradle -ea 0
rm pubspec.lock -ea 0

Write-Host "Getting dependencies..."
flutter pub get

Write-Host "Running app on device..."
flutter run -d 08908252CG004901

