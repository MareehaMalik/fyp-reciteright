# -*- coding: utf-8 -*-
"""Business logic for ayah-level memorization tracking."""
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, List, Tuple

from gamification_logic import SURAH_AYAH_COUNTS, SURAH_NAMES
from memorization_models import MemorizationItem, AccuracyEntry, MemorizationSummary, SurahSummary


MIN_SCORE_FOR_MEMORIZED = 90.0
MIN_SCORE_FOR_OK = 80.0
REQUIRED_CONSECUTIVE_GOOD_SESSIONS = 3
MAX_DAYS_BEFORE_DECAY = 14
MAJOR_MISTAKE_STATUSES = {"missing", "extra"}
MAX_HISTORY_SIZE = 50


def _parse_iso_utc(value: str) -> datetime:
    if not value:
        return datetime.now(timezone.utc)
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def _apply_decay(item: MemorizationItem, now_iso: str) -> MemorizationItem:
    if item.status != "memorized" or not item.last_recited_at:
        return item

    now = _parse_iso_utc(now_iso)
    last = _parse_iso_utc(item.last_recited_at)
    if (now - last).days > MAX_DAYS_BEFORE_DECAY:
        item.status = "needs_review"
        item.last_status_change_at = now_iso
    return item


def _has_major_mistakes(word_results: List[Dict[str, Any]]) -> bool:
    if not word_results:
        return False
    statuses = [str(w.get("status", "")).lower() for w in word_results]
    return any(s in MAJOR_MISTAKE_STATUSES for s in statuses)


def _consecutive_good_sessions(history: List[AccuracyEntry], n: int) -> bool:
    if len(history) < n:
        return False
    last_n = history[-n:]
    return all(entry.score >= MIN_SCORE_FOR_MEMORIZED for entry in last_n)


def update_memorization_item(
    existing_item: MemorizationItem,
    *,
    overall_score: float,
    word_results: List[Dict[str, Any]],
    session_id: str,
    recorded_at: str,
) -> MemorizationItem:
    """Apply update rules for a memorization attempt."""
    item = _apply_decay(existing_item, recorded_at)

    previous_status = item.status

    item.accuracy_history.append(
        AccuracyEntry(session_id=session_id, score=float(overall_score), recorded_at=recorded_at)
    )
    if len(item.accuracy_history) > MAX_HISTORY_SIZE:
        item.accuracy_history = item.accuracy_history[-MAX_HISTORY_SIZE:]

    item.times_recited += 1
    item.last_recited_at = recorded_at

    major_mistakes = _has_major_mistakes(word_results)

    if _consecutive_good_sessions(item.accuracy_history, REQUIRED_CONSECUTIVE_GOOD_SESSIONS) and not major_mistakes:
        item.status = "memorized"
    elif float(overall_score) >= MIN_SCORE_FOR_OK:
        item.status = "learning"
    else:
        item.status = "needs_review"

    # If previously memorized and this attempt is weak, force needs_review.
    if previous_status == "memorized" and (
        float(overall_score) < MIN_SCORE_FOR_OK or major_mistakes
    ):
        item.status = "needs_review"

    if item.status != previous_status:
        item.last_status_change_at = recorded_at

    return item


def build_memorization_summary(items: List[MemorizationItem]) -> MemorizationSummary:
    grouped: Dict[int, List[MemorizationItem]] = {}
    for item in items:
        grouped.setdefault(item.surah_number, []).append(item)

    surah_summaries: List[SurahSummary] = []
    total_memo = 0
    total_learning = 0
    total_needs_review = 0
    total_tracked = 0
    total_ayahs_accum = 0

    for surah, surah_items in sorted(grouped.items(), key=lambda kv: kv[0]):
        total_ayahs = SURAH_AYAH_COUNTS.get(surah, 0)
        memorized_count = sum(1 for i in surah_items if i.status == "memorized")
        learning_count = sum(1 for i in surah_items if i.status == "learning")
        needs_review_count = sum(1 for i in surah_items if i.status == "needs_review")
        not_started_count = max(total_ayahs - (memorized_count + learning_count + needs_review_count), 0)
        last_activity = max((i.last_recited_at or "" for i in surah_items), default=None)

        total_memo += memorized_count
        total_learning += learning_count
        total_needs_review += needs_review_count
        total_tracked += len(surah_items)
        total_ayahs_accum += total_ayahs

        percent = (memorized_count / total_ayahs * 100.0) if total_ayahs > 0 else 0.0
        surah_summaries.append(
            SurahSummary(
                surah_number=surah,
                surah_name=SURAH_NAMES.get(surah, f"Surah {surah}"),
                total_ayahs=total_ayahs,
                memorized_ayahs=memorized_count,
                learning_ayahs=learning_count,
                needs_review_ayahs=needs_review_count,
                not_started_ayahs=not_started_count,
                percent_memorized=round(percent, 1),
                last_activity_at=last_activity,
            )
        )

    overall = (total_memo / total_ayahs_accum * 100.0) if total_ayahs_accum > 0 else 0.0
    return MemorizationSummary(
        overall_percent=round(overall, 1),
        total_memorized=total_memo,
        total_learning=total_learning,
        total_needs_review=total_needs_review,
        total_tracked_ayahs=total_tracked,
        surah_summaries=surah_summaries,
    )


def recommended_today(items: List[MemorizationItem], limit: int = 5) -> List[Dict[str, Any]]:
    """Return prioritized ayahs for today.

    Priority:
    1) needs_review
    2) learning
    3) not_started
    Sort within each by oldest last_recited_at first.
    """
    status_priority = {
        "needs_review": 0,
        "learning": 1,
        "not_started": 2,
        "memorized": 3,
    }

    def sort_key(item: MemorizationItem) -> Tuple[int, str]:
        # Empty/None last_recited should come first as oldest.
        ts = item.last_recited_at or ""
        return (status_priority.get(item.status, 4), ts)

    candidates = sorted(items, key=sort_key)
    out: List[Dict[str, Any]] = []
    for item in candidates:
        if item.status == "memorized":
            continue
        out.append(
            {
                "surahNumber": item.surah_number,
                "surahName": SURAH_NAMES.get(item.surah_number, f"Surah {item.surah_number}"),
                "ayahNumber": item.ayah_number,
                "status": item.status,
                "lastRecitedAt": item.last_recited_at,
                "timesRecited": item.times_recited,
            }
        )
        if len(out) >= limit:
            break
    return out

