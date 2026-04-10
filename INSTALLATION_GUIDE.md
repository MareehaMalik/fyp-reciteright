# ReciteRight - Installation Guide

## Current Status
✅ **Backend**: Flask server is starting with Whisper model for transcription
✅ **APK Built**: Debug APK is ready at `frontend/Frontend/android/app/build/outputs/flutter-apk/app-debug.apk`

## Option 1: Install APK via ADB (Recommended if Phone Connected)

### Prerequisites
- Android phone with USB debugging enabled
- Phone connected via USB cable
- ADB (Android Debug Bridge) installed

### Steps
1. **Enable USB Debugging on Phone**:
   - Settings > Developer Options > USB Debugging (Toggle ON)
   - Allow USB debugging connection when prompted

2. **Connect Phone via USB**
   - Connect phone to computer with USB cable

3. **Install APK**:
   ```powershell
   cd F:\ReciteRight\frontend\Frontend
   & "C:\Users\hp\AppData\Local\Android\sdk\platform-tools\adb.exe" install -r android/app/build/outputs/flutter-apk/app-debug.apk
   ```

4. **Run the App**:
   ```powershell
   & "C:\Users\hp\AppData\Local\Android\sdk\platform-tools\adb.exe" shell am start -n com.example.tajweed_corrector/.MainActivity
   ```

## Option 2: Manual Installation via File Transfer

1. **Copy APK to Phone**:
   - Transfer `android/app/build/outputs/flutter-apk/app-debug.apk` to phone storage
   - Use file manager to navigate and tap the APK to install
   - Allow installation from unknown sources if prompted

2. **Run the App**:
   - Find "Tajweed Corrector" in app drawer
   - Tap to launch

## Backend Setup

### Ensure Backend is Running
The Flask backend must be running for the app to function:

```powershell
cd F:\ReciteRight\backend
python app.py
```

Expected output:
```
✓ Model loaded: 80 reference ayaat
✓ Whisper model loaded
✓ Running on http://0.0.0.0:8000
```

### Required Endpoints
- `POST /api/transcribe` - Transcribe audio with Whisper model
- Other existing endpoints for Quran data

## Network Configuration

The app expects the backend at:
- **Local Network**: `http://192.168.x.x:8000` (replace with your computer's IP)
- **Localhost**: `http://localhost:8000` (only if emulator/same device)

## Features Enabled

✅ **Display Ayah Arabic Text**
- Fetches from Quran.com API
- Shows Arabic text with translation
- Right-to-left display with proper fonts

✅ **Qari Audio Playback**
- Each Qari plays their own recitation
- Multiple Qaris available

✅ **Recording** (currently disabled due to build issues)
- Will be re-enabled after compilation fixes

✅ **Tajweed Rules**
- Color-coded Tajweed rule highlighting
- Interactive word explanations

## Troubleshooting

### "APK not installed"
- Ensure USB debugging is enabled
- Try: `adb devices` to verify phone is connected
- Check phone for permission prompts

### App crashes on startup
- Ensure backend is running on port 8000
- Check that Flask is printing "Running on..."
- Verify network connection to backend

### Audio not playing
- Check internet connection (fetches from verses.quran.com)
- Verify Qari data is loaded in backend

## Notes

- The Whisper model (tiny) is used for transcription to save memory
- All features require internet connection
- Debug APK includes development tools

