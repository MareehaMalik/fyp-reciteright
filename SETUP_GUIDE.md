# ReciteRight - Complete Setup Guide

## ✅ Prerequisites
- Android phone connected via USB
- USB debugging enabled on phone
- ADB installed and working
- Python 3.8+ installed on PC
- Flutter SDK installed

## 🚀 Quick Start (Both Backend & App)

### Step 1: Start Backend Server (Terminal 1)
```powershell
cd F:\ReciteRight
.\start_backend.ps1
```

**Expected Output:**
```
✅ Python found: ...
✅ All modules available
Starting Flask backend on port 8000...
 * Running on http://0.0.0.0:8000
```

**Note:** Keep this terminal open. The backend will be available at:
- **Local PC:** http://localhost:8000
- **From Phone:** http://192.168.100.7:8000 (adjust IP as needed)

### Step 2: Build & Deploy App (Terminal 2)

#### Option A: Automated (Recommended)
```powershell
cd F:\ReciteRight
.\run_on_phone.ps1
```

#### Option B: Manual
```powershell
cd F:\ReciteRight\frontend\Frontend

# Build debug APK
flutter build apk --debug

# Install on device
adb install -r build\app\outputs\flutter-apk\app-debug.apk

# Run app
adb shell am start -n "com.tajweed_corrector/com.tajweed_corrector.MainActivity"
```

---

## 📱 Phone Configuration

### 1. Update Backend IP in Flutter App
Edit: `lib/screens/EnhancedReciteScreen.dart`

Find this line (around line 302):
```dart
'http://192.168.100.7:8000/api/compare',
```

**Replace with your PC's IP:**
- Find PC IP: Open `cmd` → `ipconfig` → Look for "IPv4 Address"
- On phone, it should be able to reach this IP via WiFi

### 2. Check Phone Can Reach Backend
On phone:
1. Open browser
2. Visit: `http://192.168.100.7:8000/api/health`
3. Should see: `{"status": "ReciteRight backend chal raha hai ✅", ...}`

### 3. Grant Microphone Permission
When app first runs, allow microphone access.

---

## 🔧 Troubleshooting

### Problem: Backend won't start
```powershell
# Check Python
python --version

# Check packages
pip list | findstr flask

# Manually install if needed
pip install flask flask-cors librosa numpy scikit-learn joblib requests faster-whisper soundfile noisereduce
```

### Problem: App can't reach backend
1. **Check PC IP:** Run `ipconfig` in cmd
2. **Check phone WiFi:** Connected to same network?
3. **Update app:** Edit EnhancedReciteScreen.dart with correct IP
4. **Rebuild:** `flutter clean` then rebuild

### Problem: APK won't install
```powershell
# Uninstall old version
adb uninstall com.tajweed_corrector

# Try installing again
adb install build\app\outputs\flutter-apk\app-debug.apk
```

### Problem: App crashes on launch
```powershell
# Check logcat
adb logcat | findstr "tajweed"

# Or see full logs
adb logcat > phone_logs.txt
```

---

## 📊 Testing Features

### Feature 1: Select Ayah
1. Select Surah: "Al-Fatiha" (Surah 1)
2. Select Ayah: "1" (First verse)
3. Should show Arabic text + translation + Qari audio

### Feature 2: Listen to Qari
- Click "Listen to Qari" button
- Should hear Quranic recitation
- Can select different Qaris

### Feature 3: Record & Compare
1. Click "Start Recording" button
2. Recite the Ayah clearly
3. Click "Stop Recording" button
4. Click "Compare with Qari" button
5. Wait for analysis (30-60 seconds)
6. See results: Score, Tajweed rules, Word analysis

### Feature 4: View Results
Results show:
- Overall score (0-100%)
- Grade (Perfect, Excellent, Very Good, etc.)
- Word-by-word comparison (green=correct, red=wrong)
- Tajweed rules detected for each word
- Metrics breakdown (Whisper, MFCC scores)

---

## 🔌 API Endpoints

All endpoints available at: `http://192.168.100.7:8000`

### Health Check
```
GET /api/health
```

### Compare Recitation
```
POST /api/compare
Form data:
- audio: WAV file
- surah: Surah number (1-114)
- ayah: Ayah number
- correct_text: Arabic text of the Ayah
```

### Get Qaris List
```
GET /qaris
```

---

## 💾 Logs & Debugging

### Backend Logs
Located at: `F:\ReciteRight\backend\backend.log`

### Phone Logs
```powershell
adb logcat > F:\ReciteRight\phone_logs.txt
```

### Flutter Logs
```powershell
flutter logs
```

---

## ⚙️ Advanced Configuration

### Change Backend Port (app.py line 787)
```python
app.run(debug=True, port=8000, host='0.0.0.0')
```
Change `port=8000` to any available port, then update IP in Flutter app.

### Change Qari Selection
Edit: `lib/screens/EnhancedReciteScreen.dart` (lines 92-98)

### Disable Recording Feature
Comment out: `lib/screens/EnhancedReciteScreen.dart` line 266-280

---

## 📞 Support Info

### Required Modules
- Flask: Web framework
- Librosa: Audio processing
- Faster-Whisper: Speech recognition
- Scikit-learn: ML features
- Soundfile: Audio I/O

### Performance Notes
- First Whisper transcription: ~5-10 seconds
- Subsequent requests: ~2-3 seconds (cached model)
- MFCC analysis: ~1-2 seconds
- Total comparison: 10-20 seconds on laptop CPU

### Internet Requirements
- App needs internet to fetch:
  - Quran API (ayah text + translation)
  - Qari audio files (from verses.quran.com)
- Backend processes locally (no external ML APIs)

---

## ✨ Final Checklist

- [ ] Backend running in Terminal 1
- [ ] App installed on phone
- [ ] Phone connected to WiFi (same network as PC)
- [ ] Correct backend IP in Flutter app
- [ ] Microphone permission granted on phone
- [ ] Can reach http://backend-ip:8000/api/health
- [ ] Try recording and comparing

🎉 **You're ready to test ReciteRight!**

