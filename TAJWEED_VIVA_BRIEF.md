# Tajweed Detection Viva Brief

## What it does
ReciteRight detects tajweed rules from Quran text and recitation comparison, then shows the results clearly to the learner.

## Where it happens
- **Backend:** `backend/app.py`
  - `analyze_tajweed(...)` detects tajweed rules from Arabic text
  - `verify_tajweed_timing(...)` checks timing-sensitive rules
  - `compute_hybrid_score(...)` combines the final score
  - `/api/compare` returns the full result

## How it appears in the app
- **Frontend:** `frontend/Frontend/lib/widgets/tajweed_colored_text.dart`
- **Screens:** `AyahDisplayScreen.dart` and `ComparisonResultsScreen.dart`

The frontend uses colors, labels, and feedback dialogs so users can see which tajweed rules were detected.

## Scoring idea
The score is a hybrid of:
- **Audio Quality:** 20%
- **Phoneme Accuracy:** 60%
- **Tajweed Timing:** 20%

## Short viva summary
ReciteRight detects tajweed in the backend using rule-based Arabic pattern checks and timing verification, then applies it visually in the frontend with colored words, labels, and feedback screens.

