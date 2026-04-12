# Ayah Practice UX Notes

This screen redesign keeps memorization flow inside one Surah screen.

## What changed

- `AyahDisplayScreen.dart` now uses an in-place sticky practice card.
- Tapping an ayah no longer opens a separate practice route by default.
- Users can swipe left/right on the expanded practice card to move ayahs.
- Arrow buttons and index (`current/total`) are shown for accessibility.
- Playback progress, qari selection, recording, and compare all stay in-context.
- Optional full-screen `Practice Mode` supports swipe + next/previous + range loop.
- Expanded card content is scrollable with safe-area bottom padding to prevent
  `BOTTOM OVERFLOWED BY XXX PIXELS` on small screens.

## Core interactions

1. Open a surah from `SurahListScreen`.
2. Tap any ayah row.
3. Expand the sticky card and use:
   - `Listen` (primary)
   - `Start Recording`
   - `Compare with Qari`
   - repeat toggles and range loop controls
4. Use `Practice Mode` from the app bar or header button for focused view.

## Quick validation

Run this to check the updated screen:

```powershell
cd "F:\ReciteRight\frontend\Frontend"
flutter analyze lib/screens/AyahDisplayScreen.dart
```

Optional run on device:

```powershell
cd "F:\ReciteRight\frontend\Frontend"
flutter run
```

