# -*- coding: utf-8 -*-
"""
Sample data generator for testing gamification endpoints
Run this to populate test data
"""
import json
import os
from datetime import datetime, timedelta
import uuid
from database import get_database
from gamification_models import Session

def generate_sample_data():
    """Generate sample user and session data for testing"""
    db = get_database()

    # Create test user
    test_user_id = "user_test_123"

    # Create user profile if not exists
    existing_user = db.get_user(test_user_id)
    if existing_user:
        print(f"ℹ️ User {test_user_id} already exists")
        return test_user_id

    user = db.create_user(
        user_id=test_user_id,
        name="Test User",
        email="test@example.com",
        daily_goal_minutes=10
    )
    print(f"✅ Created user: {user['id']}")

    # Generate sample sessions (last 14 days)
    today = datetime.utcnow()
    sessions_created = 0

    for days_ago in range(14):
        session_date = today - timedelta(days=days_ago)
        date_str = session_date.strftime("%Y-%m-%d")

        # Create 1-2 sessions per day
        num_sessions = 1 if days_ago % 2 == 0 else 2

        for _ in range(num_sessions):
            session_data = {
                "id": str(uuid.uuid4()),
                "user_id": test_user_id,
                "surah": (days_ago % 5) + 1,  # Surahs 1-5
                "start_ayah": (days_ago % 10) + 1,
                "end_ayah": (days_ago % 10) + 3,
                "duration_minutes": float(5 + (days_ago % 10)),
                "date": date_str,
                "accuracy_score": 75.0 + (days_ago % 15),  # 75-89
                "mode": "recitation",
                "created_at": session_date.isoformat() + "Z",
                "xp_earned": int(100 + (days_ago * 5))
            }

            db.save_session(test_user_id, session_data)
            sessions_created += 1

            # Update XP
            db.update_user_xp(test_user_id, session_data["xp_earned"])

    print(f"✅ Created {sessions_created} sample sessions")

    # Generate sample memorization progress
    memo_progress = {}
    for surah in range(1, 6):
        memo_progress[surah] = {
            "user_id": test_user_id,
            "surah": surah,
            "ayah_count_memorized": (surah * 3),  # 3, 6, 9, 12, 15 ayahs
            "last_reviewed_at": (today - timedelta(days=surah)).isoformat() + "Z",
            "high_accuracy_sessions": {
                i: 3 for i in range(1, (surah * 3) + 1)
            }
        }

    db.save_memorization_progress(test_user_id, memo_progress)
    print(f"✅ Created memorization progress for 5 surahs")

    print(f"\n✅ Sample data generation complete!")
    print(f"Test user ID: {test_user_id}")
    print(f"Ready to test at: http://localhost:8000/api/gamification/home-metrics?userId={test_user_id}")

    return test_user_id

if __name__ == "__main__":
    generate_sample_data()

