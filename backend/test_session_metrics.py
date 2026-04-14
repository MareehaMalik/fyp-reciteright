# -*- coding: utf-8 -*-
"""
Unit tests for session metrics calculations
Tests streak calculation, weekly summary, mistake aggregation
"""
import unittest
from datetime import datetime, timedelta
from session_metrics import (
    get_current_streak_from_sessions,
    get_weekly_progress,
    get_mistakes_summary,
    get_today_minutes,
    get_this_week_minutes,
)


class TestStreakCalculation(unittest.TestCase):
    """Test streak calculation logic"""

    def test_no_sessions(self):
        """Streak should be 0 with no sessions"""
        current, longest, last = get_current_streak_from_sessions([])
        self.assertEqual(current, 0)
        self.assertEqual(longest, 0)
        self.assertIsNone(last)

    def test_single_session_today(self):
        """Single session today = streak of 1"""
        today = datetime.utcnow().strftime("%Y-%m-%d")
        sessions = [{
            "date_time": f"{today}T10:00:00Z",
            "surah": 1,
            "ayah": 1,
            "accuracy_score": 90
        }]

        current, longest, last = get_current_streak_from_sessions(sessions, today)
        self.assertEqual(current, 1)
        self.assertEqual(longest, 1)
        self.assertEqual(last, today)

    def test_consecutive_days(self):
        """Consecutive days build streak"""
        today = datetime.utcnow()
        sessions = []

        for i in range(3):
            date = (today - timedelta(days=i)).strftime("%Y-%m-%d")
            sessions.append({
                "date_time": f"{date}T10:00:00Z",
                "surah": 1,
                "ayah": 1,
                "accuracy_score": 90
            })

        today_str = today.strftime("%Y-%m-%d")
        current, longest, last = get_current_streak_from_sessions(sessions, today_str)
        self.assertEqual(current, 3)
        self.assertEqual(longest, 3)

    def test_streak_broken_by_gap(self):
        """Gap in days breaks streak"""
        today = datetime.utcnow()
        sessions = []

        # Mon, Tue, Wed (3 days)
        for i in range(2, -1, -1):
            date = (today - timedelta(days=i)).strftime("%Y-%m-%d")
            sessions.append({
                "date_time": f"{date}T10:00:00Z",
                "surah": 1,
                "ayah": 1,
                "accuracy_score": 90
            })

        # Skip Thursday
        # Fri (gap breaks streak, but earlier 3-day streak remains)
        date = (today - timedelta(days=4)).strftime("%Y-%m-%d")
        sessions.append({
            "date_time": f"{date}T10:00:00Z",
            "surah": 1,
            "ayah": 1,
            "accuracy_score": 90
        })

        today_str = today.strftime("%Y-%m-%d")
        current, longest, last = get_current_streak_from_sessions(sessions, today_str)
        self.assertEqual(current, 3)  # Current streak from Wed-Mon
        self.assertEqual(longest, 3)  # Longest is same

    def test_multiple_streaks_longest_wins(self):
        """Longest streak is tracked separately"""
        today = datetime.utcnow()
        sessions = []

        # Create old 5-day streak (oldest)
        for i in range(14, 9, -1):
            date = (today - timedelta(days=i)).strftime("%Y-%m-%d")
            sessions.append({
                "date_time": f"{date}T10:00:00Z",
                "surah": 1,
                "ayah": 1,
                "accuracy_score": 90
            })

        # Gap of 4 days

        # Create recent 2-day streak
        for i in range(4, 2, -1):
            date = (today - timedelta(days=i)).strftime("%Y-%m-%d")
            sessions.append({
                "date_time": f"{date}T10:00:00Z",
                "surah": 1,
                "ayah": 1,
                "accuracy_score": 90
            })

        today_str = today.strftime("%Y-%m-%d")
        current, longest, last = get_current_streak_from_sessions(sessions, today_str)
        self.assertEqual(current, 2)  # Most recent streak
        self.assertEqual(longest, 5)  # Longest ever


class TestWeeklyProgress(unittest.TestCase):
    """Test weekly progress calculation"""

    def test_empty_week(self):
        """Week with no sessions"""
        today = datetime.utcnow()
        week_start = (today - timedelta(days=today.weekday())).strftime("%Y-%m-%d")

        progress = get_weekly_progress("user_123", [], week_start)
        self.assertEqual(progress.this_week_count, 0)
        self.assertEqual(progress.avg_accuracy, 0.0)
        self.assertEqual(progress.perfect_count, 0)
        self.assertEqual(len(progress.days), 7)

    def test_single_session(self):
        """Week with one session"""
        today = datetime.utcnow()
        today_str = today.strftime("%Y-%m-%d")
        week_start = (today - timedelta(days=today.weekday())).strftime("%Y-%m-%d")

        sessions = [{
            "date_time": f"{today_str}T10:00:00Z",
            "surah": 1,
            "ayah": 1,
            "accuracy_score": 95,
            "duration_seconds": 600,
            "mistakes": []
        }]

        progress = get_weekly_progress("user_123", sessions, week_start)
        self.assertEqual(progress.this_week_count, 1)
        self.assertEqual(progress.avg_accuracy, 95.0)
        self.assertEqual(progress.perfect_count, 1)

    def test_multiple_sessions_same_day(self):
        """Multiple sessions on same day"""
        today = datetime.utcnow()
        today_str = today.strftime("%Y-%m-%d")
        week_start = (today - timedelta(days=today.weekday())).strftime("%Y-%m-%d")

        sessions = [
            {
                "date_time": f"{today_str}T10:00:00Z",
                "surah": 1,
                "ayah": 1,
                "accuracy_score": 90,
                "duration_seconds": 600,
                "mistakes": []
            },
            {
                "date_time": f"{today_str}T14:00:00Z",
                "surah": 2,
                "ayah": 1,
                "accuracy_score": 95,
                "duration_seconds": 600,
                "mistakes": []
            }
        ]

        progress = get_weekly_progress("user_123", sessions, week_start)
        self.assertEqual(progress.this_week_count, 2)
        self.assertEqual(progress.avg_accuracy, 92.5)
        self.assertEqual(progress.perfect_count, 1)

    def test_daily_breakdown(self):
        """Daily breakdown shows correct days"""
        today = datetime.utcnow()
        week_start = (today - timedelta(days=today.weekday())).strftime("%Y-%m-%d")

        # Add sessions for Mon, Wed, Fri
        sessions = []
        for offset in [0, 2, 4]:  # Mon (0), Wed (2), Fri (4)
            date = (today - timedelta(days=today.weekday() - offset)).strftime("%Y-%m-%d")
            sessions.append({
                "date_time": f"{date}T10:00:00Z",
                "surah": 1,
                "ayah": 1,
                "accuracy_score": 90,
                "duration_seconds": 600,
                "mistakes": []
            })

        progress = get_weekly_progress("user_123", sessions, week_start)

        # Check that days with sessions are marked
        active_days = [d for d in progress.days if d.has_session]
        self.assertEqual(len(active_days), 3)


class TestMistakeAggregation(unittest.TestCase):
    """Test mistake aggregation logic"""

    def test_no_mistakes(self):
        """Empty mistakes list"""
        summary = get_mistakes_summary("user_123", [])
        self.assertEqual(summary.total_mistakes, 0)
        self.assertEqual(len(summary.by_ayah), 0)

    def test_single_mistake(self):
        """Single mistake is aggregated"""
        mistakes = [{
            "word": "الحمد",
            "ayah": 2,
            "surah": 1,
            "similarity": 0.75,
            "error_type": "mispronunciation",
            "date_time": "2026-04-14T10:00:00Z",
            "occurred_at": "2026-04-14T10:00:00Z"
        }]

        summary = get_mistakes_summary("user_123", mistakes)
        self.assertEqual(summary.total_mistakes, 1)
        self.assertEqual(len(summary.by_ayah), 1)
        self.assertEqual(summary.by_ayah[0].mistake_count, 1)

    def test_multiple_mistakes_same_word(self):
        """Same word in multiple sessions is counted"""
        mistakes = [
            {
                "word": "الحمد",
                "ayah": 2,
                "surah": 1,
                "similarity": 0.75,
                "error_type": "mispronunciation",
                "date_time": "2026-04-14T10:00:00Z",
                "occurred_at": "2026-04-14T10:00:00Z"
            },
            {
                "word": "الحمد",
                "ayah": 2,
                "surah": 1,
                "similarity": 0.80,
                "error_type": "mispronunciation",
                "date_time": "2026-04-13T10:00:00Z",
                "occurred_at": "2026-04-13T10:00:00Z"
            }
        ]

        summary = get_mistakes_summary("user_123", mistakes)
        self.assertEqual(summary.total_mistakes, 2)
        self.assertEqual(summary.by_ayah[0].mistake_count, 2)
        self.assertEqual(len(summary.by_ayah[0].words), 1)
        self.assertEqual(summary.by_ayah[0].words[0].times, 2)

    def test_mistakes_by_ayah_sorted(self):
        """Mistakes sorted by count descending"""
        mistakes = [
            {"word": "الحمد", "ayah": 2, "surah": 1, "similarity": 0.75, "error_type": "mispronunciation", "date_time": "2026-04-14T10:00:00Z", "occurred_at": "2026-04-14T10:00:00Z"},
            {"word": "الحمد", "ayah": 2, "surah": 1, "similarity": 0.80, "error_type": "mispronunciation", "date_time": "2026-04-13T10:00:00Z", "occurred_at": "2026-04-13T10:00:00Z"},
            {"word": "الله", "ayah": 3, "surah": 1, "similarity": 0.85, "error_type": "mispronunciation", "date_time": "2026-04-12T10:00:00Z", "occurred_at": "2026-04-12T10:00:00Z"},
        ]

        summary = get_mistakes_summary("user_123", mistakes)
        self.assertEqual(summary.total_mistakes, 3)
        # Ayah 2 should be first (2 mistakes)
        self.assertEqual(summary.by_ayah[0].ayah, 2)
        self.assertEqual(summary.by_ayah[0].mistake_count, 2)


class TestMinutesCalculation(unittest.TestCase):
    """Test minutes calculation"""

    def test_today_minutes(self):
        """Calculate today's minutes"""
        today = datetime.utcnow().strftime("%Y-%m-%d")
        sessions = [
            {
                "date_time": f"{today}T10:00:00Z",
                "duration_seconds": 600  # 10 minutes
            },
            {
                "date_time": f"{today}T14:00:00Z",
                "duration_seconds": 300  # 5 minutes
            }
        ]

        minutes = get_today_minutes(sessions, today)
        self.assertEqual(minutes, 15)

    def test_week_minutes(self):
        """Calculate this week's minutes"""
        today = datetime.utcnow()
        week_start = today - timedelta(days=today.weekday())

        sessions = []
        for i in range(7):
            date = (week_start + timedelta(days=i)).strftime("%Y-%m-%d")
            sessions.append({
                "date_time": f"{date}T10:00:00Z",
                "duration_seconds": 600  # 10 minutes each
            })

        minutes = get_this_week_minutes(sessions)
        self.assertEqual(minutes, 70)  # 7 days × 10 minutes


if __name__ == '__main__':
    unittest.main()

