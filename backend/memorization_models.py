# -*- coding: utf-8 -*-
"""Memorization domain models."""
from dataclasses import dataclass, field, asdict
from typing import Dict, Any, List, Optional


VALID_STATUSES = {"not_started", "learning", "memorized", "needs_review"}


@dataclass
class AccuracyEntry:
    session_id: str
    score: float
    recorded_at: str

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


@dataclass
class MemorizationItem:
    user_id: str
    surah_number: int
    ayah_number: int
    status: str = "not_started"
    accuracy_history: List[AccuracyEntry] = field(default_factory=list)
    times_recited: int = 0
    last_recited_at: Optional[str] = None
    last_status_change_at: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        return {
            "userId": self.user_id,
            "surahNumber": self.surah_number,
            "ayahNumber": self.ayah_number,
            "status": self.status,
            "accuracyHistory": [e.to_dict() for e in self.accuracy_history],
            "timesRecited": self.times_recited,
            "lastRecitedAt": self.last_recited_at,
            "lastStatusChangeAt": self.last_status_change_at,
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "MemorizationItem":
        history_raw = data.get("accuracyHistory", data.get("accuracy_history", []))
        history = [
            AccuracyEntry(
                session_id=(h.get("sessionId") or h.get("session_id") or ""),
                score=float(h.get("score", 0)),
                recorded_at=(h.get("recordedAt") or h.get("recorded_at") or ""),
            )
            for h in history_raw
        ]

        status = str(data.get("status", "not_started"))
        if status not in VALID_STATUSES:
            status = "not_started"

        return cls(
            user_id=str(data.get("userId", data.get("user_id", ""))),
            surah_number=int(data.get("surahNumber", data.get("surah_number", 0))),
            ayah_number=int(data.get("ayahNumber", data.get("ayah_number", 0))),
            status=status,
            accuracy_history=history,
            times_recited=int(data.get("timesRecited", data.get("times_recited", 0))),
            last_recited_at=data.get("lastRecitedAt", data.get("last_recited_at")),
            last_status_change_at=data.get("lastStatusChangeAt", data.get("last_status_change_at")),
        )


@dataclass
class SurahSummary:
    surah_number: int
    surah_name: str
    total_ayahs: int
    memorized_ayahs: int
    learning_ayahs: int
    needs_review_ayahs: int
    not_started_ayahs: int
    percent_memorized: float
    last_activity_at: Optional[str]

    def to_dict(self) -> Dict[str, Any]:
        return {
            "surahNumber": self.surah_number,
            "surahName": self.surah_name,
            "totalAyahs": self.total_ayahs,
            "memorizedAyahs": self.memorized_ayahs,
            "learningAyahs": self.learning_ayahs,
            "needsReviewAyahs": self.needs_review_ayahs,
            "notStartedAyahs": self.not_started_ayahs,
            "percentMemorized": self.percent_memorized,
            "lastActivityAt": self.last_activity_at,
        }


@dataclass
class MemorizationSummary:
    overall_percent: float
    total_memorized: int = 0
    total_learning: int = 0
    total_needs_review: int = 0
    total_tracked_ayahs: int = 0
    surah_summaries: List[SurahSummary] = field(default_factory=list)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "overallPercent": self.overall_percent,
            "totalMemorized": self.total_memorized,
            "totalLearning": self.total_learning,
            "totalNeedsReview": self.total_needs_review,
            "totalTrackedAyahs": self.total_tracked_ayahs,
            "surahSummaries": [s.to_dict() for s in self.surah_summaries],
        }

