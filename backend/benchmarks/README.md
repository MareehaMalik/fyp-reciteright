# Scoring Benchmark

Use this folder to estimate how close the text/alignment scoring logic is to your expert target scores.

## Files

- `labeled_score_cases.json`: small labeled starter dataset.
- `score_accuracy_harness.py`: compares baseline scoring vs current candidate scoring and reports MAE.

## Run

```powershell
cd E:\FYP4\fyp-reciteright\backend
python -u benchmarks\score_accuracy_harness.py --dataset benchmarks\labeled_score_cases.json --output benchmarks\benchmark_report.json
```

## Next

- Expand `labeled_score_cases.json` with real recitations reviewed by a Quran teacher.
- Track MAE trend before/after each scoring change.
- Only claim 80-90% once benchmark agreement is consistently high on a larger set.

