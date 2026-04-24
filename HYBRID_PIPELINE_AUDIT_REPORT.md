# ReciteRight Hybrid Pipeline Audit Report

Date: 2026-04-22
Scope: Verify whether the claimed hybrid recitation pipeline is implemented and functioning.

## Checklist Verdict

- [x] Speech activity gate exists and works (`422 no_speech_detected` observed).
- [x] Audio preprocessing exists (denoise/normalize/trim).
- [x] Faster-Whisper transcription exists and returns Arabic text.
- [x] Word alignment exists (correct/close/missing/extra).
- [x] Phoneme extraction/comparison exists.
- [x] DTW exists (MFCC + tempo-invariant path cost).
- [x] Tajweed rule detection exists (rule tagging + timing heuristic).
- [x] Weighted hybrid score exists (20/60/20 + confidence multiplier).
- [~] End-to-end quality/calibration is not stable enough (known scoring anomalies).

## Runtime Evidence (local backend)

### 1) No-speech gate
Request: `/api/compare` with a generated 1s silent WAV.

Observed:
- `status: 422`
- `reason: no_speech_detected`
- `error: No recitation detected...`

Conclusion: Speech gate works as expected.

### 2) End-to-end compare
Request: `/api/compare` with `sample_001001.mp3` (downloaded from `verses.quran.com/Alafasy/mp3/001001.mp3`).

Observed:
- `status: 200`
- `success: true`
- `hybrid_scoring.method: Hybrid (Audio 20% + Phoneme 60% + Tajweed 20%)`
- `hybrid_scoring.dtw_enabled: true`
- `metrics.dtw_score` present
- `metrics.direct_phoneme_score` present
- `tajweed_summary.total_rules_detected` present

Conclusion: Pipeline components are connected and returning expected fields.

### 3) Formula consistency
Recomputed from response:
- `raw_hybrid_score ~= audio*0.20 + phoneme*0.60 + tajweed*0.20`
- `overall_score ~= raw_hybrid_score * confidence_multiplier`

Conclusion: Weighting implementation is consistent.

## Findings (ordered by severity)

### High

1. **Reference-Qari selection is ignored in backend**
   - File: `backend/app.py` (`download_qari`, compare route)
   - Evidence: Sending `qari_id=1`, `qari_id=7`, `qari_id=12` always returns `https://verses.quran.com/Alafasy/mp3/...`.
   - Risk: UI lets user select Qari, but backend always compares against Alafasy. This is a behavior mismatch and viva risk.

2. **Score calibration issue: reference sample can still produce low final score**
   - File: `backend/app.py` (hybrid scoring block in `/api/compare`)
   - Evidence: Using a reference-style sample for 1:1 yielded around `48%`.
   - Risk: Users may receive surprisingly low scores even on good recitation; weak trust and viva challenge.

### Medium

3. **Tajweed rule checks are mostly text-derived, not true user-rule detection**
   - File: `backend/app.py` (`analyze_tajweed`, `verify_tajweed_timing`)
   - Behavior: Rule presence is detected from expected text; correctness relies heavily on global duration/rhythm heuristics.
   - Risk: Overstates precision of "rule-level correctness" if presented as full acoustic rule verification.

4. **Phoneme component naming is confusing in docs/UI explanations**
   - File: `backend/app.py` (`phoneme_accuracy_score` block)
   - Behavior: Phoneme component blends `DTW(60%) + direct phoneme edit(40%)`, where DTW is whole-audio MFCC, not literal phoneme sequence DTW.
   - Risk: Viva explanation can be challenged if phrased as pure phoneme DTW.

### Low

5. **Legacy API service paths can mislead maintainers**
   - File: `frontend/Frontend/lib/services/api_service.dart`
   - Behavior: Contains fallback JSON/base64 call to `/api/compare` and logs `dtw_distance`, but main backend expects multipart `audio` and returns `dtw_score` under `metrics`.
   - Risk: Confusing diagnostics and possible integration drift.

## What is Correct in Your Current Viva Statement

Your statement is mostly correct for architecture and flow:
- Hybrid pipeline exists.
- Faster-Whisper is used for Arabic transcription.
- Alignment + phoneme + DTW + Tajweed timing are used.
- Final score uses `20/60/20` and confidence multiplier.

## What to Correct in Viva Wording

Use this safer line:

> "We detect Tajweed opportunities from the expected ayah text and estimate user Tajweed quality using timing/rhythm heuristics plus alignment evidence."

instead of claiming perfect rule-by-rule acoustic verification.

Also say:

> "Qari selection is implemented in UI; backend currently defaults to Alafasy in this build."

## Solution Guide

### Phase 1 (quick fixes: 1-2 days)

1. **Wire `qari_id` end-to-end**
   - Parse `qari_id` in `/api/compare`.
   - Map IDs to folder names (`Alafasy`, etc.) in `download_qari`.
   - Return actual selected `reference_audio_url`.

2. **Harden calibration baseline**
   - Add golden test cases (same-source qari clip, good student clip, noisy clip).
   - Tune weights/penalties so same-source test scores in expected high band.

3. **Align API contracts in frontend service**
   - Remove stale `dtw_distance` assumptions.
   - Standardize on multipart for `/api/compare`.

### Phase 2 (quality improvements: 3-7 days)

4. **Improve phoneme scoring fidelity**
   - Add Arabic grapheme-to-phoneme normalization rules.
   - Use weighted edit costs for confusable sounds.

5. **Refine Tajweed scoring claims and logic**
   - Keep text rule detection, but clearly separate "rule expected" vs "rule performed well".
   - Add per-word timing windows where feasible instead of whole-ayah duration ratio only.

6. **Observability and regression checks**
   - Persist debug metrics (`dtw`, `phoneme`, `tajweed`, `confidence`) in test fixtures.
   - Add pass/fail thresholds in CI tests.

### Phase 3 (research-grade improvements)

7. **Rule-specific acoustic detectors**
   - Build supervised detectors for Ghunnah/Madd/Qalqalah durations and spectral cues.

8. **Model confidence calibration**
   - Calibrate final score against teacher-labeled dataset.

## Minimal Acceptance Tests to keep

- Silent input must return `422 no_speech_detected`.
- Good recitation should pass transcription gate and return full `hybrid_scoring` block.
- Formula check must hold: `final ~= round((0.2*audio + 0.6*phoneme + 0.2*tajweed) * confidence, 1)`.
- Changing `qari_id` must change `reference_audio_url` once fixed.

