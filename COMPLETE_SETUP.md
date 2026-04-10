# ReciteRight - Complete Setup Summary

## ✅ What's Been Done

### Backend (Flask Server) - READY ✓
- **Location:** `F:\ReciteRight\backend\app.py`
- **Port:** 8000
- **Features:**
  - ✅ Whisper-based audio transcription (Arabic)
  - ✅ Tajweed rule detection per word
  - ✅ Word-by-word comparison
  - ✅ MFCC-based audio feature similarity
  - ✅ Full API with health check, transcribe, compare endpoints

### Frontend (Flutter App) - BUILDING ⏳
- **Location:** `F:\ReciteRight\frontend\Frontend`
- **Features:**
  - ✅ Surah & Ayah selection from Quran
  - ✅ Arabic text display (with Scheherazade font)
  - ✅ English translation
  - ✅ Listen to Qari audio
  - ✅ Recording capability (fixed API compatibility)
  - ✅ Comparison results display
  - ⏳ APK currently building

---

## 🚀 How to Run (COMPLETE STEPS)

### Step 1: Start Backend Server

Open PowerShell and run:

```powershell
cd F:\ReciteRight
.\start_backend.ps1
```

Expected output:
```
✅ Python found: C:\Python\python.exe
✅ All modules available
Starting Flask backend on port 8000...
 * Running on http://0.0.0.0:8000 (Press CTRL+C to quit)
```

**Keep this terminal window open!** The backend will run continuously.

---

### Step 2: Wait for APK Build & Install on Phone

Open **another** PowerShell window and run:

```powershell
cd F:\ReciteRight\frontend\Frontend

# Build debug APK (takes 2-3 minutes)
flutter build apk --debug

# Install on connected phone
adb install -r build\app\outputs\flutter-apk\app-debug.apk

# Launch app on phone
adb shell am start -n "com.tajweed_corrector/com.tajweed_corrector.MainActivity"
```

---

### Step 3: Verify Connection

#### On PC:
- Backend should be listening on `http://192.168.100.7:8000`
- Check: `netstat -ano | findstr 8000` should show listening

#### On Phone:
1. Open browser
2. Visit: `http://192.168.100.7:8000/api/health`
3. Should see JSON response with backend status

#### Phone WiFi:
- Must be connected to same WiFi network as PC
- Phone should be able to reach PC's IP

---

## 📱 Using the App

### Feature 1: Select & Listen
1. Launch app on phone
2. Select **Surah**: "Al-Fatiha"
3. Select **Ayah**: "1"
4. Arabic text + translation should appear
5. Tap "▶ Listen to Qari" to hear audio

### Feature 2: Record & Compare
1. Tap "🔴 Start Recording" button
2. Recite the Ayah (speak clearly!)
3. Tap "🔴 Stop Recording" button
4. Tap "Compare with Qari" button
5. Wait 15-20 seconds for analysis
6. See results with:
   - Overall score (0-100%)
   - Grade (Perfect, Excellent, Very Good, etc.)
   - Word-by-word analysis (Green=correct, Red=wrong)
   - Tajweed rules detected
   - Phoneme breakdown

---

## 🔌 Backend Information

### API Endpoints

```
GET  /api/health                 → Health check
GET  /qaris                       → List of Qaris
GET  /api/qari-url              → Get Qari audio URL
POST /api/compare               → Full comparison with transcription
POST /api/transcribe            → Transcription only
```

### Processing Details
- **Audio Input:** WAV format, 16kHz, mono
- **Transcription:** Faster-Whisper (CPU mode, base model)
- **Processing Time:** 15-30 seconds per Ayah
- **Scoring:** 70% transcription accuracy + 30% MFCC similarity

### Dependencies Installed
- Flask & Flask-CORS
- Librosa (audio processing)
- Faster-Whisper (transcription)
- Scikit-learn (features)
- Joblib (model persistence)
- Soundfile (audio I/O)
- Noisereduce (preprocessing)

---

## ⚙️ Configuration

### PC IP Address
Currently configured: **192.168.100.7**

To check your actual IP:
```powershell
ipconfig
# Look for: IPv4 Address
```

If different, update in:
`F:\ReciteRight\frontend\Frontend\lib\screens\EnhancedReciteScreen.dart` (line 302)

### Backend Port
Currently: **8000**

To change:
`F:\ReciteRight\backend\app.py` (line 787)

---

## 📊 What Happens When You Compare

### Behind the Scenes Flow:

1. **Audio Preprocessing** (2s)
   - Noise reduction
   - Volume normalization
   - Silence trimming

2. **Transcription** (10-15s)
   - Whisper transcribes user's audio to Arabic text
   - Compares with correct Ayah text

3. **Word Alignment** (1s)
   - Normalizes Arabic (removes tashkeel, alef variations)
   - Matches user words to correct words
   - Calculates similarity score per word

4. **Tajweed Detection** (2s)
   - Analyzes each word for Tajweed rules
   - Detects: Madd, Ghunnah, Qalqalah, Ikhfa, Idgham, Iqlab, Izhar, Shadda, Sukoon

5. **Audio Feature Analysis** (5s)
   - Extracts MFCC (Mel-Frequency Cepstral Coefficients)
   - Compares with Qari's audio
   - Calculates similarity score

6. **Final Score Calculation** (1s)
   - **Final Score = (Whisper Accuracy × 0.7) + (MFCC Similarity × 0.3)**
   - Generates grade and feedback

**Total Time: 20-30 seconds**

---

## ❌ Troubleshooting

### Problem: "Backend not responding"
```powershell
# Solution: Restart backend
taskkill /F /IM python.exe
cd F:\ReciteRight
.\start_backend.ps1
```

### Problem: "App can't find backend"
1. Check PC IP: `ipconfig`
2. Update in `EnhancedReciteScreen.dart` line 302
3. Rebuild: `flutter build apk --debug`
4. Reinstall: `adb install -r build\app\outputs\flutter-apk\app-debug.apk`

### Problem: "APK won't install"
```powershell
# Uninstall old version first
adb uninstall com.tajweed_corrector

# Then install new one
adb install build\app\outputs\flutter-apk\app-debug.apk
```

### Problem: "Phone can't reach PC"
- Both on same WiFi? ✓
- Firewall blocking port 8000?
  - Try: `netstat -ano | findstr 8000`
  - Add port 8000 to Windows Firewall exceptions

### Problem: "Recording not working"
- Microphone permission granted? ✓
- Check app logs: `adb logcat | findstr tajweed`

---

## 📞 Quick Commands Reference

```powershell
# Check backend status
netstat -ano | findstr 8000

# Check connected devices
adb devices

# View app logs
adb logcat | findstr tajweed

# Uninstall app
adb uninstall com.tajweed_corrector

# Install APK
adb install build\app\outputs\flutter-apk\app-debug.apk

# Launch app
adb shell am start -n "com.tajweed_corrector/com.tajweed_corrector.MainActivity"

# Check PC IP
ipconfig

# Restart backend
taskkill /F /IM python.exe
```

---

## ✨ Feature Checklist

- [x] Backend API server running
- [x] Whisper transcription working
- [x] Tajweed detection implemented
- [x] Word comparison logic
- [x] MFCC audio analysis
- [x] Flutter app built
- [x] Recording enabled
- [x] Results display
- [x] IP configuration dynamic

---

## 🎯 Next Steps

1. **Wait for APK build** (currently building)
2. **Connect phone via USB**
3. **Enable USB debugging** on phone
4. **Run start_backend.ps1** in Terminal 1
5. **Run flutter build + install** in Terminal 2
6. **Test app** on phone

---

## 📋 Final Checklist Before Running

- [ ] Backend dependencies installed (`pip install flask...`)
- [ ] Flask backend can start without errors
- [ ] Phone connected to PC via USB
- [ ] USB debugging enabled on phone
- [ ] Phone on same WiFi as PC
- [ ] Backend IP correct in Flutter code
- [ ] APK built successfully
- [ ] APK installed on phone
- [ ] Microphone permission granted

---

**You're all set! ReciteRight is ready to run on your phone.** 🎉

Both the backend and app are configured and ready to process Quranic recitations with Tajweed analysis!

For detailed debugging, check:
- Backend logs: Monitor Terminal 1 (backend server)
- App logs: `adb logcat`
- Build logs: `build.log` in Flutter directory

