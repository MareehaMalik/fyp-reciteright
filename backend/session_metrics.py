# -*- coding: utf-8 -*-
"""
Session metrics calculation and aggregation
Computes progress, streaks, and mistake summaries from stored sessions
"""
from typing import List, Dict, Any, Optional, Tuple
from datetime import datetime, timedelta
from collections import defaultdict
from session_models import (
    RecitationSession, Mistake, DailyActivity, RecentRecitation,
    WeeklyProgressSummary, AyahMistakeSummary, MistakeWord,
    MistakesSummary, HomeMetricsWithStreak
)
from gamification_logic import SURAH_NAMES


def get_weekly_progress(user_id: str, sessions: List[Dict[str, Any]], week_start_date: str) -> WeeklyProgressSummary:
    """
    Calculate weekly progress metrics

    Args:
        user_id: User ID
        sessions: List of recitation session dicts
        week_start_date: Monday date (YYYY-MM-DD)

    Returns:
        WeeklyProgressSummary with metrics and daily breakdown
    """
    start = datetime.strptime(week_start_date, "%Y-%m-%d")
    end = start + timedelta(days=6)
    end_str = end.strftime("%Y-%m-%d")

    # Filter sessions this week
    week_sessions = []
    for s in sessions:
        session_date = s.get("date_time", "")[:10]
        if week_start_date <= session_date <= end_str:
            week_sessions.append(s)

    # Calculate metrics
    this_week_count = len(week_sessions)
    perfect_count = sum(1 for s in week_sessions if s.get("accuracy_score", 0) >= 95)

    # Average accuracy
    if week_sessions:
        avg_accuracy = sum(s.get("accuracy_score", 0) for s in week_sessions) / len(week_sessions)
    else:
        avg_accuracy = 0.0

    # Daily breakdown
    days = []
    daily_data = defaultdict(lambda: {"session_count": 0, "total_minutes": 0, "accuracies": []})

    for s in week_sessions:
        session_date = s.get("date_time", "")[:10]
        daily_data[session_date]["session_count"] += 1
        daily_data[session_date]["total_minutes"] += s.get("duration_seconds", 0) // 60
        daily_data[session_date]["accuracies"].append(s.get("accuracy_score", 0))

    day_names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    for i in range(7):
        date = (start + timedelta(days=i)).strftime("%Y-%m-%d")
        day_name = day_names[i]

        day_info = daily_data.get(date, {})
        has_session = date in daily_data

        days.append(DailyActivity(
            day=day_name,
            date=date,
            has_session=has_session,
            session_count=day_info.get("session_count", 0),
            total_minutes=day_info.get("total_minutes", 0),
            avg_accuracy=sum(day_info.get("accuracies", [])) / len(day_info.get("accuracies", [])) if day_info.get("accuracies") else 0.0
        ))

    # Recent recitations (last 10)
    recent = []
    for s in week_sessions[:10]:
        surah_num = s.get("surah", 1)
        ayah = s.get("ayah", 1)
        surah_name = SURAH_NAMES.get(surah_num, f"Surah {surah_num}")
        mode = s.get("mode", "recitation")
        accuracy = s.get("accuracy_score", 0)
        session_id = s.get("id", "")
        date_time = s.get("date_time", "")

        # Calculate days ago
        session_dt = datetime.fromisoformat(date_time.replace("Z", "+00:00"))
        now = datetime.now(session_dt.tzinfo)
        days_ago = (now - session_dt).days

        title = f"{surah_name} {ayah}"

        recent.append(RecentRecitation(
            title=title,
            mode=mode,
            accuracy=accuracy,
            days_ago=days_ago,
            session_id=session_id,
            date_time=date_time
        ))

    return WeeklyProgressSummary(
        this_week_count=this_week_count,
        avg_accuracy=round(avg_accuracy, 1),
        perfect_count=perfect_count,
        days=days,
        recent_recitations=recent
    )


def get_recent_recitations(user_id: str, sessions: List[Dict[str, Any]], limit: int = 10) -> List[RecentRecitation]:
    """
    Get N most recent recitations

    Args:
        user_id: User ID
        sessions: List of recitation session dicts
        limit: Number of recitations to return

    Returns:
        List of RecentRecitation objects
    """
    recent = []

    for s in sessions[:limit]:
        surah_num = s.get("surah", 1)
        ayah = s.get("ayah", 1)
        surah_name = SURAH_NAMES.get(surah_num, f"Surah {surah_num}")
        mode = s.get("mode", "recitation")
        accuracy = s.get("accuracy_score", 0)
        session_id = s.get("id", "")
        date_time = s.get("date_time", "")

        # Calculate days ago
        try:
            session_dt = datetime.fromisoformat(date_time.replace("Z", "+00:00"))
            now = datetime.now(session_dt.tzinfo)
            days_ago = (now - session_dt).days
        except:
            days_ago = 0

        title = f"{surah_name} {ayah}"

        recent.append(RecentRecitation(
            title=title,
            mode=mode,
            accuracy=accuracy,
            days_ago=days_ago,
            session_id=session_id,
            date_time=date_time
        ))

    return recent


def get_current_streak_from_sessions(sessions: List[Dict[str, Any]], today: Optional[str] = None) -> Tuple[int, int, Optional[str]]:
    """
    Calculate current and longest streak from sessions

    Args:
        sessions: List of recitation session dicts
        today: Today's date (YYYY-MM-DD), defaults to now

    Returns:
        Tuple of (current_streak, longest_streak, last_session_date)
    """
    if not sessions:
        return 0, 0, None

    if today is None:
        today = datetime.utcnow().strftime("%Y-%m-%d")

    # Get unique active dates sorted descending
    active_dates = sorted(set(s.get("date_time", "")[:10] for s in sessions))
    active_dates = [d for d in active_dates if d]  # Remove empty strings

    if not active_dates:
        return 0, 0, None

    active_dates.reverse()  # Descending order

    today_dt = datetime.strptime(today, "%Y-%m-%d").date()
    last_session_date = active_dates[0]

    # Check if last session was today or yesterday
    last_session_dt = datetime.strptime(last_session_date, "%Y-%m-%d").date()
    days_since_last = (today_dt - last_session_dt).days

    # Count consecutive days starting from the most recent activity.
    # If no activity today/yesterday, this still returns the last active streak.
    current_streak = 1
    for i in range(1, len(active_dates)):
        prev_date_str = active_dates[i]
        curr_date_str = active_dates[i-1]

        prev_date = datetime.strptime(prev_date_str, "%Y-%m-%d").date()
        curr_date = datetime.strptime(curr_date_str, "%Y-%m-%d").date()

        days_diff = (curr_date - prev_date).days
        if days_diff == 1:
            current_streak += 1
        else:
            break

    # Calculate longest streak
    longest_streak = current_streak
    temp_streak = 1

    for i in range(1, len(active_dates)):
        prev_date_str = active_dates[i]
        curr_date_str = active_dates[i-1]

        prev_date = datetime.strptime(prev_date_str, "%Y-%m-%d").date()
        curr_date = datetime.strptime(curr_date_str, "%Y-%m-%d").date()

        days_diff = (curr_date - prev_date).days
        if days_diff == 1:
            temp_streak += 1
            longest_streak = max(longest_streak, temp_streak)
        else:
            temp_streak = 1

    return current_streak, longest_streak, last_session_date


def get_mistakes_summary(user_id: str, all_mistakes: List[Dict[str, Any]]) -> MistakesSummary:
    """
    Aggregate mistakes by ayah and word

    Args:
        user_id: User ID
        all_mistakes: List of all mistake dicts from sessions

    Returns:
        MistakesSummary with grouped mistakes
    """
    if not all_mistakes:
        return MistakesSummary(by_ayah=[], total_mistakes=0)

    # Group by ayah
    by_ayah_dict = defaultdict(lambda: {
        "surah": 0,
        "surah_name": "",
        "ayah": 0,
        "mistakes": [],
        "last_practiced": None
    })

    most_recent_mistake_at = None

    for mistake in all_mistakes:
        surah = mistake.get("surah", 1)
        ayah = mistake.get("ayah", 1)
        key = (surah, ayah)

        by_ayah_dict[key]["surah"] = surah
        by_ayah_dict[key]["surah_name"] = SURAH_NAMES.get(surah, f"Surah {surah}")
        by_ayah_dict[key]["ayah"] = ayah
        by_ayah_dict[key]["mistakes"].append(mistake)
        by_ayah_dict[key]["last_practiced"] = mistake.get("date_time", by_ayah_dict[key]["last_practiced"])

        # Track most recent mistake
        occurred_at = mistake.get("occurred_at", "")
        if occurred_at and (not most_recent_mistake_at or occurred_at > most_recent_mistake_at):
            most_recent_mistake_at = occurred_at

    # Convert to AyahMistakeSummary objects
    ayah_summaries = []

    for (surah, ayah), data in by_ayah_dict.items():
        mistakes = data["mistakes"]

        # Group words within this ayah
        words_dict = defaultdict(lambda: {"times": 0, "last_similarity": 0})

        for mistake in mistakes:
            word = mistake.get("word", "")
            similarity = mistake.get("similarity", 0)

            words_dict[word]["times"] += 1
            words_dict[word]["last_similarity"] = max(words_dict[word]["last_similarity"], similarity)

        # Convert to MistakeWord objects
        words = [
            MistakeWord(
                word=word,
                times=word_data["times"],
                last_similarity=word_data["last_similarity"],
                last_occurred_at=max(
                    (m.get("date_time", "") for m in mistakes if m.get("word") == word),
                    default=""
                )
            )
            for word, word_data in words_dict.items()
        ]

        # Sort by frequency
        words.sort(key=lambda w: w.times, reverse=True)

        summary = AyahMistakeSummary(
            surah_number=surah,
            surah_name=data["surah_name"],
            ayah=ayah,
            mistake_count=len(mistakes),
            last_practiced_at=data["last_practiced"] or "",
            words=words
        )

        ayah_summaries.append(summary)

    # Sort by mistake count descending
    ayah_summaries.sort(key=lambda a: a.mistake_count, reverse=True)

    return MistakesSummary(
        by_ayah=ayah_summaries,
        total_mistakes=len(all_mistakes),
        most_recent_mistake_at=most_recent_mistake_at
    )


def get_today_minutes(sessions: List[Dict[str, Any]], today: Optional[str] = None) -> int:
    """Get total minutes practiced today"""
    if today is None:
        today = datetime.utcnow().strftime("%Y-%m-%d")

    today_sessions = [s for s in sessions if s.get("date_time", "")[:10] == today]
    return sum(s.get("duration_seconds", 0) // 60 for s in today_sessions)


def get_this_week_minutes(sessions: List[Dict[str, Any]]) -> int:
    """Get total minutes practiced this week"""
    today = datetime.utcnow().strftime("%Y-%m-%d")
    start = datetime.strptime(today, "%Y-%m-%d")
    week_start = start - timedelta(days=start.weekday())
    week_start_str = week_start.strftime("%Y-%m-%d")

    week_sessions = [s for s in sessions if s.get("date_time", "")[:10] >= week_start_str]
    return sum(s.get("duration_seconds", 0) // 60 for s in week_sessions)

