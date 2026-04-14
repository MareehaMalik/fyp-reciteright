# -*- coding: utf-8 -*-
"""
Session and Mistake Data Models for ReciteRight
Tracks recitation sessions and word-level mistakes
"""
from dataclasses import dataclass, field, asdict
from typing import List, Optional, Dict, Any
from datetime import datetime
import json


@dataclass
class Mistake:
    """Word-level mistake from a recitation session"""
    word: str  # Arabic word
    ayah: int
    surah: int
    tajweed_rules: List[str] = field(default_factory=list)  # e.g., ["Madd", "Ghunnah"]
    error_type: str = "mispronunciation"  # "mispronunciation", "skipped", "extra", "timing"
    similarity: float = 0.0  # 0-1, how close was the user to correct
    occurred_at: str = ""  # ISO timestamp
    session_id: str = ""

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'Mistake':
        return cls(**data)


@dataclass
class RecitationSession:
    """Complete recitation session with all metrics and mistakes"""
    id: str
    user_id: str
    surah: int
    ayah: int
    mode: str  # "recitation", "lesson", "review"
    accuracy_score: float  # 0-100 (final_score from /api/compare)
    whisper_score: float  # 0-100 (transcription accuracy)
    mfcc_score: float  # 0-100 (audio quality)
    date_time: str  # ISO timestamp
    duration_seconds: int
    mistakes: List[Mistake] = field(default_factory=list)
    total_words: int = 0
    correct_words: int = 0
    close_words: int = 0
    missing_words: int = 0
    extra_words: int = 0
    reference_audio_url: Optional[str] = None
    transcribed_text: str = ""
    correct_text: str = ""

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "user_id": self.user_id,
            "surah": self.surah,
            "ayah": self.ayah,
            "mode": self.mode,
            "accuracy_score": self.accuracy_score,
            "whisper_score": self.whisper_score,
            "mfcc_score": self.mfcc_score,
            "date_time": self.date_time,
            "duration_seconds": self.duration_seconds,
            "mistakes": [m.to_dict() for m in self.mistakes],
            "total_words": self.total_words,
            "correct_words": self.correct_words,
            "close_words": self.close_words,
            "missing_words": self.missing_words,
            "extra_words": self.extra_words,
            "reference_audio_url": self.reference_audio_url,
            "transcribed_text": self.transcribed_text,
            "correct_text": self.correct_text,
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'RecitationSession':
        mistakes_data = data.get("mistakes", [])
        mistakes = [Mistake.from_dict(m) for m in mistakes_data]
        data_copy = dict(data)
        data_copy["mistakes"] = mistakes
        return cls(**data_copy)


@dataclass
class DailyActivity:
    """Activity for a single day"""
    day: str  # "Mon", "Tue", etc.
    date: str  # YYYY-MM-DD
    has_session: bool
    session_count: int = 0
    total_minutes: int = 0
    avg_accuracy: float = 0.0

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


@dataclass
class RecentRecitation:
    """Summary of a recent recitation for display"""
    title: str  # e.g., "Surah Al-Baqarah Ayah 5"
    mode: str
    accuracy: float
    days_ago: int
    session_id: str
    date_time: str

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


@dataclass
class WeeklyProgressSummary:
    """Weekly progress overview"""
    this_week_count: int
    avg_accuracy: float
    perfect_count: int  # accuracy >= 95
    days: List[DailyActivity] = field(default_factory=list)
    recent_recitations: List[RecentRecitation] = field(default_factory=list)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "thisWeekCount": self.this_week_count,
            "avgAccuracy": self.avg_accuracy,
            "perfectCount": self.perfect_count,
            "days": [d.to_dict() for d in self.days],
            "recentRecitations": [r.to_dict() for r in self.recent_recitations],
        }


@dataclass
class MistakeWord:
    """Single word with mistakes"""
    word: str
    times: int  # How many times this word was mistaken
    last_similarity: float
    last_occurred_at: str

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


@dataclass
class AyahMistakeSummary:
    """Summary of mistakes for an ayah"""
    surah_number: int
    surah_name: str
    ayah: int
    mistake_count: int
    last_practiced_at: str
    words: List[MistakeWord] = field(default_factory=list)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "surahNumber": self.surah_number,
            "surahName": self.surah_name,
            "ayah": self.ayah,
            "mistakeCount": self.mistake_count,
            "lastPracticedAt": self.last_practiced_at,
            "words": [w.to_dict() for w in self.words],
        }


@dataclass
class MistakesSummary:
    """Aggregated mistakes summary"""
    by_ayah: List[AyahMistakeSummary] = field(default_factory=list)
    total_mistakes: int = 0
    most_recent_mistake_at: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        return {
            "byAyah": [a.to_dict() for a in self.by_ayah],
            "totalMistakes": self.total_mistakes,
            "mostRecentMistakeAt": self.most_recent_mistake_at,
        }


@dataclass
class HomeMetricsWithStreak:
    """Home screen metrics including streak"""
    current_streak: int
    longest_streak: int
    last_session_date: Optional[str] = None
    today_minutes: int = 0
    this_week_minutes: int = 0

    def to_dict(self) -> Dict[str, Any]:
        return {
            "currentStreak": self.current_streak,
            "longestStreak": self.longest_streak,
            "lastSessionDate": self.last_session_date,
            "todayMinutes": self.today_minutes,
            "thisWeekMinutes": self.this_week_minutes,
        }

