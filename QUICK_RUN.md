# 🚀 ReciteRight - Run on Phone (Quick Instructions)

## ✅ STEP 1: Start Backend (Keep This Terminal Open)

Open PowerShell and run:
```powershell
cd F:\ReciteRight
.\start_backend.ps1
```

Wait for this message:
```
Starting Flask backend on port 8000...
 * Running on http://0.0.0.0:8000
```

**✓ Backend is now running!**

---

## ✅ STEP 2: Build and Install App on Phone

Open another PowerShell and run:
```powershell
cd F:\ReciteRight\frontend\Frontend

# Option A: Quick script
cd F:\ReciteRight
.\run_on_phone.ps1

# Option B: Manual commands
flutter build apk --debug
adb install -r build\app\outputs\flutter-apk\app-debug.apk
adb shell am start -n "com.tajweed_corrector/com.tajweed_corrector.MainActivity"
```

---

## 🔧 IMPORTANT: Update Backend IP

The app needs to know your PC's IP address to reach the backend.

### Find Your PC's IP:
1. Open `cmd.exe`
2. Type: `ipconfig`
3. Look for: **IPv4 Address** (looks like `192.168.x.x`)

### Update App with Your IP:
1. Open file: `F:\ReciteRight\frontend\Frontend\lib\screens\EnhancedReciteScreen.dart`
2. Find line 302: `'http://192.168.100.7:8000/api/compare',`
3. Replace `192.168.100.7` with your PC's IP
4. Save file
5. Rebuild: `flutter build apk --debug`

---

## 📱 Using the App

### Feature: Select & Listen
1. Select **Surah**: "Al-Fatiha" (Surah 1)
2. Select **Ayah**: "1" (First verse)
3. Click "▶ Listen to Qari" to hear the audio

### Feature: Record & Compare
1. Click "🔴 Start Recording"
2. Recite the Ayah (speak clearly into phone mic)
3. Click "🔴 Stop Recording"
4. Click "Compare with Qari"
5. Wait 10-20 seconds for results
6. See: Score, Grade, Tajweed Rules, Word Analysis

---

## ✨ What You Should See

### Backend Terminal Output:
```
✅ Model ready! 114 reference ayaat loaded.
✅ Faster-Whisper model loaded!
 * Running on http://0.0.0.0:8000
```

### App on Phone:
- Arabic text of Ayah displayed
- English translation shown
- Play/Record/Compare buttons working
- Results screen with score and analysis

---

## ❌ If Something Doesn't Work

### Backend won't start?
```powershell
cd F:\ReciteRight\backend
python app.py
# Check for error messages
```

### App can't find backend?
1. Check PC IP with: `ipconfig`
2. Update the IP in EnhancedReciteScreen.dart line 302
3. Make sure phone is on same WiFi as PC
4. Test: Open phone browser → visit `http://PC-IP:8000/api/health`

### App won't build?
```powershell
cd F:\ReciteRight\frontend\Frontend
flutter clean
flutter pub get
flutter build apk --debug
```

### APK won't install?
```powershell
# Uninstall old version first
adb uninstall com.tajweed_corrector

# Then install
adb install build\app\outputs\flutter-apk\app-debug.apk
```

---

## 📊 Test Checklist

- [ ] Backend running (Terminal 1 showing port 8000)
- [ ] App installed on phone
- [ ] Phone on same WiFi as PC
- [ ] Backend IP updated in code
- [ ] Can open phone browser and visit http://PC-IP:8000/api/health
- [ ] Microphone permission granted in app
- [ ] Can play Qari audio
- [ ] Can record and submit for comparison

---

## 🎯 Next Steps

1. **Test recording** with a short Ayah
2. **Check comparison results** - should show score and analysis
3. **Try different Qaris** - select different names
4. **Try different Ayahs** from Surah 1

---

## 📞 Troubleshooting Commands

```powershell
# Check if backend is running
netstat -ano | findstr 8000

# Check if phone is connected
adb devices

# View app logs
adb logcat | findstr tajweed

# Restart backend
taskkill /F /IM python.exe
cd F:\ReciteRight
.\start_backend.ps1
```

---

## ✅ You're All Set!

Both backend and app are now ready to run! 🎉

**Backend:** Always running on port 8000
**App:** Ready to record and compare Quranic recitations

Enjoy using ReciteRight! 📖✨

